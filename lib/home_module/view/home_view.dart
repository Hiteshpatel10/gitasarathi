import 'package:chapter/chapter_module/views/chapter_list_view.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
import 'package:chapter/utility/services/app_update_service.dart';
import 'package:chapter/utility/services/core_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    CoreNotificationService().updateFCMToken();
    _checkForUpdate();
    super.initState();
  }

  void _checkForUpdate() async {
    final userCubit = BlocProvider.of<UserCubit>(context);
    await userCubit.getUser();

    if (userCubit.state is UserSuccessState) {
      final userState = userCubit.state as UserSuccessState;
      appUpdateCheck(appUpdate: userState.user.appUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const ChapterListView(),
    );
  }
}
