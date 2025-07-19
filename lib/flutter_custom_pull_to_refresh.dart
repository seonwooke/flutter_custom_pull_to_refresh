import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Custom Pull to Refresh Widget
///
/// A Flutter widget that adds pull-to-refresh functionality to scrollable widgets.
/// Works on both web and mobile environments, and supports custom indicators.
///
/// Usage example:
/// ```dart
/// FlutterCustomPullToRefresh(
///   onRefresh: () async {
///     // Refresh logic
///     await Future.delayed(Duration(seconds: 2));
///   },
///   isRefreshing: _isRefreshing,
///   child: ListView.builder(
///     itemCount: items.length,
///     itemBuilder: (context, index) => ListTile(
///       title: Text(items[index]),
///     ),
///   ),
/// )
/// ```
class CustomPullToRefresh extends StatefulWidget {
  /// Callback function to be executed when refresh is triggered
  final VoidCallback onRefresh;

  /// Whether the widget is currently refreshing
  final bool isRefreshing;

  /// Scroll threshold value that triggers refresh (default: -80.0)
  final double threshold;

  /// Widget to display as refresh indicator
  final Widget? indicatorWidget;

  /// Padding around the indicator widget
  final EdgeInsets indicatorPadding;

  /// Whether the child widget is scrollable
  /// true: Child widget is already scrollable (ListView, GridView, etc.)
  /// false: Child widget is not scrollable (Container, Column, etc.)
  final bool hasScrollableChild;

  /// Child widget
  final Widget child;

  const CustomPullToRefresh({
    Key? key,
    required this.child,
    required this.onRefresh,
    required this.isRefreshing,
    this.threshold = -80.0,
    this.indicatorWidget = const CircularProgressIndicator.adaptive(),
    this.indicatorPadding = const EdgeInsets.symmetric(vertical: 24.0),
    this.hasScrollableChild = true,
  }) : super(key: key);

  @override
  State<CustomPullToRefresh> createState() => _CustomPullToRefreshState();
}

class _CustomPullToRefreshState extends State<CustomPullToRefresh> {
  /// Whether the current scroll exceeds the threshold
  bool _isOverThreshold = false;

  /// Maximum overscroll value during scrolling (negative value)
  double _maxOverscroll = 0.0;

  /// Scroll behavior for web environment (supports both mouse and touch)
  static final _webDragScrollBehavior = WebDragScrollBehavior();

  /// Bouncing scroll physics for mobile environment
  static final _bouncingScrollPhysics = BouncingScrollPhysics();

  /// Scroll behavior for mobile environment
  static final _bouncingScrollBehavior = ScrollBehavior().copyWith(
    physics: _bouncingScrollPhysics,
  );

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      // Apply different scroll behaviors for web and mobile environments
      behavior: kIsWeb ? _webDragScrollBehavior : _bouncingScrollBehavior,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: widget.hasScrollableChild
            ? _buildWithScrollableChild()
            : _buildWithNonScrollableChild(),
      ),
    );
  }

  /// Handles scroll notifications
  ///
  /// [ScrollStartNotification]: Resets max overscroll value when scroll starts
  /// [ScrollUpdateNotification]: Checks threshold and updates state during scroll
  /// [ScrollEndNotification]: Triggers refresh when scroll ends
  bool _handleScrollNotification(ScrollNotification notification) {
    // Reset max overscroll value when scroll starts
    if (notification is ScrollStartNotification) {
      if (_maxOverscroll != 0.0) {
        setState(() {
          _maxOverscroll = 0.0;
        });
      }
      return false;
    }

    // Check threshold during scroll update
    if (notification is ScrollUpdateNotification) {
      final newPixels = notification.metrics.pixels;
      // Only process when scrolling upward (negative values)
      if (newPixels < _maxOverscroll) {
        final newIsOverThreshold = newPixels < widget.threshold;
        // Only call setState when values actually change (performance optimization)
        if (_maxOverscroll != newPixels ||
            _isOverThreshold != newIsOverThreshold) {
          setState(() {
            _maxOverscroll = newPixels;
            _isOverThreshold = newIsOverThreshold;
          });
        }
      }
      return false;
    }

    // Trigger refresh when scroll ends
    if (notification is ScrollEndNotification) {
      // Execute refresh if threshold is exceeded and not currently refreshing
      if (_maxOverscroll < widget.threshold && !widget.isRefreshing) {
        setState(() {
          _isOverThreshold = false;
        });
        widget.onRefresh();
      } else {
        // Reset state if threshold is not exceeded
        if (_isOverThreshold) {
          setState(() {
            _isOverThreshold = false;
          });
        }
      }
      return false;
    }

    return false;
  }

  /// Build method for scrollable child widgets
  ///
  /// Uses Column to arrange indicator and child widget vertically
  Widget _buildWithScrollableChild() {
    return Column(
      children: [
        // Only show indicator when threshold is exceeded or refreshing
        if (_isOverThreshold || widget.isRefreshing)
          Padding(
            padding: widget.indicatorPadding,
            child: widget.indicatorWidget ??
                const CircularProgressIndicator.adaptive(),
          )
        else
          const SizedBox.shrink(),
        Expanded(child: widget.child),
      ],
    );
  }

  /// Build method for non-scrollable child widgets
  ///
  /// Uses ListView to provide scroll functionality
  Widget _buildWithNonScrollableChild() {
    return ListView(
      children: [
        // Only show indicator when threshold is exceeded or refreshing
        if (_isOverThreshold || widget.isRefreshing)
          Padding(
            padding: widget.indicatorPadding,
            child: widget.indicatorWidget ??
                const CircularProgressIndicator.adaptive(),
          )
        else
          const SizedBox.shrink(),
        widget.child,
      ],
    );
  }
}

/// Scroll behavior that supports both mouse and touch on web environment
///
/// Extends MaterialScrollBehavior to enable mouse drag scrolling on web
class WebDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch, // Touch devices (mobile)
        PointerDeviceKind.mouse, // Mouse (web)
      };
}
