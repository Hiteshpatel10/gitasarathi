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

String _$chaptersListHash() => r'44a161f7718335240e4e0770e6ddb225cb73ad40';
