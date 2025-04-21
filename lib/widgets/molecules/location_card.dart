import 'package:flutter/material.dart';
import 'package:neon_met_app/data/models/location_info.dart';

class LocationCard extends StatelessWidget {
  final LocationInfo location;

  const LocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Görsel ----------
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              location.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // ---------- Başlık ----------
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              location.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 4),
          _InfoRow(label: 'Hours:', value: location.hours),
          if (location.extendedHours != null)
            _InfoRow(label: 'Extended:', value: location.extendedHours!),
          _InfoRow(label: 'Address:', value: location.address),
          _InfoRow(label: 'Phone:', value: location.phone),
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
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
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
