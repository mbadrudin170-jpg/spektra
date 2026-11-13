// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baterai_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BateraiNotifier)
final bateraiProvider = BateraiNotifierProvider._();

final class BateraiNotifierProvider
    extends $AsyncNotifierProvider<BateraiNotifier, BateraiInfo?> {
  BateraiNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bateraiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bateraiNotifierHash();

  @$internal
  @override
  BateraiNotifier create() => BateraiNotifier();
}

String _$bateraiNotifierHash() => r'3ce320c3dfbfb334655572e323bac5f906a198cb';

abstract class _$BateraiNotifier extends $AsyncNotifier<BateraiInfo?> {
  FutureOr<BateraiInfo?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BateraiInfo?>, BateraiInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BateraiInfo?>, BateraiInfo?>,
              AsyncValue<BateraiInfo?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
