// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChaptersList)
const chaptersListProvider = ChaptersListProvider._();

final class ChaptersListProvider
    extends $AsyncNotifierProvider<ChaptersList, List<Chapter>?> {
  const ChaptersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chaptersListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chaptersListHash();

  @$internal
  @override
  ChaptersList create() => ChaptersList();
}

String _$chaptersListHash() => r'f34760193124667a71c850bd08751eb410bf24bd';

abstract class _$ChaptersList extends $AsyncNotifier<List<Chapter>?> {
  FutureOr<List<Chapter>?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Chapter>?>, List<Chapter>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Chapter>?>, List<Chapter>?>,
              AsyncValue<List<Chapter>?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(chapterVerses)
const chapterVersesProvider = ChapterVersesFamily._();

final class ChapterVersesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VerseMetadata>?>,
          List<VerseMetadata>?,
          FutureOr<List<VerseMetadata>?>
        >
    with
        $FutureModifier<List<VerseMetadata>?>,
        $FutureProvider<List<VerseMetadata>?> {
  const ChapterVersesProvider._({
    required ChapterVersesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'chapterVersesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chapterVersesHash();

  @override
  String toString() {
    return r'chapterVersesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<VerseMetadata>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VerseMetadata>?> create(Ref ref) {
    final argument = this.argument as int;
    return chapterVerses(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterVersesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chapterVersesHash() => r'dba879b7e65226266977210f4952693945cee7bf';

final class ChapterVersesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<VerseMetadata>?>, int> {
  const ChapterVersesFamily._()
    : super(
        retry: null,
        name: r'chapterVersesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChapterVersesProvider call(int chapterId) =>
      ChapterVersesProvider._(argument: chapterId, from: this);

  @override
  String toString() => r'chapterVersesProvider';
}

@ProviderFor(verseExplanation)
const verseExplanationProvider = VerseExplanationFamily._();

final class VerseExplanationProvider
    extends
        $FunctionalProvider<
          AsyncValue<VerseDetails?>,
          VerseDetails?,
          FutureOr<VerseDetails?>
        >
    with $FutureModifier<VerseDetails?>, $FutureProvider<VerseDetails?> {
  const VerseExplanationProvider._({
    required VerseExplanationFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'verseExplanationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$verseExplanationHash();

  @override
  String toString() {
    return r'verseExplanationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VerseDetails?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VerseDetails?> create(Ref ref) {
    final argument = this.argument as int;
    return verseExplanation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VerseExplanationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$verseExplanationHash() => r'f1932a54c93dcba5223d73f47de21ca2132522db';

final class VerseExplanationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VerseDetails?>, int> {
  const VerseExplanationFamily._()
    : super(
        retry: null,
        name: r'verseExplanationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VerseExplanationProvider call(int verseId) =>
      VerseExplanationProvider._(argument: verseId, from: this);

  @override
  String toString() => r'verseExplanationProvider';
}

/// Flat sorted list of every verse across all chapters.
/// Sorted by (chapterNumber asc, verseNumber asc).
/// All data comes from the already-cached chaptersAndVerses response — no extra network calls.

@ProviderFor(allVerses)
const allVersesProvider = AllVersesProvider._();

/// Flat sorted list of every verse across all chapters.
/// Sorted by (chapterNumber asc, verseNumber asc).
/// All data comes from the already-cached chaptersAndVerses response — no extra network calls.

final class AllVersesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VerseMetadata>>,
          List<VerseMetadata>,
          FutureOr<List<VerseMetadata>>
        >
    with
        $FutureModifier<List<VerseMetadata>>,
        $FutureProvider<List<VerseMetadata>> {
  /// Flat sorted list of every verse across all chapters.
  /// Sorted by (chapterNumber asc, verseNumber asc).
  /// All data comes from the already-cached chaptersAndVerses response — no extra network calls.
  const AllVersesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allVersesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allVersesHash();

  @$internal
  @override
  $FutureProviderElement<List<VerseMetadata>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VerseMetadata>> create(Ref ref) {
    return allVerses(ref);
  }
}

String _$allVersesHash() => r'd225cb82b274681a0b56d833a168bfde1f9ffb95';
