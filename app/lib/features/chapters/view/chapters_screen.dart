import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/router/app_routes.dart';
import 'package:app/core/router/route_destinations.dart';
import '../provider/chapters_providers.dart';
import 'widgets/chapter_card.dart';

class ChaptersScreen extends ConsumerStatefulWidget {
  const ChaptersScreen({super.key});

  @override
  ConsumerState<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends ConsumerState<ChaptersScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(chaptersListProvider);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.systemBackground,
      appBar: AppBar(
        backgroundColor: colors.systemBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'GitaSarathi',
          style: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.label,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colors.label),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(context),
          Expanded(
            child: chaptersAsync.when(
              data: (chapters) {
                if (chapters == null || chapters.isEmpty) {
                  return const Center(child: Text('No chapters found'));
                }

                // Apply filter
                final filteredChapters = chapters.where((c) {
                  if (_selectedFilter == 'All') return true;
                  if (_selectedFilter == 'In Progress') return (c.progress != null && c.progress! > 0 && c.progress! < 100);
                  if (_selectedFilter == 'Completed') return (c.progress != null && c.progress! >= 100);
                  return true;
                }).toList();

                if (filteredChapters.isEmpty) {
                  return const Center(child: Text('No chapters match this filter'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24, top: 8),
                  itemCount: filteredChapters.length,
                  itemBuilder: (context, index) {
                    final chapter = filteredChapters[index];
                    return ChapterCard(
                      chapter: chapter,
                      onTap: () {
                        final destination = VerseListDestination(chapterId: chapter.chapterNumber);
                        context.goNamed(
                          destination.name,
                          pathParameters: destination.pathParameters,
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading chapters: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final colors = context.colors;
    final filters = ['All', 'In Progress', 'Completed'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colors.saffron : colors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : colors.secondaryLabel,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
