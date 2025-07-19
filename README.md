# Custom Pull To Refresh

A Flutter widget that adds pull-to-refresh functionality to scrollable widgets. Works on both web and mobile environments and supports custom indicators.

## Features

- 🎨 **Custom Indicator**: Use any widget as a refresh indicator
- 🌐 **Web/Mobile Support**: Mouse and touch support on web, bouncing scroll on mobile
- 📱 **Scroll Detection**: Automatically detects scrollable and non-scrollable content
- ⚙️ **Threshold Setting**: Adjustable scroll distance to trigger refresh

## Demo

<table>
<tr>
<td align="center">
<strong>Default Indicator</strong><br/>
<img src="https://github.com/seonwooke/assets-management/raw/main/flutter_custom_pull_to_refresh/default_indicator_example.gif" width="240"/>
</td>
<td align="center">
<strong>Custom Indicator</strong><br/>
<img src="https://github.com/seonwooke/assets-management/raw/main/flutter_custom_pull_to_refresh/custom_indicator_example.gif" width="240"/>
</td>
<td align="center">
<strong>Non-Scrollable Content</strong><br/>
<img src="https://github.com/seonwooke/assets-management/raw/main/flutter_custom_pull_to_refresh/not_scrollable_example.gif" width="240"/>
</td>
</tr>
</table>

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_custom_pull_to_refresh: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:flutter_custom_pull_to_refresh/flutter_custom_pull_to_refresh.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return FlutterCustomPullToRefresh(
      onRefresh: () {} // Refresh logic,
      isRefreshing: _isRefreshing, // Refresh state
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }
}
```

### Custom Indicator

```dart
FlutterCustomPullToRefresh(
  onRefresh: () {} // Refresh logic,
  isRefreshing: _isRefreshing, // Refresh state
  indicatorWidget: Container(
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        SizedBox(width: 12),
        Text(
          'Refreshing...',
          style: TextStyle(color: Colors.blue),
        ),
      ],
    ),
  ),
  indicatorPadding: const EdgeInsets.symmetric(
    vertical: 24.0,
  ),
  child: YourContent(),
)
```

### Non-Scrollable Content

```dart
FlutterCustomPullToRefresh(
  onRefresh: () {} // Refresh logic,
  isRefreshing: _isRefreshing, // Refresh state
  hasScrollableChild: false, // Required for non-scrollable content
  child: Column(
    children: [
      Container(
        height: 200,
        color: Colors.blue,
        child: Center(
          child: Text(
            'Non-scrollable content',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      // More widgets...
    ],
  ),
)
```

## Indicator States

### CustomPullToRefresh

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `child` - Widget to wrap with pull-to-refresh functionality | `Widget` | ✅ | - | |
| `onRefresh` - Callback function executed when refresh is triggered | `VoidCallback` | ✅ | - | |
| `isRefreshing` - Whether the widget is currently refreshing | `bool` | ✅ | - | |
| `threshold` - Scroll threshold that triggers refresh (negative value) | `double` | ❌ | `-80.0` | |
| `indicatorWidget` - Custom widget to display as refresh indicator | `Widget?` | ❌ | `CircularProgressIndicator.adaptive()` | |
| `indicatorPadding` - Padding around the indicator widget | `EdgeInsets` | ❌ | `EdgeInsets.symmetric(vertical: 24.0)` | |
| `hasScrollableChild` - Whether the child widget is already scrollable | `bool` | ❌ | `true` | |


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please file an issue on the [GitHub repository](https://github.com/seonwooke/flutter_custom_pull_to_refresh).
