// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookmarksRepository)
const bookmarksRepositoryProvider = BookmarksRepositoryProvider._();

final class BookmarksRepositoryProvider
    extends
        $FunctionalProvider<
          BookmarksRepository,
          BookmarksRepository,
          BookmarksRepository
        >
    with $Provider<BookmarksRepository> {
  const BookmarksRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarksRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarksRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookmarksRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookmarksRepository create(Ref ref) {
    return bookmarksRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookmarksRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookmarksRepository>(value),
    );
  }
}

String _$bookmarksRepositoryHash() =>
    r'f6b0d5b161dc1eff2bcf66752251ce23e4f354e5';
