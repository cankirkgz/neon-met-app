import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:neon_met_app/widgets/atoms/search_field.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:neon_met_app/widgets/molecules/highlight_message_card.dart';
import 'package:neon_met_app/viewmodel/department_viewmodel.dart';

@RoutePage()
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DepartmentViewModel>();

    // Kick off the initial load if needed
    if (!vm.isLoading && vm.allDepartments.isEmpty && vm.errorMessage == null) {
      Future.microtask(vm.fetchDepartments);
    }

    final list = vm.departments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('The Met Collection',
            style: TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              const HighlightMessageCard(
                imageName: 'img_collection_01.png',
                text:
                    'Travel around the world and across 5,000 years of history through 490,000+ works of art.',
              ),
              const SizedBox(height: 24),

              // — SEARCH FIELD —
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchField(
                  onChanged: vm.filterDepartments,
                ),
              ),
              const SizedBox(height: 32),

              if (vm.errorMessage != null)
                Center(child: Text('Hata: ${vm.errorMessage}'))
              else if (vm.isLoading && vm.allDepartments.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 64),
                  child: Center(
                    child: Text(
                      "No results found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                // — SHOW FILTERED DEPARTMENTS —
                ...list.asMap().entries.map((entry) {
                  final index = entry.key;
                  final dept = entry.value;
                  final imgIndex = (index + 2).toString().padLeft(2, '0');
                  final assetImage =
                      'assets/images/img_collection_$imgIndex.png';
                  final imageUrl = vm.departmentImages[dept.departmentId];
                  final isAsset = imageUrl == null;
                  final imagePath = imageUrl ?? assetImage;

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ArtworkCard(
                      image: imagePath,
                      isAsset: isAsset,
                      title: dept.displayName,
                      width: MediaQuery.of(context).size.width - 40,
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
                }),
            ],
          ),
        ),
      ),
    );
  }
}
