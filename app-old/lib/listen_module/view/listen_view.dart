import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListenView extends StatelessWidget {
  const ListenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Listen Gita",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: CustomScrollView(
        slivers: [

          
        ],
      )
    );
  }
}

