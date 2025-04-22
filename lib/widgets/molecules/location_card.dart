import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';
import 'package:neon_met_app/data/models/location_info.dart';

class LocationCard extends StatelessWidget {
  final LocationInfo location;

  const LocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Görsel
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            child: Image.asset(
              location.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Başlık
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spacingS),
            child: Text(
              location.title,
              style: const TextStyle(
                fontSize: AppSizes.fontXL,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: AppSizes.spacingXS),
          _InfoRow(label: AppStrings.hours, value: location.hours),
          if (location.extendedHours != null)
            _InfoRow(
                label: AppStrings.extended, value: location.extendedHours!),
          _InfoRow(label: AppStrings.address, value: location.address),
          _InfoRow(label: AppStrings.phone, value: location.phone),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingXS / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: AppSizes.spacingXS),
          Expanded(
            child: Text(
              value,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
