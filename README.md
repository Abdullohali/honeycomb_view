# honeycomb_view

A Flutter widget that displays images in a beautiful honeycomb grid layout with a dynamic scale and opacity effect based on scroll position — inspired by Apple Music's artist view.

## Preview

<p>
  <img src="https://raw.githubusercontent.com/Abdullohali/honeycomb_view/main/assets/screenshots/demo.gif" width="250"/>
  &nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/Abdullohali/honeycomb_view/main/assets/screenshots/img1.png" width="250"/>
</p>

## Features

- 🍯 Honeycomb (hex) grid layout
- 🔍 Scale & opacity effect based on scroll distance
- ↔️ Both horizontal and vertical scrolling
- 🎯 Tap callback with image index
- 🎮 Controller for programmatic scroll (e.g. scroll to center)
- 🖼️ Supports both Network and Asset images
- ⚙️ Fully customizable (size, spacing, rows, columns, effects)

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  honeycomb_view: ^0.0.6
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic — Network images (default)

```dart
import 'package:honeycomb_view/honeycomb_view.dart';

HoneyCombView(
  images: [
    'https://example.com/photo1.jpg',
    'https://example.com/photo2.jpg',
    'https://example.com/photo3.jpg',
  ],
)
```

### Asset images

Set `assetsImage: true` to load images from your local assets folder.

```dart
HoneyCombView(
  assetsImage: true,
  images: [
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo3.jpg',
  ],
)
```

> Don't forget to declare your assets in `pubspec.yaml`:
> ```yaml
> flutter:
>   assets:
>     - assets/images/
> ```

### Full example

```dart
import 'package:flutter/material.dart';
import 'package:honeycomb_view/honeycomb_view.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final _controller = HoneyCombController();

  final List<String> images = List.generate(
    100,
    (i) => 'https://picsum.photos/seed/$i/300/300',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: HoneyCombView(
        images: images,
        controller: _controller,
        itemSize: 160,
        spacing: 12,
        rows: 15,
        columns: 20,
        maxDistance: 280,
        minScale: 0.55,
        minOpacity: 0.35,
        onItemTap: (index) => print('Tapped image #$index'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.scrollToCenter,
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `images` | `List<String>` | **required** | Image path or URL list |
| `assetsImage` | `bool` | `false` | `true` → AssetImage, `false` → NetworkImage |
| `itemSize` | `double` | `160` | Circle diameter in pixels |
| `spacing` | `double` | `12` | Gap between items |
| `rows` | `int` | `15` | Number of rows in grid |
| `columns` | `int` | `20` | Number of columns in grid |
| `maxDistance` | `double` | `280` | Distance at which min scale/opacity is reached |
| `maxScale` | `double` | `1.0` | Scale of center items |
| `minScale` | `double` | `0.55` | Scale of far items |
| `maxOpacity` | `double` | `1.0` | Opacity of center items |
| `minOpacity` | `double` | `0.35` | Opacity of far items |
| `backgroundColor` | `Color` | `Colors.black` | Background color |
| `onItemTap` | `ValueChanged<int>?` | `null` | Called with image index on tap |
| `controller` | `HoneyCombController?` | `null` | Controller for scroll actions |

## HoneyCombController

```dart
final controller = HoneyCombController();

// Smoothly scroll to center
controller.scrollToCenter();

// Custom duration
controller.scrollToCenter(duration: Duration(milliseconds: 600));
```

## License

MIT License — see [LICENSE](LICENSE) for details.