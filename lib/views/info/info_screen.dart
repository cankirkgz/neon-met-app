import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:provider/provider.dart';
import 'package:neon_met_app/widgets/molecules/highlight_message_card.dart';
import 'package:neon_met_app/widgets/molecules/location_card.dart';
import 'package:neon_met_app/viewmodel/info_viewmodel.dart';

@RoutePage()
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InfoViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text('Info', style: TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HighlightMessageCard(
                imageName: 'img_info_01.png',
                text:
                    'The Met presents over 5,000 years of art from around the world for everyone to experience and enjoy.',
              ),
              const SizedBox(height: 24),
              const Text('Locations and Hours',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              ...vm.locations
                  .map((loc) => LocationCard(location: loc))
                  ,
            ],
          ),
        ),
      ),
    );
  }
}
