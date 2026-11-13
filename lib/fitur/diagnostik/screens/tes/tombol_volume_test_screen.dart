import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes tombol volume: `MainActivity` mengirim event tombol Volume Up/Down
// lewat EventChannel `spektra/tombol_volume`; layar ini menunggu event
// dalam jendela waktu singkat — terbaca → lulus, tidak terbaca → gagal /
// tidak tersedia. Event diuji di perangkat fisik, bukan emulator (perilaku
// tombol volume bervariasi antar perangkat).
class TombolVolumeTestScreen extends StatefulWidget {
  const TombolVolumeTestScreen({super.key});

  @override
  State<TombolVolumeTestScreen> createState() => _TombolVolumeTestScreenState();
}

class _TombolVolumeTestScreenState extends State<TombolVolumeTestScreen> {
  static const _kanal = EventChannel('spektra/tombol_volume');

  StreamSubscription<dynamic>? _langganan;
  Timer? _timer;
  bool _terdeteksi = false;
  bool _gagalChannel = false;
  int _hitungMundur = 10;

  @override
  void initState() {
    super.initState();
    _mulai();
  }

  void _mulai() {
    try {
      _langganan = _kanal.receiveBroadcastStream().listen(
        (event) {
          if (_terdeteksi) {
            return;
          }
          _timer?.cancel();
          setState(() => _terdeteksi = true);
          Future<void>.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              _selesaikan(StatusTes.lulus);
            }
          });
        },
        onError: (Object error) {
          debugPrint('Event tombol volume error: $error');
          if (mounted) {
            setState(() => _gagalChannel = true);
          }
        },
      );
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() => _hitungMundur -= 1);
        if (_hitungMundur <= 0) {
          timer.cancel();
        }
      });
    } catch (error) {
      debugPrint('Gagal membuka kanal tombol volume: $error');
      setState(() => _gagalChannel = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_langganan?.cancel());
    super.dispose();
  }

  void _selesaikan(StatusTes status) {
    Navigator.of(context).pop(
      HasilTes(id: 'tombol_volume', label: 'Tombol Volume', status: status),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tombol Volume')),
        body: const PesanHanyaAndroid(),
      );
    }
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tombol Volume')),
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
                    _terdeteksi
                        ? Icons.check_circle_outline
                        : Icons.volume_down_outlined,
                    size: 72,
                    color: _terdeteksi
                        ? Colors.green
                        : tema.colorScheme.primary,
                  ),
                  if (_terdeteksi)
                    Text(
                      'Tombol volume terdeteksi. Menyelesaikan tes…',
                      style: tema.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    )
                  else if (_gagalChannel)
                    Text(
                      'Event tombol volume tidak dapat dibaca di platform ini.',
                      style: tema.textTheme.bodyLarge?.copyWith(
                        color: tema.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    Text(
                      'Tekan tombol volume (atas atau bawah) dalam $_hitungMundur detik…',
                      style: tema.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  if (!_terdeteksi && !_gagalChannel && _hitungMundur <= 0)
                    Text(
                      'Tidak ada event tombol terbaca. Pilih Gagal atau Tidak tersedia.',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
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
