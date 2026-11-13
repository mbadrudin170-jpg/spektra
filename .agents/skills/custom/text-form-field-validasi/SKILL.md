---
name: text-form-field-validasi
description: "Trigger: saat membuat input teks dengan validasi | Panduan TextFormField, TextEditingController, Form, GlobalKey, dan validasi sebelum penyimpanan."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# TextFormField dan Validasi Form

Menggunakan `TextFormField` dengan `TextEditingController`, `Form`, `GlobalKey<FormState>`, dan validasi input sebelum menyimpan data.

## Cakupan yang Di-Cover

- Package: `package:flutter` (file `lib/src/material/text_form_field.dart`, `lib/src/material/form.dart`)
- Class: `TextFormField`, `TextEditingController`, `Form`, `GlobalKey<FormState>`, `FormFieldState`, `InputDecoration`, `TextInputType`, `TextInputAction`, `FocusNode`
- Properti: `TextFormField.controller`, `TextFormField.validator`, `TextFormField.decoration`, `TextFormField.keyboardType`, `TextFormField.textInputAction`, `TextFormField.obscureText`, `TextFormField.maxLines`, `TextFormField.minLines`, `TextFormField.enabled`, `TextFormField.readOnly`, `Form.key`, `Form.autovalidateMode`, `Form.onChanged`, `FormFieldState.value`, `FormFieldState.validate`, `FormFieldState.reset`
- Method: `TextEditingController.text`, `TextEditingController.clear`, `TextEditingController.dispose`, `FocusNode.requestFocus`, `FocusNode.unfocus`, `GlobalKey.currentState?.validate()`, `GlobalKey.currentState?.save()`, `GlobalKey.currentState?.reset()`
- Enum: `AutovalidateMode.disabled`, `AutovalidateMode.onUserInteraction`, `AutovalidateMode.onUnfocus`, `AutovalidateMode.always`

## Aturan

1. Setiap `TextFormField` yang perlu nilainya disimpan harus memiliki `TextEditingController`.
2. `TextEditingController` harus di-`dispose()` di `State.dispose()` untuk mencegah memory leak.
3. `validator` pada `TextFormField` mengembalikan `String?`; null berarti valid, string berisi pesan error.
4. `Form` dengan `GlobalKey<FormState>` untuk memvalidasi seluruh field sekaligus sebelum penyimpanan.
5. Panggil `formKey.currentState?.validate()` sebelum menyimpan; jika false, jangan lanjutkan penyimpanan.
6. Jangan gunakan `?? 0` atau nilai default untuk menyembunyikan input yang tidak valid; validasi harus gagal dan memberikan feedback.
7. `autovalidateMode = AutovalidateMode.onUserInteraction` untuk validasi real-time saat user mengetik; `disabled` untuk validasi hanya saat tombol simpan ditekan.
8. `keyboardType = TextInputType.number` untuk input angka; gabungkan dengan `inputFormatters` (FilteringTextInputFormatter.digitsOnly) untuk mencegah input non-angka.
9. `obscureText = true` untuk input sandi; sertakan `suffixIcon` untuk toggle tampilan sandi.
10. `FocusNode` untuk pindah fokus antar field (mis. `nextFocus` atau manual `requestFocus`).
11. `controller.addListener(() => setState(() {}))` jika perlu merespon perubahan teks secara real-time.
12. `enabled = false` untuk field non-aktif; `readOnly = true` jika field hanya bisa dibaca tapi masih bisa difokus/dicopy.

## Larangan

- `TextEditingController` tanpa dispose (memory leak).
- Menyimpan data tanpa memanggil `validate()` terlebih dahulu.
- Menggunakan `?? 0` atau `int.tryParse(...) ?? 0` untuk menangani input invalid tanpa feedback ke user.
- `validator` yang selalu mengembalikan null (validasi tidak berfungsi).
- `TextFormField` tanpa `controller` jika nilainya perlu diakses secara terprogram.

## Contoh Benar

```dart
class _FormBiodataState extends State<FormBiodata> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahRokokController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahRokokController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState?.validate() != true) {
      return; // validasi gagal, jangan lanjutkan
    }
    // lanjutkan penyimpanan
    final nama = _namaController.text;
    final jumlah = int.tryParse(_jumlahRokokController.text) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(labelText: 'Nama'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama tidak boleh kosong';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _jumlahRokokController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Jumlah Rokok per Hari'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jumlah tidak boleh kosong';
              }
              final angka = int.tryParse(value);
              if (angka == null || angka < 0) {
                return 'Masukkan angka valid';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: _simpan,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
```

## Contoh Salah

```dart
// menyimpan tanpa validasi + masking invalid input dengan ?? 0
void _simpan() {
  final jumlah = int.tryParse(_controller.text) ?? 0; // DILARANG: menyembunyikan input invalid
  repo.simpan(jumlah); // tersimpan meski input tidak valid
}
```

```dart
// controller tidak di-dispose
@override
void dispose() {
  super.dispose();
  // _controller.dispose() hilang -> memory leak
}
```

## Sumber Evaluasi

- File: `/google/flutter/packages/flutter/lib/src/material/text_form_field.dart`, `/google/flutter/packages/flutter/lib/src/material/form.dart`
- Class terkait: `TextFormField`, `TextEditingController`, `Form`, `GlobalKey<FormState>`
