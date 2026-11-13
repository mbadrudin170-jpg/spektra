// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memori_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MemoriNotifier)
final memoriProvider = MemoriNotifierProvider._();

final class MemoriNotifierProvider
    extends $AsyncNotifierProvider<MemoriNotifier, MemoriInfo?> {
  MemoriNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoriProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoriNotifierHash();

  @$internal
  @override
  MemoriNotifier create() => MemoriNotifier();
}

String _$memoriNotifierHash() => r'a89dd5d471fce70a9edd6409bf91288613c9656a';

abstract class _$MemoriNotifier extends $AsyncNotifier<MemoriInfo?> {
  FutureOr<MemoriInfo?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MemoriInfo?>, MemoriInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MemoriInfo?>, MemoriInfo?>,
              AsyncValue<MemoriInfo?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
