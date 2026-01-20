import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_settings_provider.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/neon_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    final notifier = ref.read(userSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSectionHeader('LANGUAGE'),
            _buildSettingCard(
              title: 'UI Language',
              subtitle: settings.uiLanguage == 'en' ? 'English' : 'العربية',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showLanguagePicker(context, notifier, settings.uiLanguage);
              },
            ),
            _buildSettingCard(
              title: 'Default Translation',
              subtitle: 'English → Arabic',
              onTap: () {
                _showTranslationPicker(context, notifier,
                    settings.sourceLanguage, settings.targetLanguage);
              },
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('FEEDBACK & EXPERIENCE'),
            _buildSwitchCard(
              title: 'Sound Effects',
              value: settings.soundsEnabled,
              onChanged: (val) => notifier.toggleSounds(val),
              icon: Icons.volume_up,
            ),
            _buildSwitchCard(
              title: 'Haptic Feedback',
              value: settings.hapticsEnabled,
              onChanged: (val) => notifier.toggleHaptics(val),
              icon: Icons.vibration,
            ),
            _buildSwitchCard(
              title: 'Auto-scroll Subtitles',
              value: settings.autoScroll,
              onChanged: (val) => notifier.toggleAutoScroll(val),
              icon: Icons.history,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('ACCOUNT'),
            _buildSettingCard(
              title: 'Sign Out',
              subtitle: 'Logged in as Guest',
              textColor: NeonColors.error,
              onTap: () {
                _showSignOutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: NeonTextStyles.labelSmall.copyWith(color: NeonColors.neonPink),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        borderColor: NeonColors.neonCyan.withValues(alpha: 0.3),
        padding: const EdgeInsets.all(20),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: NeonTextStyles.bodyLarge.copyWith(color: textColor)),
                Text(subtitle, style: NeonTextStyles.bodySmall),
              ],
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        borderColor: NeonColors.neonPurple.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: NeonColors.neonPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: NeonTextStyles.bodyLarge),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: NeonColors.neonPurple,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, UserSettingsNotifier notifier, String currentLang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NeonColors.darkBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Language', style: NeonTextStyles.headlineSmall),
            const SizedBox(height: 16),
            _buildLanguageOption(
              context,
              'English',
              'en',
              currentLang,
              (val) => notifier.setUiLanguage(val),
            ),
            _buildLanguageOption(
              context,
              'العربية',
              'ar',
              currentLang,
              (val) => notifier.setUiLanguage(val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String title, String value,
      String groupValue, Function(String) onChanged) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () {
        onChanged(value);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: NeonTextStyles.bodyLarge.copyWith(
                  color: isSelected ? NeonColors.neonCyan : Colors.white,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check, color: NeonColors.neonCyan),
          ],
        ),
      ),
    );
  }

  void _showTranslationPicker(BuildContext context,
      UserSettingsNotifier notifier, String source, String target) {
    // For now, simpler implementation: toggle between En->Ar and Ar->En
    showModalBottomSheet(
      context: context,
      backgroundColor: NeonColors.darkBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Translation Direction', style: NeonTextStyles.headlineSmall),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                notifier.setSourceLanguage('en');
                notifier.setTargetLanguage('ar');
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text('English → Arabic',
                            style: NeonTextStyles.bodyLarge)),
                    if (source == 'en' && target == 'ar')
                      const Icon(Icons.check, color: NeonColors.neonCyan),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                notifier.setSourceLanguage('ar');
                notifier.setTargetLanguage('en');
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text('Arabic → English',
                            style: NeonTextStyles.bodyLarge)),
                    if (source == 'ar' && target == 'en')
                      const Icon(Icons.check, color: NeonColors.neonCyan),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeonColors.darkBg,
        title: Text('Sign Out', style: NeonTextStyles.headlineSmall),
        content: Text('Are you sure you want to sign out?',
            style: NeonTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: NeonTextStyles.labelLarge),
          ),
          TextButton(
            onPressed: () {
              // Mock sign out
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Signed out successfully (Guest Mode)')),
              );
            },
            child: Text('SIGN OUT',
                style: NeonTextStyles.labelLarge
                    .copyWith(color: NeonColors.error)),
          ),
        ],
      ),
    );
  }
}
