part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoadingState extends OnboardingState {}

final class OnboardingSuccessState extends OnboardingState {
  final OnboardingModel onboarding;

  OnboardingSuccessState({required this.onboarding});
}

final class OnboardingErrorState extends OnboardingState {

  final String message;

  OnboardingErrorState({required this.message});
}
