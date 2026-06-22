// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CacheInvalidationEvent)
const cacheInvalidationEventProvider = CacheInvalidationEventProvider._();

final class CacheInvalidationEventProvider
    extends $NotifierProvider<CacheInvalidationEvent, List<String>> {
  const CacheInvalidationEventProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheInvalidationEventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheInvalidationEventHash();

  @$internal
  @override
  CacheInvalidationEvent create() => CacheInvalidationEvent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$cacheInvalidationEventHash() =>
    r'd0354e4e9816c7930b867bf9968954ba3fe36d54';

abstract class _$CacheInvalidationEvent extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
