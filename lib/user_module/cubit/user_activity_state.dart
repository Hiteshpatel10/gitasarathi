part of 'user_activity_cubit.dart';

@immutable
sealed class UserActivityState {}

final class UserActivityInitial extends UserActivityState {}

final class UserActivityLoadingState extends UserActivityState {}
final class UserActivitySuccessState extends UserActivityState {

  final UserActivityModel userActivity;

  UserActivitySuccessState({required this.userActivity});
}
final class UserActivityErrorState extends UserActivityState {}
