// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Currently selected translation author ID.
/// Changing this instantly rebuilds filteredVerseProvider with zero network calls.

@ProviderFor(SelectedTranslationAuthorId)
const selectedTranslationAuthorIdProvider =
    SelectedTranslationAuthorIdProvider._();

/// Currently selected translation author ID.
/// Changing this instantly rebuilds filteredVerseProvider with zero network calls.
final class SelectedTranslationAuthorIdProvider
    extends $NotifierProvider<SelectedTranslationAuthorId, int> {
  /// Currently selected translation author ID.
  /// Changing this instantly rebuilds filteredVerseProvider with zero network calls.
  const SelectedTranslationAuthorIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTranslationAuthorIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTranslationAuthorIdHash();

  @$internal
  @override
  SelectedTranslationAuthorId create() => SelectedTranslationAuthorId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedTranslationAuthorIdHash() =>
    r'67f643df5ea355f34744d01308efff29aeecc94d';

/// Currently selected translation author ID.
/// Changing this instantly rebuilds filteredVerseProvider with zero network calls.

abstract class _$SelectedTranslationAuthorId extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Currently selected commentary author ID.

@ProviderFor(SelectedCommentaryAuthorId)
const selectedCommentaryAuthorIdProvider =
    SelectedCommentaryAuthorIdProvider._();

/// Currently selected commentary author ID.
final class SelectedCommentaryAuthorIdProvider
    extends $NotifierProvider<SelectedCommentaryAuthorId, int> {
  /// Currently selected commentary author ID.
  const SelectedCommentaryAuthorIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCommentaryAuthorIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCommentaryAuthorIdHash();

  @$internal
  @override
  SelectedCommentaryAuthorId create() => SelectedCommentaryAuthorId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedCommentaryAuthorIdHash() =>
    r'782ea887912361ff79e6374d921aaf60428925b6';

/// Currently selected commentary author ID.

abstract class _$SelectedCommentaryAuthorId extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(lastActivity)
const lastActivityProvider = LastActivityProvider._();

final class LastActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<LastActivity?>,
          LastActivity?,
          FutureOr<LastActivity?>
        >
    with $FutureModifier<LastActivity?>, $FutureProvider<LastActivity?> {
  const LastActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastActivityHash();

  @$internal
  @override
  $FutureProviderElement<LastActivity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LastActivity?> create(Ref ref) {
    return lastActivity(ref);
  }
}

String _$lastActivityHash() => r'55f577d3c3d17bb4a99e60653fa18cb54c4eb382';

@ProviderFor(streakSummary)
const streakSummaryProvider = StreakSummaryProvider._();

final class StreakSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<StreakSummary?>,
          StreakSummary?,
          FutureOr<StreakSummary?>
        >
    with $FutureModifier<StreakSummary?>, $FutureProvider<StreakSummary?> {
  const StreakSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakSummaryHash();

  @$internal
  @override
  $FutureProviderElement<StreakSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StreakSummary?> create(Ref ref) {
    return streakSummary(ref);
  }
}

String _$streakSummaryHash() => r'e69a255b40777d216fda9f0d43da7a1f7e2465b6';

/// Fetches (or loads from cache) the full verse with ALL translations and commentaries.

@ProviderFor(verseOfTheDay)
const verseOfTheDayProvider = VerseOfTheDayProvider._();

/// Fetches (or loads from cache) the full verse with ALL translations and commentaries.

final class VerseOfTheDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<VerseOfTheDay?>,
          VerseOfTheDay?,
          FutureOr<VerseOfTheDay?>
        >
    with $FutureModifier<VerseOfTheDay?>, $FutureProvider<VerseOfTheDay?> {
  /// Fetches (or loads from cache) the full verse with ALL translations and commentaries.
  const VerseOfTheDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verseOfTheDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verseOfTheDayHash();

  @$internal
  @override
  $FutureProviderElement<VerseOfTheDay?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VerseOfTheDay?> create(Ref ref) {
    return verseOfTheDay(ref);
  }
}

String _$verseOfTheDayHash() => r'cc86af218fdd6890aed5c36d912541f267e0d5ec';

/// Derived provider: filters the cached verse by the currently selected authors.
/// This rebuilds instantly on author change — zero network calls.

@ProviderFor(filteredVerse)
const filteredVerseProvider = FilteredVerseProvider._();

/// Derived provider: filters the cached verse by the currently selected authors.
/// This rebuilds instantly on author change — zero network calls.

final class FilteredVerseProvider
    extends $FunctionalProvider<VerseOfTheDay?, VerseOfTheDay?, VerseOfTheDay?>
    with $Provider<VerseOfTheDay?> {
  /// Derived provider: filters the cached verse by the currently selected authors.
  /// This rebuilds instantly on author change — zero network calls.
  const FilteredVerseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredVerseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredVerseHash();

  @$internal
  @override
  $ProviderElement<VerseOfTheDay?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VerseOfTheDay? create(Ref ref) {
    return filteredVerse(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerseOfTheDay? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerseOfTheDay?>(value),
    );
  }
}

String _$filteredVerseHash() => r'22787d3ca15051f1d7b5ed10a1e16cc1e486761d';
