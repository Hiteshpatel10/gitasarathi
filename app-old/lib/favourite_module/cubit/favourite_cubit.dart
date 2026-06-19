import 'package:bloc/bloc.dart';
import 'package:chapter/favourite_module/model/favourite_model.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:meta/meta.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());

  Future<void> getFavourites() async {
    logger.d("FavouriteCubit => getFavourites > Start");
    emit(FavouriteLoadingState());
    try {
      final response = await getRequest(apiEndPoint: ApiEndpoints.favoriteList);

      final model = FavouriteModel.fromJson(response);
      emit(FavouriteSuccessState(favouriteModel: model));
      logger.d("FavouriteCubit => getFavourites > Success");
    } catch (e) {
      emit(FavouriteErrorState(message: e.toString()));

      logger.e("FavouriteCubit => getFavourites > End with error\n$e");
    }
  }

  Future<dynamic> addFavourite({num? verseId}) async {
    if (verseId == null) return null;

    dynamic response;
    logger.d("FavouriteCubit => addFavourite > Start");

    try {
      response = await sendRequest(
        apiEndPoint: ApiEndpoints.favoriteAdd,
        data: {
          "verse_id": verseId,
          "list_id": null,
        },
        method: HttpMethod.post,
      );


      logger.d("FavouriteCubit => addFavourite > Success");
    } catch (e) {
      logger.e("FavouriteCubit => addFavourite > End with error\n$e");
    }

    return response;
  }

  Future<dynamic> removeFavourite({num? verseId}) async {
    if (verseId == null) return null;

    dynamic response;
    logger.d("FavouriteCubit => removeFavourite > Start");

    try {
      response = await sendRequest(
        apiEndPoint: ApiEndpoints.favoriteRemove,
        data: {
          "verse_id": verseId,
          "list_id": null,
        },
        method: HttpMethod.delete,
      );

      logger.d("FavouriteCubit => removeFavourite > Success");
    } catch (e) {
      logger.e("FavouriteCubit => removeFavourite > End with error\n$e");
    }

    return response;
  }
}
