import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes audio speaker: memutar nada uji (sine 440 Hz, 2 detik) yang disertakan
// di aset aplikasi; pengguna menilai apakah nada terdengar.
class AudioSpeakerTestScreen extends StatefulWidget {
  const AudioSpeakerTestScreen({super.key});

  @override
  State<AudioSpeakerTestScreen> createState() => _AudioSpeakerTestScreenState();
}

class _AudioSpeakerTestScreenState extends State<AudioSpeakerTestScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _memutar = false;
  String? _pesan;

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _putar() async {
    setState(() {
      _memutar = true;
      _pesan = null;
    });
    try {
      await _player.play(AssetSource('audio/nada_uji.wav'));
    } catch (error) {
      debugPrint('Gagal memutar nada uji: $error');
      if (mounted) {
        setState(() => _pesan = 'Gagal memutar nada uji.');
      }
    } finally {
      if (mounted) {
        setState(() => _memutar = false);
      }
    }
  }

  void _selesaikan(StatusTes status) {
    Navigator.of(context).pop(
      HasilTes(id: 'audio_speaker', label: 'Audio Speaker', status: status),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Audio Speaker')),
        body: const PesanHanyaAndroid(),
      );
    }
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Speaker')),
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
                    Icons.volume_up_outlined,
                    size: 72,
                    color: tema.colorScheme.primary,
                  ),
                  Text(
                    'Tekan tombol untuk memutar nada uji (sine 440 Hz, 2 detik). '
                    'Pastikan volume perangkat tidak dalam mode senyap.',
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
                    onPressed: _memutar ? null : _putar,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(_memutar ? 'Memutar…' : 'Putar nada uji'),
                  ),
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
