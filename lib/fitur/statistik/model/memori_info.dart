// DTO snapshot memori/penyimpanan Android; seluruh field bersifat nullable
// karena tidak semua perangkat menyediakan nilai valid.
class MemoriInfo {
  const MemoriInfo({
    this.ramTotalMb,
    this.ramTersediaMb,
    this.ramTerpakaiMb,
    this.perangkatRamRendah,
    this.penyimpananTotalByte,
    this.penyimpananBebasByte,
    this.penyimpananTerpakaiByte,
  });

  // RAM fisik perangkat (`AndroidDeviceInfo.physicalRamSize`, MB).
  final int? ramTotalMb;

  // RAM yang masih tersedia menurut sistem (`AndroidDeviceInfo.availableRamSize`, MB).
  final int? ramTersediaMb;

  // Total - tersedia; hanya diisi bila keduanya valid.
  final int? ramTerpakaiMb;

  // Indikator perangkat RAM rendah (`AndroidDeviceInfo.isLowRamDevice`).
  final bool? perangkatRamRendah;

  // Total ruang penyimpanan internal (`AndroidDeviceInfo.totalDiskSize`, bytes).
  final int? penyimpananTotalByte;

  // Ruang penyimpanan internal yang masih bebas (`AndroidDeviceInfo.freeDiskSize`, bytes).
  final int? penyimpananBebasByte;

  // Total - bebas; hanya diisi bila keduanya valid.
  final int? penyimpananTerpakaiByte;
}
