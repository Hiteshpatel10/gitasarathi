part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoadingState extends UserState {}

final class UserSuccessState extends UserState {

  final UserModel user;

  UserSuccessState({required this.user});
}

final class UserErrorState extends UserState {}
