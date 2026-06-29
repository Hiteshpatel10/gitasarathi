// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookmarksNotifier)
const bookmarksProvider = BookmarksNotifierProvider._();

final class BookmarksNotifierProvider
    extends $AsyncNotifierProvider<BookmarksNotifier, Set<int>> {
  const BookmarksNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarksNotifierHash();

  @$internal
  @override
  BookmarksNotifier create() => BookmarksNotifier();
}

String _$bookmarksNotifierHash() => r'75b229ec60c55fcf6161edc19b68e3322c6a9fd9';

abstract class _$BookmarksNotifier extends $AsyncNotifier<Set<int>> {
  FutureOr<Set<int>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Set<int>>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<int>>, Set<int>>,
              AsyncValue<Set<int>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(favoriteVerses)
const favoriteVersesProvider = FavoriteVersesProvider._();

final class FavoriteVersesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookmarkItem>>,
          List<BookmarkItem>,
          FutureOr<List<BookmarkItem>>
        >
    with
        $FutureModifier<List<BookmarkItem>>,
        $FutureProvider<List<BookmarkItem>> {
  const FavoriteVersesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteVersesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteVersesHash();

  @$internal
  @override
  $FutureProviderElement<List<BookmarkItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookmarkItem>> create(Ref ref) {
    return favoriteVerses(ref);
  }
}

String _$favoriteVersesHash() => r'a3a4418afbe5ab09add9b84abf1766b6161be9f9';
