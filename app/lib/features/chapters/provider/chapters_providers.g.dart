// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chaptersList)
const chaptersListProvider = ChaptersListProvider._();

final class ChaptersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Chapter>?>,
          List<Chapter>?,
          FutureOr<List<Chapter>?>
        >
    with $FutureModifier<List<Chapter>?>, $FutureProvider<List<Chapter>?> {
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
  $FutureProviderElement<List<Chapter>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Chapter>?> create(Ref ref) {
    return chaptersList(ref);
  }
}

String _$chaptersListHash() => r'6fd19d298d8769a8cebe85caecee669b7562881a';

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
