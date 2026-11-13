import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes audio mikrofon (loopback): rekam beberapa detik lalu putar kembali
// untuk memverifikasi mikrofon + speaker. Izin RECORD_AUDIO diminta saat
// tes dijalankan, bukan saat aplikasi dibuka.
class AudioMikrofonTestScreen extends StatefulWidget {
  const AudioMikrofonTestScreen({super.key});

  @override
  State<AudioMikrofonTestScreen> createState() =>
      _AudioMikrofonTestScreenState();
}

enum _Fase { awal, merekam, siapPutar, gagal }

class _AudioMikrofonTestScreenState extends State<AudioMikrofonTestScreen> {
  final AudioRecorder _record = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  _Fase _fase = _Fase.awal;
  bool _izinDitolak = false;
  int _sisaDetik = 3;
  Timer? _timer;
  String? _pathRekam;
  String? _pesan;

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_record.cancel());
    unawaited(_record.dispose());
    unawaited(_player.dispose());
    unawaited(_hapusFileRekaman());
    super.dispose();
  }

  Future<void> _hapusFileRekaman() async {
    final path = _pathRekam;
    if (path == null) {
      return;
    }
    try {
      final berkas = File(path);
      if (await berkas.exists()) {
        await berkas.delete();
      }
    } catch (error) {
      debugPrint('Gagal menghapus berkas rekaman: $error');
    }
  }

  Future<void> _mulaiRekam() async {
    try {
      final diizinkan = await _record.hasPermission();
      if (!diizinkan) {
        if (mounted) {
          setState(() => _izinDitolak = true);
        }
        return;
      }
      _pathRekam ??= await _pathBaru();
      await _record.start(const RecordConfig(), path: _pathRekam!);
      if (!mounted) {
        return;
      }
      setState(() {
        _fase = _Fase.merekam;
        _sisaDetik = 3;
        _pesan = null;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() => _sisaDetik -= 1);
        if (_sisaDetik <= 0) {
          timer.cancel();
          unawaited(_stopRekam());
        }
      });
    } catch (error) {
      debugPrint('Gagal memulai perekaman: $error');
      if (mounted) {
        setState(() {
          _fase = _Fase.gagal;
          _pesan = 'Gagal memulai perekaman.';
        });
      }
    }
  }

  Future<String> _pathBaru() async {
    final direktori = await getTemporaryDirectory();
    return '${direktori.path}/spektra_tes_mikrofon.m4a';
  }

  Future<void> _stopRekam() async {
    try {
      await _record.stop();
    } catch (error) {
      debugPrint('Gagal menghentikan perekaman: $error');
    }
    if (mounted) {
      setState(() => _fase = _Fase.siapPutar);
    }
  }

  Future<void> _putarUlang() async {
    final path = _pathRekam;
    if (path == null) {
      return;
    }
    try {
      await _player.play(DeviceFileSource(path));
    } catch (error) {
      debugPrint('Gagal memutar ulang rekaman: $error');
      if (mounted) {
        setState(() => _pesan = 'Gagal memutar ulang rekaman.');
      }
    }
  }

  void _selesaikan(StatusTes status) {
    Navigator.of(context).pop(
      HasilTes(id: 'audio_mikrofon', label: 'Audio Mikrofon', status: status),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Audio Mikrofon')),
        body: const PesanHanyaAndroid(),
      );
    }
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Mikrofon')),
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
                    Icons.mic_none_outlined,
                    size: 72,
                    color: tema.colorScheme.primary,
                  ),
                  if (_izinDitolak) ...[
                    Text(
                      'Izin mikrofon ditolak. Tes tidak dapat dijalankan. '
                      'Berikan izin lewat pengaturan aplikasi.',
                      style: tema.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    FilledButton(
                      onPressed: () => _selesaikan(StatusTes.tidakTersedia),
                      child: const Text('Tandai Tidak tersedia'),
                    ),
                  ] else if (_fase == _Fase.merekam) ...[
                    Text(
                      'Merekam… $_sisaDetik detik',
                      style: tema.textTheme.titleMedium,
                    ),
                    const LinearProgressIndicator(),
                    OutlinedButton(
                      onPressed: () {
                        _timer?.cancel();
                        unawaited(_stopRekam());
                      },
                      child: const Text('Berhenti'),
                    ),
                  ] else if (_fase == _Fase.siapPutar) ...[
                    const Text(
                      'Rekaman selesai. Tekan putar ulang untuk memverifikasi suara.',
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
                      onPressed: _putarUlang,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Putar ulang rekaman'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _mulaiRekam,
                      icon: const Icon(Icons.mic),
                      label: const Text('Rekam lagi'),
                    ),
                  ] else ...[
                    Text(
                      'Tes ini merekam suara Anda selama 3 detik, lalu memutarnya '
                      'kembali. Suara tidak disimpan atau dikirim ke mana pun.',
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
                      onPressed: _mulaiRekam,
                      icon: const Icon(Icons.mic),
                      label: const Text('Mulai rekam (3 detik)'),
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
