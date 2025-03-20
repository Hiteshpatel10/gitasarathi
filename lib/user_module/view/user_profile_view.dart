import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapter/main.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/services/rate_my_app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserSuccessState) {
              final user = state.user.result;
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CoreColors.brown,
                        ),
                        child: Text(
                          user?.displayName?[0] ?? '-',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        user?.displayName ?? '-',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  ListTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed(AppRoutes.languageAndAuthor.name, extra: {
                        "edit_mode": true,
                      });
                    },
                    title: const Text("Language and Author"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      rateUs(context);
                    },
                    title: const Text("Rate Us"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      prefs.clear();
                      GoRouter.of(context).pushReplacementNamed(AppRoutes.signIn.name);
                    },
                    title: const Text("Logout"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
