import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Uygulama açılışında görünen animasyon + açıklama metni
class SplashAnimation extends StatelessWidget {
  const SplashAnimation({
    super.key,
    this.lottiePath = 'assets/lotties/loading.json',
    this.caption =
        "The MET's collection includes world‑famous names from Van Gogh to Tutankhamun!",
  });

  /// Lottie dosyasının yolu
  final String lottiePath;

  /// Alt tarafta gösterilecek metin
  final String caption;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ---------- Animasyon ----------
        Lottie.asset(
          lottiePath,
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 24),

        // ---------- Açıklama ----------
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            caption,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
