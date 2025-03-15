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
  const LanguageAndAuthorSelectionView({super.key});

  @override
  State<LanguageAndAuthorSelectionView> createState() => _LanguageAndAuthorSelectionViewState();
}

class _LanguageAndAuthorSelectionViewState extends State<LanguageAndAuthorSelectionView> {
  late final LanguageAndAuthorCubit _languageAndAuthorCubit;
  Authors? _selectedAuthor;
  int _selectedLanguageIndex = -1;

  @override
  void initState() {
    super.initState();
    _languageAndAuthorCubit = BlocProvider.of<LanguageAndAuthorCubit>(context);
    _languageAndAuthorCubit.getLanguageAndAuthor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Language & Author")),
      body: BlocBuilder<LanguageAndAuthorCubit, LanguageAndAuthorState>(
        builder: (context, state) {
          if (state is LanguageAndAuthorSuccess) {
            final languages = state.languageAndAuthors.result ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Language", style: Theme.of(context).textTheme.titleLarge),
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
                  if (_selectedLanguageIndex != -1) ...[
                    const SizedBox(height: 40),
                    Text("Select Author", style: Theme.of(context).textTheme.titleLarge),
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
                  ]
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_selectedAuthor == null) {
              coreMessenger("Please select an author");
              return;
            }

            prefs.setInt(AppPrefKeys.authorId, _selectedAuthor!.id!.toInt());
            prefs.setInt(AppPrefKeys.languageId, _selectedAuthor!.languageId!.toInt());

            GoRouter.of(context).pushReplacementNamed(AppRoutes.home);
          },
          child: const Text("Save Language & Author"),
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
