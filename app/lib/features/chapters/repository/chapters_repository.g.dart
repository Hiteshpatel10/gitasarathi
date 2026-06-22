// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chaptersRepository)
const chaptersRepositoryProvider = ChaptersRepositoryProvider._();

final class ChaptersRepositoryProvider
    extends
        $FunctionalProvider<
          ChaptersRepository,
          ChaptersRepository,
          ChaptersRepository
        >
    with $Provider<ChaptersRepository> {
  const ChaptersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chaptersRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chaptersRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChaptersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChaptersRepository create(Ref ref) {
    return chaptersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChaptersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChaptersRepository>(value),
    );
  }
}

String _$chaptersRepositoryHash() =>
    r'8c7db009cf54145620071dca3f042c1aab123dfe';
