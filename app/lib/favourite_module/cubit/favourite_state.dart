part of 'favourite_cubit.dart';

@immutable
sealed class FavouriteState {}

final class FavouriteInitial extends FavouriteState {}

final class FavouriteLoadingState extends FavouriteState {}

final class FavouriteSuccessState extends FavouriteState {
  final FavouriteModel favouriteModel;

  FavouriteSuccessState({required this.favouriteModel});
}

final class FavouriteErrorState extends FavouriteState {
  final String message;

  FavouriteErrorState({required this.message});
}
