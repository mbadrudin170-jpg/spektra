import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:spektra/fitur/statistik/data/memori_repository.dart';
import 'package:spektra/fitur/statistik/model/memori_info.dart';

part 'memori_notifier.g.dart';

// Mengelola snapshot info memori/penyimpanan (baca sekali saat layar dibuka)
// dan muat ulang manual; bukan stream realtime.
@Riverpod(keepAlive: true)
class MemoriNotifier extends _$MemoriNotifier {
  final MemoriRepository _repository = MemoriRepository();

  @override
  Future<MemoriInfo?> build() => _repository.ambilInfo();

  // Memuat ulang snapshot memori; dipicu tombol muat ulang pada section.
  Future<void> muatUlang() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.ambilInfo());
  }
}
