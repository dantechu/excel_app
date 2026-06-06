import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/services/thumbnail_cache_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/localization_helper.dart';
import '../../domain/entities/video.dart';

class BookmarkCard extends StatefulWidget {
  final Video video;
  final bool isPremiumUser;
  final VoidCallback onTap;

  const BookmarkCard({
    super.key,
    required this.video,
    required this.isPremiumUser,
    required this.onTap,
  });

  @override
  State<BookmarkCard> createState() => _BookmarkCardState();
}

class _BookmarkCardState extends State<BookmarkCard> {
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
  void didUpdateWidget(BookmarkCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.videoUrl != widget.video.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    if (widget.video.thumbnailUrl != null && widget.video.thumbnailUrl!.isNotEmpty) {
      if (mounted) {
        setState(() {
          _thumbnailLoading = false;
          _thumbnailError = false;
        });
      }
      return;
    }

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
    final langCode = LocalizationHelper.getCurrentLanguageCode(context);

    return SizedBox(
      width: 200,
      child: Container(
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
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppColors.radiusMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail with 16:9 aspect ratio
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppColors.radiusMD),
                    topRight: Radius.circular(AppColors.radiusMD),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildThumbnailImage(theme, isLocked),

                        // Gradient overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Play button
                        if (!isLocked && !_thumbnailLoading && !_thumbnailError &&
                            (_thumbnailData != null || (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty)))
                          Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),

                        // Duration badge
                        if (video.duration.inSeconds > 0)
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(AppColors.radiusXS),
                              ),
                              child: Text(
                                _formatDuration(video.duration.inSeconds),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        // PRO badge
                        if (video.isPremium)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(AppColors.radiusXS),
                              ),
                              child: Text(
                                'PRO',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                        // Lock overlay
                        if (isLocked)
                          Container(
                            color: Colors.black.withValues(alpha: 0.5),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Title
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      video.getLocalizedTitle(langCode),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.3,
                        color: isLocked
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                            : theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailImage(ThemeData theme, bool isLocked) {
    if (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: video.thumbnailUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(theme, isLocked, isLoading: true),
        errorWidget: (context, url, error) => _buildPlaceholder(theme, isLocked),
      );
    }

    if (_thumbnailData != null) {
      return Image.memory(
        _thumbnailData!,
        fit: BoxFit.cover,
      );
    }

    if (_thumbnailLoading) {
      return _buildPlaceholder(theme, isLocked, isLoading: true);
    }

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
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: theme.colorScheme.primary.withValues(alpha: 0.6),
                ),
              )
            : Icon(
                Icons.play_circle_outline_rounded,
                size: 36,
                color: isLocked
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                    : theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
