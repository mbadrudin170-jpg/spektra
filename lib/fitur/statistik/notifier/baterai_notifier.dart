import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:spektra/fitur/statistik/data/baterai_repository.dart';
import 'package:spektra/fitur/statistik/model/baterai_info.dart';

part 'baterai_notifier.g.dart';

// Mengelola snapshot info baterai (baca sekali saat layar dibuka) dan mode
// muat ulang manual; bukan stream realtime.
@Riverpod(keepAlive: true)
class BateraiNotifier extends _$BateraiNotifier {
  final BateraiRepository _repository = BateraiRepository();

  @override
  Future<BateraiInfo?> build() => _repository.ambilInfo();

  // Memuat ulang snapshot baterai; dipicu tombol muat ulang pada section.
  Future<void> muatUlang() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.ambilInfo());
  }
}
