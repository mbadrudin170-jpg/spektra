import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes getar via `HapticFeedback` (Flutter SDK, tanpa package).
class GetarTestScreen extends StatelessWidget {
  const GetarTestScreen({super.key});

  void _selesaikan(BuildContext context, StatusTes status) {
    Navigator.of(context)
        .pop(HasilTes(id: 'getar', label: 'Getar', status: status));
  }

  Future<void> _pendek() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (error) {
      debugPrint('HapticFeedback gagal (pendek): $error');
    }
  }

  Future<void> _panjang() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (error) {
      debugPrint('HapticFeedback gagal (panjang): $error');
    }
  }

  Future<void> _pola() async {
    try {
      await HapticFeedback.selectionClick();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.selectionClick();
    } catch (error) {
      debugPrint('HapticFeedback gagal (pola): $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Getar')),
        body: const PesanHanyaAndroid(),
      );
    }
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Getar')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  Icon(
                    Icons.vibration,
                    size: 72,
                    color: tema.colorScheme.primary,
                  ),
                  Text(
                    'Ketuk tombol untuk memicu getar, lalu rasakan apakah perangkat bergetar.',
                    style: tema.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  FilledButton.icon(
                    onPressed: _pendek,
                    icon: const Icon(Icons.flash_on, size: 18),
                    label: const Text('Getar pendek'),
                  ),
                  FilledButton.icon(
                    onPressed: _panjang,
                    icon: const Icon(Icons.flash_on, size: 18),
                    label: const Text('Getar panjang'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _pola,
                    icon: const Icon(Icons.more_horiz, size: 18),
                    label: const Text('Pola getar (pendek–panjang–pendek)'),
                  ),
                ],
              ),
            ),
          ),
          TesFooter(
            onLulus: () => _selesaikan(context, StatusTes.lulus),
            onGagal: () => _selesaikan(context, StatusTes.gagal),
            onTidakTersedia: () =>
                _selesaikan(context, StatusTes.tidakTersedia),
          ),
        ],
      ),
    );
  }
}
