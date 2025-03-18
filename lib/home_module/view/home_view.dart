import 'package:chapter/chapter_module/views/chapter_list_view.dart';
import 'package:chapter/utility/services/core_notification_service.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    CoreNotificationService().updateFCMToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const ChapterListView(),
    );
  }
}
