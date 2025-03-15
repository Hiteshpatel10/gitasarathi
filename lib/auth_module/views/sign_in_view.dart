import 'package:chapter/auth_module/bloc/auth_cubit.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/messengers/core_scaffold_messenger.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late final AuthCubit _authCubit;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/rasters/logo.png", height: 200, width: 200),
            const SizedBox(height: 24),
            Text(
              "Gita Sarathi",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.w500, color: CoreColors.yellowishOrange),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final response = await _authCubit.signInUser();

                if (response == null || response?['status'] == 0) {
                  coreMessenger(
                    "Failed to authenticate user",
                    messageType: CoreScaffoldMessengerType.error,
                  );
                  return;
                }

                GoRouter.of(context).pushNamed(AppRoutes.languageAndAuthor);
              },
              child: const Text("Start Journey"),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
