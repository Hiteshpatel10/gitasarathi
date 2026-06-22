// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VerseSettingsNotifier)
const verseSettingsProvider = VerseSettingsNotifierProvider._();

final class VerseSettingsNotifierProvider
    extends $NotifierProvider<VerseSettingsNotifier, VerseSettings> {
  const VerseSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verseSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verseSettingsNotifierHash();

  @$internal
  @override
  VerseSettingsNotifier create() => VerseSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerseSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerseSettings>(value),
    );
  }
}

String _$verseSettingsNotifierHash() =>
    r'92405bdc494e0be6059f1b86d7c7e9739e01b8b3';

abstract class _$VerseSettingsNotifier extends $Notifier<VerseSettings> {
  VerseSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VerseSettings, VerseSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VerseSettings, VerseSettings>,
              VerseSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
