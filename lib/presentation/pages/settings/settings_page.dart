import 'dart:io';
import 'package:excel_app/core/services/premium_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_event.dart';
import '../../bloc/theme/theme_state.dart';
import '../../bloc/locale/locale_bloc.dart';
import '../../bloc/locale/locale_event.dart';
import '../../bloc/locale/locale_state.dart';
import '../../bloc/premium/premium_bloc.dart';
import '../../bloc/premium/premium_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: CustomScrollView(
        slivers: [
          // Clean app bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: isDark
                ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
                : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
            title: Text(
              AppLocalizations.of(context)?.settings ?? 'Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPremiumTile(context),
                const SizedBox(height: 24),
                _buildSectionLabel(context, AppLocalizations.of(context)?.appearance ?? 'Appearance', Icons.palette_outlined),
                const SizedBox(height: 12),
                _buildAppearanceSection(context),
                const SizedBox(height: 24),
                _buildSectionLabel(context, AppLocalizations.of(context)?.language ?? 'Language', Icons.language_rounded),
                const SizedBox(height: 12),
                _buildLanguageSection(context),
                const SizedBox(height: 24),
                _buildSectionLabel(context, AppLocalizations.of(context)?.about ?? 'About', Icons.info_outline_rounded),
                const SizedBox(height: 12),
                _buildAboutSection(context),
                const SizedBox(height: 24),
                _buildSectionLabel(context, AppLocalizations.of(context)?.support ?? 'Support', Icons.support_agent_rounded),
                const SizedBox(height: 12),
                _buildSupportSection(context),
              ]),
            ),
          ),
        ],
        ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassmorphicCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return _buildGlassmorphicCard(
      context,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          String currentThemeName;
          IconData themeIcon;
          switch (state.themeMode) {
            case AppThemeMode.light:
              currentThemeName = AppLocalizations.of(context)?.light ?? 'Light';
              themeIcon = Icons.light_mode_rounded;
              break;
            case AppThemeMode.dark:
              currentThemeName = AppLocalizations.of(context)?.dark ?? 'Dark';
              themeIcon = Icons.dark_mode_rounded;
              break;
            case AppThemeMode.system:
              currentThemeName = AppLocalizations.of(context)?.system ?? 'System';
              themeIcon = Icons.settings_suggest_rounded;
              break;
          }
          return _buildModernListItem(
            context,
            icon: themeIcon,
            title: AppLocalizations.of(context)?.theme ?? 'Theme',
            subtitle: currentThemeName,
            onTap: () => _showThemeDialog(context, state.themeMode),
            isLast: true,
          );
        },
      ),
    );
  }

  void _showThemeDialog(BuildContext context, AppThemeMode currentMode) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.theme ?? 'Theme',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildThemeOption(context, dialogContext, AppThemeMode.light, currentMode, Icons.light_mode_rounded, AppLocalizations.of(context)?.light ?? 'Light'),
            const SizedBox(height: 12),
            _buildThemeOption(context, dialogContext, AppThemeMode.dark, currentMode, Icons.dark_mode_rounded, AppLocalizations.of(context)?.dark ?? 'Dark'),
            const SizedBox(height: 12),
            _buildThemeOption(context, dialogContext, AppThemeMode.system, currentMode, Icons.settings_suggest_rounded, AppLocalizations.of(context)?.system ?? 'System'),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    BuildContext dialogContext,
    AppThemeMode mode,
    AppThemeMode currentMode,
    IconData icon,
    String label,
  ) {
    final theme = Theme.of(context);
    final isSelected = mode == currentMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<ThemeBloc>().add(ChangeTheme(mode));
          Navigator.of(dialogContext).pop();
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                      theme.colorScheme.primary.withValues(alpha: 0.08),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.3)
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.15)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return _buildGlassmorphicCard(
      context,
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          String currentLanguageName = 'English';
          String currentFlag = '🇬🇧';
          for (final language in AppConstants.supportedLocales) {
            if (language['code'] == state.locale.languageCode) {
              currentLanguageName = language['name'] as String;
              currentFlag = language['flag'] as String;
              break;
            }
          }
          return _buildModernListItem(
            context,
            icon: Icons.translate_rounded,
            title: AppLocalizations.of(context)?.language ?? 'Language',
            subtitle: '$currentFlag  $currentLanguageName',
            onTap: () => _showLanguageDialog(context, state.locale),
            isLast: true,
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, Locale currentLocale) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)?.language ?? 'Language',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: AppConstants.supportedLocales.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final language = AppConstants.supportedLocales[index];
                      final locale = Locale(language['code'] as String);
                      final isSelected = currentLocale.languageCode == locale.languageCode;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.read<LocaleBloc>().add(ChangeLocale(locale));
                            Navigator.of(dialogContext).pop();
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        theme.colorScheme.primary.withValues(alpha: 0.15),
                                        theme.colorScheme.primary.withValues(alpha: 0.08),
                                      ],
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary.withValues(alpha: 0.3)
                                    : theme.colorScheme.outline.withValues(alpha: 0.1),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  language['flag'] as String,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    language['name'] as String,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildGlassmorphicCard(
      context,
      child: Column(
        children: [
          _buildModernListItem(
            context,
            icon: Icons.apps_rounded,
            title: 'More Apps',
            subtitle: 'Try more amazing apps',
            onTap: () => _launchUrl(AppConstants.appStoreDeveloperUrl),
          ),
          _buildModernListItem(
            context,
            icon: Icons.info_outline_rounded,
            title: AppLocalizations.of(context)?.version ?? 'App Version',
            subtitle: AppConstants.appVersion,
          ),
          _buildModernListItem(
            context,
            icon: Icons.star_rounded,
            title: AppLocalizations.of(context)?.rateApp ?? 'Rate App',
            onTap: () => _showRatingDialog(context),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildGlassmorphicCard(
      context,
      child: Column(
        children: [
          _buildModernListItem(
            context,
            icon: Icons.email_rounded,
            title: AppLocalizations.of(context)?.contactUs ?? 'Contact Support',
            subtitle: AppConstants.supportEmail,
            onTap: () => _launchEmail(AppConstants.supportEmail),
          ),
          _buildModernListItem(
            context,
            icon: Icons.language_rounded,
            title: AppLocalizations.of(context)?.website ?? 'Website',
            subtitle: AppConstants.website,
            onTap: () => _launchUrl('https://${AppConstants.website}'),
          ),
          _buildModernListItem(
            context,
            icon: Icons.shield_outlined,
            title: AppLocalizations.of(context)?.privacyPolicy ?? 'Privacy Policy',
            onTap: () => _launchUrl(AppConstants.privacyPolicyUrl),
          ),
          _buildModernListItem(
            context,
            icon: Icons.description_outlined,
            title: AppLocalizations.of(context)?.termsOfService ?? 'Terms of Service',
            onTap: () => _launchUrl(AppConstants.termsOfServiceUrl),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildModernListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                      theme.colorScheme.primary.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.star_rounded,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.rateOurApp ?? 'Enjoying the App?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)?.rateAppMessage ??
                  'Your feedback helps us improve the app for everyone. Please take a moment to rate us!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)?.later ?? 'Later'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _launchAppStore(context);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)?.rateNow ?? 'Rate Now'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email?subject=Excel Training App Support');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchAppStore(BuildContext context) async {
    final String url;
    if (Platform.isIOS) {
      url = 'https://apps.apple.com/app/${AppConstants.bundleId}';
    } else {
      url = 'https://play.google.com/store/apps/details?id=${AppConstants.bundleId}';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.thankYouRating ?? 'Thank you for your support!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Widget _buildPremiumTile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, premiumState) {
        final isPremium = PremiumService().isPremium;

        return Container(
          decoration: BoxDecoration(
            color: isPremium
                ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.1)
                : theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final isPremiumUser = PremiumService().isPremium;
                if (isPremiumUser) {
                  Navigator.of(context).pushNamed('/premium-unlocked');
                } else {
                  Navigator.of(context).pushNamed('/premium');
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isPremium ? Icons.workspace_premium_rounded : Icons.diamond_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isPremium
                                ? (AppLocalizations.of(context)?.premiumStatusTitle ?? 'Premium Member')
                                : (AppLocalizations.of(context)?.premiumTitle ?? 'Unlock Premium'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isPremium
                                ? (AppLocalizations.of(context)?.premiumStatusSubtitle ?? 'Unlimited access to all features')
                                : (AppLocalizations.of(context)?.premiumSubtitle ?? 'Get unlimited access'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isPremium ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
