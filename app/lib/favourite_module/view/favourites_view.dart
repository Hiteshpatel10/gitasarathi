import 'package:chapter/components/app_error_widget.dart';
import 'package:chapter/favourite_module/cubit/favourite_cubit.dart';
import 'package:chapter/utility/messengers/core_loading_dialog.dart';
import 'package:chapter/utility/messengers/core_scaffold_messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  late final FavouriteCubit _favouriteCubit;

  @override
  void initState() {
    _favouriteCubit = BlocProvider.of<FavouriteCubit>(context);
    _favouriteCubit.getFavourites();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
      ),
      body: BlocBuilder(
        bloc: _favouriteCubit,
        builder: (context, state) {
          if (state is FavouriteSuccessState) {
            if (state.favouriteModel.favorites?.isEmpty == true) {
              return const Center(
                child: Text("No Verses added to favourites"),
              );
            }
            return ListView.separated(
              itemCount: state.favouriteModel.favorites?.length ?? 0,
              itemBuilder: (context, index) {
                final favourite = state.favouriteModel.favorites?[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      "Chapter ${favourite?.verse?.chapterNumber} Verse ${favourite?.verse?.verseNumber}",
                    ),
                    subtitle: Text(
                      favourite?.verse?.transliteration ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        coreLoadingDialog(context: context, content: "Deleting...");
                        final response = await _favouriteCubit.removeFavourite(
                          verseId: favourite?.verseId,
                        );

                        coreCloseDialog();
                        if (response == null || response?['status'] == 0) {
                          coreMessenger("Failed to delete");
                          return;
                        }

                        _favouriteCubit.getFavourites();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
            );
          }

          if (state is FavouriteErrorState) {
            return const Center(
              child: AppErrorWidget(errorCode: AppErrorCode.serverError),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
