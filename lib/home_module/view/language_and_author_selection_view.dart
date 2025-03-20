import 'package:chapter/home_module/cubit/language_and_author_cubit.dart';
import 'package:chapter/home_module/model/language_and_author_model.dart';
import 'package:chapter/main.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/messengers/core_scaffold_messenger.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LanguageAndAuthorSelectionView extends StatefulWidget {
  const LanguageAndAuthorSelectionView({super.key, required this.editMode});

  final bool editMode;

  @override
  State<LanguageAndAuthorSelectionView> createState() => _LanguageAndAuthorSelectionViewState();
}

class _LanguageAndAuthorSelectionViewState extends State<LanguageAndAuthorSelectionView> {
  late final LanguageAndAuthorCubit _languageAndAuthorCubit;
  late final PageController _pageController;
  Authors? _selectedAuthor;
  int _selectedLanguageIndex = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _languageAndAuthorCubit = BlocProvider.of<LanguageAndAuthorCubit>(context);
    _pageController = PageController();
    _languageAndAuthorCubit.getLanguageAndAuthor().then((value) {
      if (_languageAndAuthorCubit.state is LanguageAndAuthorSuccess) {
        final state = _languageAndAuthorCubit.state as LanguageAndAuthorSuccess;
        fillData(state.languageAndAuthors);
      }
    });
  }

  void fillData(LanguageAndAuthorModel? languageAndAuthor) {
    if (widget.editMode == false) {
      return;
    }

    final authorId = prefs.getInt(AppPrefKeys.authorId);
    final languageId = prefs.getInt(AppPrefKeys.languageId);

    if (languageId == null) return;

    for (int index = 0; index < (languageAndAuthor?.result?.length ?? 0); index++) {
      final language = languageAndAuthor!.result?[index];

      if (language?.id == languageId) {
        for (var element in language?.authors ?? []) {
          if (authorId == element.id) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _selectedLanguageIndex = index;
                _selectedAuthor = element;
              });
            });
            return;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Language & Author")),
      body: BlocBuilder<LanguageAndAuthorCubit, LanguageAndAuthorState>(
        builder: (context, state) {
          if (state is LanguageAndAuthorSuccess) {
            final languages = state.languageAndAuthors.result ?? [];

            return PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        "Select Translation Language",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        runSpacing: 12,
                        spacing: 12,
                        children: List.generate(languages.length, (index) {
                          final language = languages[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLanguageIndex = index;
                                _selectedAuthor = null;
                              });
                            },
                            child: _buildSelector(
                              name: language.language,
                              isSelected: index == _selectedLanguageIndex,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        "Select Translation Author",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        runSpacing: 12,
                        spacing: 12,
                        children: List.generate(
                          languages[_selectedLanguageIndex].authors?.length ?? 0,
                          (index) {
                            final author = languages[_selectedLanguageIndex].authors?[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedAuthor = author);
                              },
                              child: _buildSelector(
                                name: author?.name,
                                isSelected: author?.id == _selectedAuthor?.id,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentIndex != 0) ...[
              Flexible(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                  onPressed: () {
                    _pageController.previousPage(duration: Durations.long2, curve: Curves.easeOut);
                  },
                  child: const Text("Back"),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
                onPressed: () {
                  if (_selectedLanguageIndex == -1) {
                    coreMessenger(
                      "Please select language",
                      messageType: CoreScaffoldMessengerType.error,
                    );
                    return;
                  }

                  if (_currentIndex == 0) {
                    _pageController.nextPage(duration: Durations.long2, curve: Curves.easeOut);
                    return;
                  }

                  if (_selectedAuthor == null) {
                    coreMessenger(
                      "Please select an author",
                      messageType: CoreScaffoldMessengerType.error,
                    );
                    return;
                  }

                  prefs.setInt(AppPrefKeys.authorId, _selectedAuthor!.id!.toInt());
                  prefs.setInt(AppPrefKeys.languageId, _selectedAuthor!.languageId!.toInt());

                  GoRouter.of(context).pushReplacementNamed(AppRoutes.home.name);
                },
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector({String? name, required bool isSelected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: CoreColors.brown),
        borderRadius: BorderRadius.circular(24),
        color: isSelected ? Colors.brown : Colors.transparent,
      ),
      child: Text(
        name ?? '-',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: isSelected ? Colors.white : CoreColors.brown),
      ),
    );
  }
}
