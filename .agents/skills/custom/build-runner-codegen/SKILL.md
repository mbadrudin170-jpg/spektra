---
name: build-runner-codegen
description: "Trigger: saat menjalankan code generation Flutter | Build runner dan codegen Flutter - Freezed, Riverpod generator, build_runner (build, watch), delete-conflicting-outputs; file generated (.g.dart, .freezed.dart, .mocks.dart) dilarang diedit manual."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Build Runner & Code Generation

Skill ini mendokumentasikan penggunaan `build_runner` untuk code generation (Freezed, Riverpod, JSON serializable, Mockito) di proyek Flutter.

## Cakupan yang Di-Cover

- Package: `package:build_runner` (class `BuildRunner`), `package:freezed` (annotation `@freezed`), `package:riverpod_annotation` (annotation `@riverpod`, `@Riverpod`), `package:json_annotation` (annotation `@JsonSerializable`), `package:mockito` (annotation `@GenerateMocks`)
- Class: `BuildRunner`, `Freezed`, `RiverpodGenerator`, `JsonSerializable`, `GenerateMocks`
- File generated: `*.g.dart`, `*.freezed.dart`, `*.mocks.dart`
- Method: `dart run build_runner build`, `dart run build_runner watch`

## Aturan

1. Wajib jalankan `build_runner build` setelah:
   - Ubah/tambah model Freezed (file `.freezed.dart` / `.g.dart`)
   - Ubah/tambah Riverpod Notifier (`@riverpod` / `@Riverpod` → `.g.dart`)
   - Ubah/tambah Mockito `@GenerateMocks`
   - Ubah/tambah JSON Serializable `@JsonSerializable`
   - Pull branch yang ada perubahan generated files
2. Wajib pakai flag `--delete-conflicting-outputs` untuk menghindari error "conflicting outputs".
3. File generated (`.g.dart`, `.freezed.dart`, `.mocks.dart`) DILARANG diedit manual.
4. Perubahan hanya di source (`.dart` biasa), lalu jalankan `build_runner`.
5. Jika conflict, hapus file generated lalu `build_runner build --delete-conflicting-outputs`.

## Larangan

- DILARANG edit file `.g.dart` / `.freezed.dart` / `.mocks.dart` manual.
- DILARANG commit file generated tanpa source changes (review diff).
- DILARANG `build_runner` tanpa `--delete-conflicting-outputs` (kecuali clean build pertama).
- DILARANG ignore generated files di `.gitignore` (harus di-commit untuk CI).

## Contoh Benar

```bash
# Build sekali (clean rebuild)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto rebuild saat file berubah) - untuk development
dart run build_runner watch --delete-conflicting-outputs
```

```yaml
# build.yaml di root project
targets:
  $default:
    builders:
      freezed:
        options:
          freezed:
            # Opsi freezed
      riverpod_generator:
        options:
          riverpod_generator:
            # Opsi riverpod
```

## Contoh Salah

```bash
# DILARANG: Tanpa --delete-conflicting-outputs
dart run build_runner build

# DILARANG: Edit file generated manual
# File: model.g.dart (DIUBAH SECARA MANUAL!) - DILARANG
```

## Sumber Evaluasi

- File: `build.yaml`, `lib/**/*.freezed.dart`, `lib/**/*.g.dart`, `test/**/*.mocks.dart`
- Class terkait: `BuildRunner`, `Freezed`, `RiverpodGenerator`
- Commit rujukan: `3b67d309` — Freezed models + Riverpod generator setup; `be04199e` — Mockito generate mocks
