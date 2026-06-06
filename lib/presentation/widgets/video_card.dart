import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/services/thumbnail_cache_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/localization_helper.dart';
import '../../domain/entities/section.dart';
import '../../domain/entities/video.dart';
import '../bloc/bookmark/bookmark_bloc.dart';
import '../bloc/bookmark/bookmark_event.dart';
import '../bloc/bookmark/bookmark_state.dart';

class VideoCard extends StatefulWidget {
  final Video video;
  final bool isPremiumUser;
  final VoidCallback onTap;
  final List<Section>? sections;

  const VideoCard({
    super.key,
    required this.video,
    required this.isPremiumUser,
    required this.onTap,
    this.sections,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  final ThumbnailCacheService _thumbnailCache = ThumbnailCacheService();
  Uint8List? _thumbnailData;
  bool _thumbnailLoading = true;
  bool _thumbnailError = false;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(VideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.videoUrl != widget.video.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    // If thumbnailUrl is provided, we'll use CachedNetworkImage instead
    if (widget.video.thumbnailUrl != null && widget.video.thumbnailUrl!.isNotEmpty) {
      if (mounted) {
        setState(() {
          _thumbnailLoading = false;
          _thumbnailError = false;
        });
      }
      return;
    }

    // Check cache first
    final cached = _thumbnailCache.getCached(widget.video.videoUrl);
    if (cached != null) {
      if (mounted) {
        setState(() {
          _thumbnailData = cached;
          _thumbnailLoading = false;
          _thumbnailError = false;
        });
      }
      return;
    }

    // Extract thumbnail using cache service
    final thumbnail = await _thumbnailCache.getThumbnail(widget.video.videoUrl);

    if (mounted) {
      setState(() {
        _thumbnailData = thumbnail;
        _thumbnailLoading = false;
        _thumbnailError = thumbnail == null;
      });
    }
  }

  Video get video => widget.video;
  bool get isPremiumUser => widget.isPremiumUser;
  VoidCallback get onTap => widget.onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLocked = video.isPremium && !isPremiumUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppColors.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusMD),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail section - 16:9 aspect ratio like Udemy
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildThumbnail(theme, isLocked),
              ),
              // Content section
              _buildContent(theme, isLocked),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(ThemeData theme, bool isLocked) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppColors.radiusMD),
          topRight: Radius.circular(AppColors.radiusMD),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail image or placeholder
          _buildThumbnailImage(theme, isLocked),

          // Gradient overlay for better text visibility
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),

          // Play button overlay
          if (!isLocked && !_thumbnailLoading && !_thumbnailError && (_thumbnailData != null || (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty)))
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),

          // Duration badge - bottom right
          if (video.duration.inSeconds > 0)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(AppColors.radiusXS),
                ),
                child: Text(
                  _formatDuration(video.duration.inSeconds),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // PRO badge - top right
          if (video.isPremium)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppColors.radiusXS),
                ),
                child: Text(
                  'PRO',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

          // Premium lock overlay
          if (isLocked)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnailImage(ThemeData theme, bool isLocked) {
    // If thumbnailUrl is provided, use CachedNetworkImage
    if (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: video.thumbnailUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(theme, isLocked, isLoading: true),
        errorWidget: (context, url, error) => _buildPlaceholder(theme, isLocked),
      );
    }

    // If thumbnail was extracted from video
    if (_thumbnailData != null) {
      return Image.memory(
        _thumbnailData!,
        fit: BoxFit.cover,
      );
    }

    // Loading state
    if (_thumbnailLoading) {
      return _buildPlaceholder(theme, isLocked, isLoading: true);
    }

    // Fallback placeholder
    return _buildPlaceholder(theme, isLocked);
  }

  Widget _buildPlaceholder(ThemeData theme, bool isLocked, {bool isLoading = false}) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      color: isDark
          ? AppColors.surfaceDarkAlt
          : AppColors.backgroundLightAlt,
      child: Center(
        child: isLoading
            ? SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: theme.colorScheme.primary.withValues(alpha: 0.6),
                ),
              )
            : Icon(
                Icons.play_circle_outline_rounded,
                size: 48,
                color: isLocked
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                    : theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
      ),
    );
  }

  /// Get localized section name from sections list or fall back to category
  String _getLocalizedSectionName(String langCode) {
    if (widget.sections != null) {
      // Try to find section by sectionNumber first
      final section = widget.sections!.where(
        (s) => s.sectionNumber == video.sectionNumber
      ).firstOrNull;
      if (section != null) {
        return section.getLocalizedTitle(langCode);
      }
      // Fall back to matching by title
      final sectionByTitle = widget.sections!.where(
        (s) => s.title == video.category
      ).firstOrNull;
      if (sectionByTitle != null) {
        return sectionByTitle.getLocalizedTitle(langCode);
      }
    }
    // Fall back to helper
    return LocalizationHelper.getLocalizedCategoryName(context, video.category);
  }

  Widget _buildContent(ThemeData theme, bool isLocked) {
    final langCode = LocalizationHelper.getCurrentLanguageCode(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            video.getLocalizedTitle(langCode),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: isLocked
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                  : theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Category row with bookmark
          Row(
            children: [
              // Category/Section name
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 14,
                      color: theme.colorScheme.primary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _getLocalizedSectionName(langCode),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Bookmark button
              BlocBuilder<BookmarkBloc, BookmarkState>(
                builder: (context, state) {
                  final isBookmarked = state is BookmarkLoaded &&
                      state.isVideoBookmarked(video.id);
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        context.read<BookmarkBloc>().add(ToggleBookmark(video.id));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isBookmarked
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          size: 22,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
