import 'package:chapter/home_module/cubit/onboarding_cubit.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/navigation/go_config.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) async {
          if (state is OnboardingSuccessState) {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();

            String buildNumber = packageInfo.buildNumber;
            bool isInReview = (state.onboarding.googleReview?.buildNo ?? 0) >=
                int.parse(buildNumber);

            if (isInReview && state.onboarding.googleReview?.inReview == true) {
              prefs.setString(
                AppPrefKeys.token,
                state.onboarding.googleReview?.token ?? '',
              );
              goConfig.pushReplacementNamed(AppRoutes.languageAndAuthor);
            } else {
              goConfig.pushReplacementNamed(AppRoutes.signIn);
            }
          }
        },
        builder: (context, state) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
