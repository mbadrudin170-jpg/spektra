// DTO snapshot info baterai Android; seluruh field bersifat nullable karena
// tidak semua perangkat menyediakan nilai valid.
class BateraiInfo {
  const BateraiInfo({
    this.kapasitasTersisaMah,
    this.levelPersen,
    this.statusPengisian,
    this.sumberCharger,
    this.kesehatan,
    this.suhuCelcius,
    this.teganganMv,
    this.teknologi,
  });

  // Estimasi muatan tersisa (bukan kapasitas desain pabrik); dikonversi dari
  // `BATTERY_PROPERTY_CHARGE_COUNTER` (µAh) menjadi mAh.
  final int? kapasitasTersisaMah;

  // Persentase kapasitas tersisa menurut sistem (0–100).
  final int? levelPersen;

  // 'charging' | 'discharging' | 'full' | 'unknown'
  final String? statusPengisian;

  // 'USB' | 'AC' | 'wireless' | 'unknown'
  final String? sumberCharger;

  // 'health_good' | 'dead' | 'over_heat' | 'over_voltage' | 'cold' |
  // 'unspecified_failure' | 'unknown'
  final String? kesehatan;

  final int? suhuCelcius;
  final int? teganganMv;
  final String? teknologi;
}
