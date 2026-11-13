---
name: validasi-form-sebelum-penyimpanan
description: "Trigger: saat memvalidasi form sebelum simpan | Panduan Form + GlobalKey + validate(); jangan masking input tidak valid dengan ?? 0."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Validasi Form Sebelum Penyimpanan

Form wajib menggunakan `Form` + `GlobalKey<FormState>` + `validate()` sebelum simpan. Jangan masking input tidak valid dengan `?? 0`.

## Aturan

1. Apabila field menggunakan `TextFormField` atau widget yang menyediakan `validator`, pastikan mekanisme validasinya benar-benar dijalankan sebelum penyimpanan.
2. Jika menggunakan mekanisme `Form`, bungkus field terkait dengan `Form` dan sediakan `GlobalKey<FormState>` atau mekanisme akses form yang sesuai.
3. Panggil `validate()` sebelum menjalankan penyimpanan ke database atau repository.
4. Apabila validasi gagal, hentikan proses penyimpanan.
5. Validasi format angka tidak sama dengan validasi aturan bisnis.
6. Validasi harus mencakup batas nilai sesuai kebutuhan, misalnya nilai wajib lebih besar dari nol.
7. Jangan menganggap `TextInputType.number` atau input formatter sudah menjamin nilai memenuhi aturan bisnis.
8. Jangan menggunakan nilai pengganti `0` ketika parsing gagal apabila hal tersebut menyembunyikan input yang tidak valid.

## Larangan

- Jangan menyimpan data sebelum memastikan validasi dijalankan dan lulus.
- Jangan mengganti input yang tidak valid dengan nilai default (`0`) tanpa memberi tahu pengguna.
- Jangan mengandalkan tipe keyboard (`TextInputType.number`) sebagai satu-satunya validasi.

## Contoh Benar

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: TextFormField(
    controller: _penurunanController,
    keyboardType: TextInputType.number,
    validator: (value) {
      final n = int.tryParse(value ?? '');
      if (n == null || n <= 0) return 'Wajib bilangan bulat positif';
      return null;
    },
  ),
)

Future<void> _simpan() async {
  if (!(_formKey.currentState?.validate() ?? false)) return;
  // lanjutkan penyimpanan
}
```

## Contoh Salah

```dart
// Tidak ada Form/validate; parsing gagal diganti 0.
penurunanPerMinggu: int.tryParse(_penurunanPerMingguController.text.trim()) ?? 0,
// Menyimpan langsung tanpa validasi.
await ref.read(biodataProvider.notifier).simpan(model);
```

## Sumber Evaluasi

- Commit: `ceacc6a1c388b24b7647a37ccde411d6c85ee01c`
- File: `lib/fitur/biodata/screens/form_biodata.dart`
