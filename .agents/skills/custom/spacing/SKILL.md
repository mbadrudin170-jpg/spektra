---
name: spacing
description: "Trigger: saat mengatur jarak antar elemen UI | Panduan spacing pada Row/Column, SizedBox hanya khusus, padding tepi layar tanggung jawab parent, nilai spacing mengikuti skala standar optimasi_ui.md."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Panduan Spacing (Jarak Antar Elemen)

Skill ini mendokumentasikan aturan pengaturan jarak antar elemen UI berdasarkan `optimasi_ui.md` dan implementasi nyata di proyek Flutter. Tujuannya adalah menjaga konsistensi jarak antar elemen dan menghindari penggunaan `SizedBox` berulang untuk jarak standar.

## Cakupan yang Di-Cover

- Package: `package:flutter` (class `Row`, `Column`, `Wrap`, `SizedBox`, `Padding`, `EdgeInsets`, `Card`, `Scaffold`, `SafeArea`)
- Class: `Row`, `Column`, `Wrap`, `SizedBox`, `Padding`, `EdgeInsets`, `Card`, `Scaffold`, `SafeArea`
- Properti: `Row.spacing`, `Column.spacing`, `Wrap.spacing`, `Wrap.runSpacing`, `SizedBox.height`, `SizedBox.width`, `Padding.padding`
- Method: `EdgeInsets.all()`

## Aturan

1. Wajib menggunakan properti `spacing` pada `Row` dan `Column` untuk jarak seragam antar anak.
2. DILARANG menggunakan `SizedBox` berulang hanya untuk jarak standar antar anak di `Row`/`Column`.
3. `SizedBox` hanya boleh digunakan untuk kebutuhan jarak khusus yang tidak bisa ditangani `spacing`.
4. Padding tepi layar adalah tanggung jawab container halaman/parent, bukan widget reusable.
5. Widget reusable boleh punya padding internal untuk desain komponennya (mis. `Card` padding isi), tetapi dilarang mengambil alih tanggung jawab padding tepi layar.
6. DILARANG padding ganda (parent sudah padding, anak juga padding tepi).
7. Nilai padding wajib mengikuti `optimasi_ui.md`.
8. Jarak antar elemen wajib serasi, proporsional, dan konsisten per `optimasi_ui.md`.

## Larangan

- DILARANG `SizedBox` berulang untuk jarak standar di `Row`/`Column`.
- DILARANG widget reusable mengandung padding tepi layar.
- DILARANG padding ganda (parent + anak keduanya padding tepi).
- DILARANG nilai spacing acak tanpa acuan `optimasi_ui.md`.

## Contoh Benar

```dart
// BENAR: Column dengan spacing property
Column(
  spacing: 16, // Jarak seragam 16 antar semua anak
  children: [
    Text('Judul'),
    Text('Deskripsi'),
    Text('Lainnya'),
  ],
)

// BENAR: Row dengan spacing property
Row(
  spacing: 12,
  children: [
    Icon(Icons.star),
    Text('Rating'),
    Text('4.5'),
  ],
)

// BENAR: SizedBox hanya untuk jarak khusus (sebelum FAB)
Column(
  spacing: 8,
  children: [
    Text('Label'),
    Text('Nilai'),
    const SizedBox(height: 24), // Jarak khusus besar sebelum tombol
    FilledButton(onPressed: ..., child: Text('Aksi')),
  ],
)

// BENAR: Wrap dengan spacing + runSpacing
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: chips.map((c) => FilterChip(...)).toList(),
)

// BENAR: Halaman bertanggung jawab padding tepi layar
Scaffold(
  body: SafeArea(
    child: Padding(
      padding: EdgeInsets.all(16), // Mengikuti optimasi_ui.md
      child: ListView(
        children: [
          RingkasanWidget(),     // Widget reusable - HANYA padding internal
          StatistikWidget(),     // Widget reusable - HANYA padding internal
          DaftarWidget(),        // Widget reusable
        ],
      ),
    ),
  ),
)

// Widget Reusable: Card dengan padding internal (bukan tepi layar)
class RingkasanWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16), // Padding INTERNAL komponen
        child: Column(...),
      ),
    );
  }
}
```

## Contoh Salah

```dart
// DILARANG: SizedBox berulang di Column
Column(
  children: [
    Text('Judul'),
    SizedBox(height: 16),
    Text('Deskripsi'),
    SizedBox(height: 16),
    Text('Lainnya'),
  ],
)

// DILARANG: Widget reusable punya padding tepi layar
class _ImpianItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding( // SALAH! Ini padding tepi layar, bukan internal
      padding: EdgeInsets.all(16),
      child: Card(...),
    );
  }
}

// DILARANG: Padding ganda (parent 16 + anak 16 = 32 total)
Scaffold(
  body: Padding(
    padding: EdgeInsets.all(16),
    child: ListView(children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: _ImpianItem(...), // DOUBLE PADDING!
      ),
    ]),
  ),
)
```

## Sumber Evaluasi

- File: `lib/fitur/impian/widget/visual_tabungan_impian.dart`, `lib/fitur/impian/screens/impian_screen.dart`
- Class terkait: `Row`, `Column`, `Wrap`, `SizedBox`, `Padding`, `EdgeInsets`, `Card`, `Scaffold`, `SafeArea`
- Commit rujukan: `3b67d309` — `Column(spacing: 8)` di `_EmptyDiaryCraving`, `VisualTabunganImpian`; `c7337d1` — `Column(spacing: 12)` di card impian; `e659574` — `Column(spacing: 8)` di kartu motivasi dashboard
