// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

@ProviderFor(verseOfTheDay)
const verseOfTheDayProvider = VerseOfTheDayProvider._();

final class VerseOfTheDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<VerseOfTheDay?>,
          VerseOfTheDay?,
          FutureOr<VerseOfTheDay?>
        >
    with $FutureModifier<VerseOfTheDay?>, $FutureProvider<VerseOfTheDay?> {
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

String _$verseOfTheDayHash() => r'e45ee72810a31d4787c536be4e20593f418eb94a';
