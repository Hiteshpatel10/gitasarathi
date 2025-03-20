import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/components/app_error_widget.dart';
import 'package:chapter/main.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
import 'package:chapter/utility/constants/asset_paths.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:chapter/verse_module/cubit/verse_explanation_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_flip/page_flip.dart';
import 'package:chapter/verse_module/model/verse_explanation_model.dart' as verse_explanation_model;
import 'package:showcaseview/showcaseview.dart';

class VerseExplanationView extends StatefulWidget {
  const VerseExplanationView({super.key, this.verseId});

  final num? verseId;

  @override
  State<VerseExplanationView> createState() => _VerseExplanationViewState();
}

class _VerseExplanationViewState extends State<VerseExplanationView> {
  late final VerseExplanationCubit _verseExplanationCubit;

  List<String> explanationTextSplit = [];
  List<String> commentaryTextSplit = [];
  verse_explanation_model.Result? verse;
  int totalPage = 1;

  final GlobalKey _paginationKey = GlobalKey();
  bool _callShowCase = true;

  @override
  void initState() {
    super.initState();
    _verseExplanationCubit = context.read<VerseExplanationCubit>();
    _verseExplanationCubit.getVerseExplanation(verseId: widget.verseId);
  }

  void _updateUserInteractions({num? chapterNo, num? verseNo}) {
    BlocProvider.of<UserCubit>(context).insertUserActivity(
      chapterNo: chapterNo,
      verseNo: verseNo,
      activity: UserActivity.verseRead,
    );

    if (chapterNo != null && verseNo != null) {
      BlocProvider.of<UserCubit>(context).insertUserRead(
        chapterNo: chapterNo,
        verseNo: verseNo,
      );
    }

    BlocProvider.of<ChaptersAndVerseCubit>(context).getChaptersAndVerse(invalidCache: true);
  }

  void _showIntro(BuildContext context) {
    if (_callShowCase == false) return;

    final canShowIntro = prefs.getBool(AppPrefKeys.showVerseExplanationIntro) ?? true;

    if (canShowIntro == false) {
      _callShowCase = false;
      return;
    }

    _callShowCase = false;

    Future.delayed(Durations.short2, () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_paginationKey]);
        prefs.setBool(AppPrefKeys.showVerseExplanationIntro, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VerseExplanationCubit, VerseExplanationState>(
        builder: (context, state) {
          if (state is VerseExplanationSuccess) {
            verse = state.verseExplanation.result;
            _splitText();

            if (kDebugMode == false) {
              _updateUserInteractions(
                verseNo: verse?.verseNumber,
                chapterNo: verse?.chapterNumber,
              );
            }
            return ShowCaseWidget(
              builder: (showcaseContext) {
                _showIntro(showcaseContext);
                return Showcase.withWidget(
                  key: _paginationKey,
                  blurValue: 4,
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                  container: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        LottieBuilder.asset(
                          AssetPaths.swipeLeftLottie,
                          height: 120,
                        ),
                        const SizedBox(height: 12),
                        const Text("Swipe left and right to turn pages"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ShowCaseWidget.of(showcaseContext).dismiss();
                          },
                          child: const Text("Ok, Got It"),
                        ),
                        const SizedBox(height: 36)
                      ],
                    ),
                  ),
                  child: _buildPageFlip(),
                );
              },
            );
          }
          if (state is ChapterAndVerseErrorState) {
            return const Center(
              child: AppErrorWidget(errorCode: AppErrorCode.serverError),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _splitText() {
    if (verse?.verseTranslation?.isNotEmpty == true) {
      explanationTextSplit = _splitTextIntoPages(verse?.verseTranslation?.first.description ?? '');
      totalPage += explanationTextSplit.length;
    }
    if (verse?.verseCommentary?.isNotEmpty == true) {
      commentaryTextSplit = _splitTextIntoPages(verse?.verseCommentary?.first.description ?? '');
      totalPage += commentaryTextSplit.length;
    }
  }

  List<String> _splitTextIntoPages(String textData) {
    List<String> pageList = [];
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    TextStyle textStyle =
        Theme.of(context).textTheme.headlineSmall ?? const TextStyle(fontSize: 32);
    double pageWidth = MediaQuery.of(context).size.width - 32;
    double pageHeight = MediaQuery.of(context).size.height - 220;

    String remainingText = textData;
    while (remainingText.isNotEmpty) {
      textPainter.text = TextSpan(text: remainingText, style: textStyle);
      textPainter.layout(maxWidth: pageWidth);

      int endIndex = textPainter.getPositionForOffset(Offset(pageWidth, pageHeight)).offset;
      if (endIndex == 0) endIndex = remainingText.length;

      pageList.add(remainingText.substring(0, endIndex).trim());
      remainingText = remainingText.substring(endIndex).trim();
    }
    return pageList;
  }

  Widget _buildPageFlip() {
    return PageFlipWidget(
      backgroundColor: Colors.white,
      // lastPage: Container(
      //   color: Colors.white,
      //   child: const Center(
      //     child: Text('Last Page!'),
      //   ),
      // ),
      children: [
        _buildTitlePage(),
        ..._buildExplanationPages(),
        ..._buildCommentaryPages(),
      ],
    );
  }

  Widget _buildTitlePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          Text(
            "Chapter ${verse?.chapterId} - Verse ${verse?.verseNumber}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Expanded(
            child: Center(
              child: Text(
                verse?.text ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 12),
              child: Text(
                "1 / $totalPage",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExplanationPages() {
    return List.generate(
      explanationTextSplit.length,
      (index) => _buildPage(
        title: "Verse Explanation",
        text: explanationTextSplit[index],
        authorName: verse?.verseTranslation?.first.authorName ?? '',
        language: verse?.verseTranslation?.first.lang ?? '',
        pageIndex: index + 2, // Title page is Page 1
      ),
    );
  }

  List<Widget> _buildCommentaryPages() {
    return List.generate(
      commentaryTextSplit.length,
      (index) => _buildPage(
        title: "Verse Commentary",
        text: commentaryTextSplit[index],
        authorName: verse?.verseCommentary?.first.authorName ?? '',
        language: verse?.verseCommentary?.first.lang ?? '',
        pageIndex: explanationTextSplit.length + index + 2,
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String text,
    required String authorName,
    required String language,
    required int pageIndex, // Added page number
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 20),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$authorName - $language"),
              const SizedBox(height: 10),
              Text(
                "$pageIndex / $totalPage",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}
