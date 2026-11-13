// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tema_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TemaNotifier)
final temaProvider = TemaNotifierProvider._();

final class TemaNotifierProvider
    extends $AsyncNotifierProvider<TemaNotifier, ThemeMode> {
  TemaNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temaProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temaNotifierHash();

  @$internal
  @override
  TemaNotifier create() => TemaNotifier();
}

String _$temaNotifierHash() => r'46f7778212eaf1d96268f331ac3934e4ff650204';

abstract class _$TemaNotifier extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
