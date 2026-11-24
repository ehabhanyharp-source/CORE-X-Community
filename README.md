# CORE X Community

A standalone Flutter UI toolkit containing general-purpose components adapted from the CORE X project. This repository is **not** the commercial CORE X SaaS application. It does not contain a backend, production UI, authentication, customer information, analytics, or payment integrations. No accounts or services are required.

## Features

- `GlideScrollController`: accumulated animated pointer scrolling; native scroll behavior when disabled or reduced motion is requested.
- `AdaptiveDensity`: selects a compact layout based on local width and height constraints.
- `DesignStage`: fits a local, fixed-size illustration inside a bounded parent. Do not wrap your entire app in this widget.

## Getting started

Install the Flutter SDK (3.19 or later). Clone this repository, then run `flutter pub get`, `flutter analyze`, and `flutter test` in its root. The package is intentionally not published to pub.dev. Use a local path or Git dependency in another Flutter project.

```dart
import 'package:core_x_community/core_x_community.dart';

final controller = GlideScrollController();
// Pass controller to a ListView, and dispose it with its owner.
```

## Example

The example is a local UI demonstration with generated sample items. To generate platform scaffolding and run it (Windows host and Windows Flutter tooling required for the Windows target):

```sh
cd example
flutter create --platforms=windows,web --project-name community_example .
flutter pub get
flutter run -d windows
```

Alternatively use `flutter run -d chrome` with Flutter web support. No remote services are used.

## Development status

Initial community release. Tests are provided; execution requires the Flutter SDK. Do not claim passing CI or adoption until verified. There is no claim of external users or commercial feature parity.

## License

MIT. The license applies only to the contents of this repository, not to the separate commercial CORE X application or its assets. The repository owner must confirm rights to all included code before publishing.
