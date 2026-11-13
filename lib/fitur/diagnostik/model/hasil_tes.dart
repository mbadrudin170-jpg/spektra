// Hasil satu tes diagnostik; ringkasan sesi diturunkan dari daftar `HasilTes`.
enum StatusTes { lulus, gagal, tidakTersedia }

class HasilTes {
  const HasilTes({required this.id, required this.label, required this.status});

  final String id;
  final String label;
  final StatusTes status;
}
