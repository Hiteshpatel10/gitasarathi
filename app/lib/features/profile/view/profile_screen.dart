import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/theme_provider.dart';
import 'package:app/core/theme/font_size_provider.dart';
import 'package:app/features/profile/provider/profile_providers.dart';
import 'package:app/features/home/provider/home_providers.dart';
import 'package:app/core/services/pref_service.dart';
import 'package:app/core/constants/pref_keys.dart';
import 'package:app/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildUserInfoCard(context),
          const SizedBox(height: 16),
          _buildStatsCard(context),
          const SizedBox(height: 24),
          _buildSectionHeader('EXPERIENCE'),
          _buildExperienceSection(context),
          const SizedBox(height: 24),
          _buildSectionHeader('APPEARANCE'),
          _buildAppearanceSection(context),
          const SizedBox(height: 24),
          _buildSectionHeader('ACCOUNT'),
          _buildAccountSection(context),
          const SizedBox(height: 40), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    
    String initials = '';
    String name = '';
    String email = '';
    
    if (profileAsync.hasValue && profileAsync.value != null) {
      final data = profileAsync.value!;
      name = data['display_name'] ?? 'User';
      email = data['email'] ?? '';
      if (name.isNotEmpty) {
        initials = name.substring(0, 1).toUpperCase();
        if (name.contains(' ')) {
          final parts = name.split(' ');
          if (parts.length > 1 && parts[1].isNotEmpty) {
            initials += parts[1].substring(0, 1).toUpperCase();
          }
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.secondaryGroupedBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.separator),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.saffron,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (profileAsync.isLoading)
            const CircularProgressIndicator()
          else ...[
            Text(
              name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.label,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.secondaryLabel,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    final progressAsync = ref.watch(userProgressProvider);
    final streakAsync = ref.watch(streakSummaryProvider);
    
    var versesRead = 0;
    var chaptersRead = 0;
    
    if (progressAsync.hasValue && progressAsync.value != null) {
      final reads = progressAsync.value!['reads'] as List<dynamic>? ?? [];
      versesRead = reads.length;
      final chapters = reads.map((e) => e['chapter']).toSet();
      chaptersRead = chapters.length;
    }
    
    int streak = 0;
    if (streakAsync.hasValue && streakAsync.value != null) {
      streak = streakAsync.value!.currentStreak;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: context.colors.secondaryGroupedBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.separator),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(context, '$versesRead', 'Verses Read'),
          Container(
            width: 1,
            height: 40,
            color: context.colors.separator,
          ),
          _buildStatItem(context, '$chaptersRead', 'Chapters'),
          Container(
            width: 1,
            height: 40,
            color: context.colors.separator,
          ),
          _buildStatItem(context, '$streak', 'Day Streak', icon: Icons.local_fire_department),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, {IconData? icon}) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.saffron, size: 20),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                color: AppColors.saffron,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.colors.secondaryLabel,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: context.colors.secondaryLabel,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildExperienceSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.secondaryGroupedBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.separator),
      ),
      child: ListTile(
        title: Text('Font Size', style: TextStyle(color: context.colors.label)),
        trailing: _buildSegmentedControl(
          options: ['S', 'M', 'L'],
          currentValue: ref.watch(fontSizeProvider),
          onChanged: (val) {
            ref.read(fontSizeProvider.notifier).setFontSize(val);
          },
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.secondaryGroupedBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Theme Selection', style: TextStyle(fontSize: 16, color: context.colors.label)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: _buildThemeOption(context, 'Light', Icons.light_mode_outlined)),
                const SizedBox(width: 8),
                Expanded(child: _buildThemeOption(context, 'Dark', Icons.dark_mode_outlined)),
                const SizedBox(width: 8),
                Expanded(child: _buildThemeOption(context, 'System', Icons.settings_system_daydream_outlined)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String label, IconData icon) {
    final currentThemeMode = ref.watch(themeModeProvider);
    String themeString = 'System';
    if (currentThemeMode == ThemeMode.light) themeString = 'Light';
    if (currentThemeMode == ThemeMode.dark) themeString = 'Dark';
    
    final isSelected = themeString == label;
    
    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).setTheme(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? context.colors.opaqueSeparator
              : context.colors.secondaryGroupedBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.saffron : context.colors.separator,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.saffron : context.colors.secondaryLabel,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.saffron : context.colors.secondaryLabel,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl({
    required List<String> options,
    required String currentValue,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.tertiarySystemBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == currentValue;
          return GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected 
                    ? context.colors.secondaryGroupedBackground
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected 
                      ? AppColors.saffron 
                      : context.colors.secondaryLabel,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.secondaryGroupedBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.separator),
      ),
      child: ListTile(
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.redAccent),
        ),
        trailing: const Icon(Icons.logout, color: Colors.redAccent),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: context.colors.secondaryGroupedBackground,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: context.colors.separator,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: context.colors.label,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Are you sure you want to sign out of your account?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: context.colors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: context.colors.separator),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: context.colors.label,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final prefs = ref.read(prefServiceProvider);
                                await prefs.remove(PrefKeys.userToken);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  context.go(AppRoutes.login.path);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Sign Out',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
