---
name: widget-lifecycle-state
description: "Trigger: saat mengelola lifecycle widget | Panduan Widget/State lifecycle: mounted, initState, build, didUpdateWidget, dispose, setState, dependOnInheritedWidgetOfExactType."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Lifecycle Widget dan State (Flutter Framework)

Mengelola siklus hidup widget dan state agar tidak ada memory leak, setState setelah dispose, atau akses context yang tidak monted.

## Cakupan yang Di-Cover

- Package: `package:flutter` (file `lib/src/widgets/framework.dart`)
- Class: `Widget`, `StatelessWidget`, `StatefulWidget`, `State<T>`, `Element`, `BuildContext`, `ComponentElement`, `StatefulElement`, `StatelessElement`
- Method siklus: `initState`, `didChangeDependencies`, `build`, `didUpdateWidget`, `deactivate`, `dispose`, `reassemble`, `activate`
- Properti: `mounted`, `context`, `widget`, `state`, `dirty`
- Fungsi: `setState`, `dependOnInheritedWidgetOfExactType`, `findAncestorWidgetOfExactType`, `findAncestorStateOfType`

## Aturan

1. `setState` hanya boleh dipanggil ketika `mounted == true`. Cek `mounted` sebelum `setState` di callback async/timer.
2. Jangan lakukan operasi async (await) di dalam `setState(() { ... })`. Eksekusi async di luar, lalu panggil `setState` hanya untuk assign nilai.
3. `initState` dipanggil sekali. Gunakan untuk inisialisasi satu kali yang membutuhkan `context` atau `widget`.
4. `didChangeDependencies` dipanggil setelah `initState` dan setiap kali dependensi `InheritedWidget` berubah. Gunakan untuk inisialisasi yang bergantung pada `Theme.of`, `MediaQuery.of`, dll.
5. `didUpdateWidget(oldWidget)` dipanggil ketika konfigurasi widget berubah tetapi `State` tetap sama. Gunakan untuk mulai animasi atau subscribe ulang.
6. `dispose` dipanggil sekali saat widget dilepas dari tree. Lepaskan controller, stream subscription, timer di sini.
7. Jangan cache `BuildContext` di luar eksekusi sinkron satu fungsi. Context bisa invalid setelah unmount.
8. `build` tidak boleh memiliki side effect. Hanya return widget tree.
9. `dependOnInheritedWidgetOfExactType` jangan dipanggil di constructor atau `initState`. Gunakan di `build` atau `didChangeDependencies`.
10. Jika `State` subscribe ke `ChangeNotifier`/`Stream`, subscribe di `initState`, unsubscribe di `dispose`.

## Larangan

- `setState` setelah `dispose` (cek `mounted` dulu).
- Membandingkan `context` yang disimpan di variabel class setelah frame selesai.
- Memanggil `dependOnInheritedWidgetOfExactType` di `initState` atau constructor.
- Menahan referensi `State` atau `Element` setelah `dispose` (memory leak).
- `async` callback langsung di dalam `setState`.

## Contoh Benar

```dart
class _HalamanBerhentiState extends State<HalamanBerhenti> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(HalamanBerhenti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id) {
      // konfigurasi berubah, inisialisasi ulang jika perlu
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context); // aman di build
    return Scaffold(...);
  }
}
```

## Contoh Salah

```dart
// setState setelah await tanpa cek mounted
setState(() {
  _data = await repo.fetch(); // ERROR: async di setState
});
```

```dart
// dependOnInheritedWidgetOfExactType di initState
@override
void initState() {
  super.initState();
  final warna = Theme.of(context).colorScheme.primary; // BISA error, konteks belum siap
}
```

## Sumber Evaluasi

- File: `/google/flutter/packages/flutter/lib/src/widgets/framework.dart`
- Class terkait: `State`, `StatefulElement`, `StatelessElement`, `Element`, `BuildContext`
