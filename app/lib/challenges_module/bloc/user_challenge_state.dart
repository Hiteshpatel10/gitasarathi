part of 'user_challenge_cubit.dart';

@immutable
sealed class UserChallengeState {}

final class UserChallengeInitial extends UserChallengeState {}

final class UserChallengeLoadingState extends UserChallengeState {}

final class UserChallengeSuccessState extends UserChallengeState {
  final UserChallengeAndChallengesModel challenges;

  UserChallengeSuccessState({required this.challenges});
}

final class UserChallengeEmptyState extends UserChallengeState {}


final class UserChallengeErrorState extends UserChallengeState {}
