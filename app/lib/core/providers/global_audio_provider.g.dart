// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_audio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GlobalAudioNotifier)
const globalAudioProvider = GlobalAudioNotifierProvider._();

final class GlobalAudioNotifierProvider
    extends $NotifierProvider<GlobalAudioNotifier, GlobalAudioState> {
  const GlobalAudioNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalAudioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalAudioNotifierHash();

  @$internal
  @override
  GlobalAudioNotifier create() => GlobalAudioNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalAudioState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalAudioState>(value),
    );
  }
}

String _$globalAudioNotifierHash() =>
    r'4e15c0cb0257d10be047d7346fb7c7eb4d62124a';

abstract class _$GlobalAudioNotifier extends $Notifier<GlobalAudioState> {
  GlobalAudioState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GlobalAudioState, GlobalAudioState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GlobalAudioState, GlobalAudioState>,
              GlobalAudioState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
