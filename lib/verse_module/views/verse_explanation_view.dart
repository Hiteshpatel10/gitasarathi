import 'package:chapter/verse_module/cubit/verse_explanation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerseExplanationView extends StatefulWidget {
  const VerseExplanationView({super.key, this.verseId});

  final num? verseId;

  @override
  State<VerseExplanationView> createState() => _VerseExplanationViewState();
}

class _VerseExplanationViewState extends State<VerseExplanationView> {
  late final VerseExplanationCubit _verseExplanationCubit;

  @override
  void initState() {
    _verseExplanationCubit = VerseExplanationCubit()..getVerseExplanation(verseId: widget.verseId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VerseExplanationCubit, VerseExplanationState>(
        builder: (context, state) {
          return Column(
            children: [],
          );
        },
      ),
    );
  }
}
