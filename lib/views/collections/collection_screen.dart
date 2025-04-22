import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_string.dart';
import 'package:provider/provider.dart';

import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/viewmodel/department_viewmodel.dart';
import 'package:neon_met_app/widgets/atoms/search_field.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:neon_met_app/widgets/molecules/highlight_message_card.dart';
import 'package:neon_met_app/routes/app_router.dart';

@RoutePage()
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DepartmentViewModel>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isPortraitPhone = !isLandscape && !isTablet;

    if (!vm.isLoading && vm.allDepartments.isEmpty && vm.errorMessage == null) {
      Future.microtask(vm.fetchDepartments);
    }

    final list = vm.departments;

    final appBar = AppBar(
      title: const Text(
        AppStrings.collectionTitle,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => vm.fetchDepartments(),
          child: isPortraitPhone
              ? _buildPortrait(context, vm, list)
              : _buildWide(context, vm, list),
        ),
      ),
    );
  }

  Widget _buildPortrait(
      BuildContext context, DepartmentViewModel vm, List list) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingM),
      child: Column(
        children: [
          const HighlightMessageCard(
            imageName: 'img_collection_01.png',
            text: AppStrings.collectionHighlight,
          ),
          const SizedBox(height: AppSizes.spacingL),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingM),
            child: SearchField(onChanged: vm.filterDepartments),
          ),
          const SizedBox(height: AppSizes.spacingXL),
          _buildDepartmentList(context, vm, list, isWide: false),
        ],
      ),
    );
  }

  Widget _buildWide(BuildContext context, DepartmentViewModel vm, List list) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HighlightMessageCard(
                  imageName: 'img_collection_01.png',
                  text: AppStrings.collectionHighlight,
                ),
                const SizedBox(height: AppSizes.spacingL),
                const Text(
                  AppStrings.searchDepartments,
                  style: TextStyle(
                    fontSize: AppSizes.fontXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingS),
                SearchField(onChanged: vm.filterDepartments),
              ],
            ),
          ),
        ),
        Container(width: 1, color: AppColors.textSecondary[300]),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacingM),
            child: _buildDepartmentList(context, vm, list, isWide: true),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentList(
      BuildContext context, DepartmentViewModel vm, List list,
      {required bool isWide}) {
    if (vm.errorMessage != null) {
      return Center(child: Text('${AppStrings.error}: ${vm.errorMessage}'));
    } else if (vm.isLoading && vm.allDepartments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spacingXL * 2),
        child: Center(
          child: Text(
            AppStrings.noResultsFound,
            style: TextStyle(
              fontSize: AppSizes.fontL,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: list.asMap().entries.map((entry) {
        final index = entry.key;
        final dept = entry.value;
        final imgIndex = (index + 2).toString().padLeft(2, '0');
        final assetImage = 'assets/images/img_collection_$imgIndex.png';
        final imageUrl = vm.departmentImages[dept.departmentId];
        final isAsset = imageUrl == null;
        final imagePath = imageUrl ?? assetImage;

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spacingS,
            horizontal: AppSizes.spacingM,
          ),
          child: ArtworkCard(
            image: imagePath,
            isAsset: isAsset,
            title: dept.displayName,
            width: isWide
                ? double.infinity
                : MediaQuery.of(context).size.width - (AppSizes.spacingM * 2),
            onPressed: () {
              context.router.push(
                SearchCollectionsRoute(
                  departmentId: dept.departmentId,
                  departmentName: dept.displayName,
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
