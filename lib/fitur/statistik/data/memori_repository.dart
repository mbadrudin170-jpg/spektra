import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:spektra/fitur/statistik/model/memori_info.dart';

// Membaca snapshot info memori/penyimpanan Android; nilai yang tidak
// valid/tidak tersedia dikembalikan sebagai `null` agar UI menampilkan
// `Tidak diketahui`.
//
// Tipe memori (LPDDR) tidak tersedia lewat API publik — selalu `Tidak
// diketahui` pada versi awal (keputusan PRD A5). iOS/web tidak didukung —
// kembalikan `null` (keputusan PRD A5, Android-only).
class MemoriRepository {
  Future<MemoriInfo?> ambilInfo() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      final ramTotal = _nonNegatif(info.physicalRamSize);
      final ramTersedia = _nonNegatif(info.availableRamSize);
      final diskTotal = _nonNegatif(info.totalDiskSize);
      final diskBebas = _nonNegatif(info.freeDiskSize);
      return MemoriInfo(
        ramTotalMb: ramTotal,
        ramTersediaMb: ramTersedia,
        ramTerpakaiMb: _selisih(ramTotal, ramTersedia),
        perangkatRamRendah: info.isLowRamDevice,
        penyimpananTotalByte: diskTotal,
        penyimpananBebasByte: diskBebas,
        penyimpananTerpakaiByte: _selisih(diskTotal, diskBebas),
      );
    } catch (error) {
      debugPrint('Gagal membaca info memori: $error');
      return null;
    }
  }

  // Nilai negatif dianggap tidak valid; jangan tampilkan sebagai data sah.
  static int? _nonNegatif(int nilai) => nilai >= 0 ? nilai : null;

  static int? _selisih(int? a, int? b) =>
      (a != null && b != null && a >= b) ? a - b : null;
}
