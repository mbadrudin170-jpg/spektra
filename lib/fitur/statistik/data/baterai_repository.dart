import 'package:battery_info_v2/battery_info_plugin.dart';
import 'package:battery_info_v2/model/android_battery_info.dart';
import 'package:flutter/foundation.dart';

import 'package:spektra/fitur/statistik/model/baterai_info.dart';

// Membaca snapshot info baterai Android; nilai yang tidak valid/tidak tersedia
// dikembalikan sebagai `null` agar UI menampilkan `Tidak diketahui`.
//
// `battery_info_v2` hanya membaca properti Android publik (`BATTERY_PROPERTY_*`)
// dan intent `ACTION_BATTERY_CHANGED`; kapasitas desain pabrik tidak tersedia.
// iOS/web tidak didukung (keputusan diskusi_2) — kembalikan `null`.
class BateraiRepository {
  Future<BateraiInfo?> ambilInfo() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }
    try {
      final info = await BatteryInfoPlugin().androidBatteryInfo;
      if (info == null) {
        return null;
      }
      return _dariAndroid(info);
    } catch (error) {
      debugPrint('Gagal membaca info baterai: $error');
      return null;
    }
  }

  static BateraiInfo _dariAndroid(AndroidBatteryInfo info) {
    return BateraiInfo(
      kapasitasTersisaMah: _mikroAhKeMah(info.batteryCapacity),
      levelPersen: _levelValid(info.batteryLevel),
      statusPengisian: _statusValid(info.chargingStatus?.name),
      sumberCharger: _teksValid(info.pluggedStatus),
      kesehatan: _teksValid(info.health),
      suhuCelcius: _positifAtauNull(info.temperature),
      teganganMv: _positifAtauNull(info.voltage),
      teknologi: _teksValid(info.technology),
    );
  }

  // Charge counter ≤ 0 tidak bermakna; jangan tampilkan sebagai data sah.
  static int? _mikroAhKeMah(int? mikroAh) {
    if (mikroAh == null || mikroAh <= 0) {
      return null;
    }
    return (mikroAh / 1000).round();
  }

  // Level di luar 0–100 dianggap tidak valid; -1 berarti perangkat tidak
  // menyediakan nilai.
  static int? _levelValid(int? level) {
    if (level == null || level < 0 || level > 100) {
      return null;
    }
    return level;
  }

  static int? _positifAtauNull(int? nilai) {
    if (nilai == null || nilai <= 0) {
      return null;
    }
    return nilai;
  }

  // String bawaan bernilai "unknown"/"-1" dianggap tidak tersedia.
  static String? _teksValid(String? nilai) {
    if (nilai == null) {
      return null;
    }
    final teks = nilai.trim();
    if (teks.isEmpty ||
        teks.toLowerCase() == 'unknown' ||
        teks == '-1' ||
        teks == '?') {
      return null;
    }
    return teks;
  }

  // `ChargingStatus.Unknown` (dan nilai di luar 0–3) dianggap tidak tersedia.
  static String? _statusValid(String? status) {
    return _teksValid(status?.toLowerCase());
  }
}
