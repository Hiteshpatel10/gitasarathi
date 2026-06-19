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
      body: BlocBuilder<AuthCubit, AuthState>(
        // listener: (context, state) {
        //   if (state is AuthFailed) {
        //     coreMessenger(
        //       "Failed to authenticate.",
        //       messageType: CoreScaffoldMessengerType.error,
        //     );
        //
        //     return;
        //   }
        //
        //   if (state is AuthSuccess) {
        //     coreMessenger(
        //       "Successfully signed in.",
        //       messageType: CoreScaffoldMessengerType.success,
        //     );
        //     GoRouter.of(context).pushReplacementNamed(AppRoutes.languageAndAuthor.name);
        //     return;
        //   }
        // },
        builder: (context, state) {
          return Center(
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

                    if (response == null || response['status'] == 0 || response['token'] == null) {
                      coreMessenger(
                        "Failed to authenticate.",
                        messageType: CoreScaffoldMessengerType.error,
                      );
                      return;
                    }

                    coreMessenger(
                      "Successfully signed in.",
                      messageType: CoreScaffoldMessengerType.success,
                    );

                    GoRouter.of(context).pushReplacementNamed(AppRoutes.home.name);
                  },
                  child: state is Authenticating
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(width: 8),
                            Text("Singing In...")
                          ],
                        )
                      : const Text("Start Journey"),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}
