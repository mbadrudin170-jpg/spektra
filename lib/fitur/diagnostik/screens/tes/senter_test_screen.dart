import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes senter: menyalakan/mematikan flash kamera sebagai senter.
// `torch_light` memakai `CameraManager.setTorchMode` (tanpa izin CAMERA);
// flash dimatikan kembali otomatis saat layar ditutup.
class SenterTestScreen extends StatefulWidget {
  const SenterTestScreen({super.key});

  @override
  State<SenterTestScreen> createState() => _SenterTestScreenState();
}

class _SenterTestScreenState extends State<SenterTestScreen> {
  bool? _tersedia;
  bool _menyala = false;
  String? _pesan;

  @override
  void initState() {
    super.initState();
    unawaited(_cekKetersediaan());
  }

  @override
  void dispose() {
    if (_menyala) {
      unawaited(_matikan());
    }
    super.dispose();
  }

  Future<void> _cekKetersediaan() async {
    try {
      final ok = await TorchLight.isTorchAvailable();
      if (mounted) {
        setState(() => _tersedia = ok);
      }
    } catch (error) {
      debugPrint('Gagal memeriksa ketersediaan senter: $error');
      if (mounted) {
        setState(() => _tersedia = false);
      }
    }
  }

  Future<void> _matikan() async {
    try {
      await TorchLight.disableTorch();
    } catch (error) {
      debugPrint('Gagal mematikan senter: $error');
    }
  }

  Future<void> _toggle() async {
    try {
      if (_menyala) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      if (mounted) {
        setState(() => _menyala = !_menyala);
      }
    } on EnableTorchNotAvailableException {
      if (mounted) {
        setState(() => _pesan = 'Torch tidak tersedia di perangkat ini.');
      }
    } on Exception catch (error) {
      debugPrint('Gagal mengubah senter: $error');
      if (mounted) {
        setState(() => _pesan = 'Gagal mengubah senter.');
      }
    }
  }

  void _selesaikan(StatusTes status) {
    Navigator.of(context)
        .pop(HasilTes(id: 'senter', label: 'Senter', status: status));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Senter')),
        body: const PesanHanyaAndroid(),
      );
    }
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Senter')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  if (_tersedia == null) ...[
                    const LinearProgressIndicator(),
                    const Text('Memeriksa senter perangkat…'),
                  ] else if (!_tersedia!) ...[
                    Icon(
                      Icons.flashlight_off_outlined,
                      size: 72,
                      color: tema.colorScheme.outline,
                    ),
                    Text(
                      'Perangkat ini tidak memiliki flash/senter.',
                      style: tema.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    FilledButton(
                      onPressed: () => _selesaikan(StatusTes.tidakTersedia),
                      child: const Text('Tandai Tidak tersedia'),
                    ),
                  ] else ...[
                    Icon(
                      _menyala
                          ? Icons.flashlight_on
                          : Icons.flashlight_off_outlined,
                      size: 96,
                      color: _menyala ? Colors.amber : tema.colorScheme.primary,
                    ),
                    Text(
                      _menyala
                          ? 'Senter menyala. Arahkan flash ke objek atau tangan.'
                          : 'Tekan tombol untuk menyalakan senter.',
                      style: tema.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (_pesan != null)
                      Text(
                        _pesan!,
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: tema.colorScheme.error,
                        ),
                      ),
                    FilledButton.icon(
                      onPressed: _toggle,
                      icon: Icon(
                        _menyala
                            ? Icons.flashlight_off_outlined
                            : Icons.flashlight_on_outlined,
                      ),
                      label: Text(_menyala ? 'Matikan' : 'Nyalakan'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          TesFooter(
            onLulus: () => _selesaikan(StatusTes.lulus),
            onGagal: () => _selesaikan(StatusTes.gagal),
            onTidakTersedia: () => _selesaikan(StatusTes.tidakTersedia),
          ),
        ],
      ),
    );
  }
}
