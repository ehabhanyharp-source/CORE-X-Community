# CORE X Community

A small MIT-licensed Flutter desktop UI toolkit with reusable, local-only components. This is not the commercial CORE X application: no backend, customer data, payment integrations, authentication, or proprietary commercial UI is included.

**Status:** 0.2.0 release candidate. CI results, pub.dev publication and external adoption are not claimed until verified.

## Components

| API | Use |
| --- | --- |
| `GlideScrollController` | Smooth pointer scrolling with native fallback for reduced motion |
| `AdaptiveDensity` | Compact layout based on local constraints |
| `DesignStage` | Fit a fixed-size illustration into a bounded parent |
| `ResponsiveTileGrid` | Width-aware wrapping tiles |
| `DesktopKeyboardScope` | Local keyboard callbacks without global key capture |
| `MotionSwap` | Cross-fade with reduced-motion support |
| `ToolkitTable<T>` | Controlled sorting and lazy row rendering for bounded local datasets |
| `stableSortedRows` | Stable sorted copy without mutating input |

## Install from Git

```yaml
dependencies:
  core_x_community:
    git:
      url: https://github.com/ehabhanyharp-source/CORE-X-Community.git
```

Use a reviewed commit SHA for reproducible deployments. Package publication on pub.dev is not yet confirmed.

```dart
import 'package:core_x_community/core_x_community.dart';

final controller = GlideScrollController();
// Use in a ListView and dispose it with its owner.
```

For a sortable table, put `ToolkitTable` in an `Expanded` or a fixed-height box. Keep `sortColumn` and `ascending` in host state and update them from `onSort`. Supply text cells or any local widget. See `example/lib/main.dart` for a working example source. Sorting runs synchronously; paginate large datasets in the host.

## Example

From a Flutter-enabled machine:

```sh
cd example
flutter create --platforms=windows,web --project-name community_example .
flutter pub get
flutter run -d chrome
```

Use `flutter run -d windows` on a Windows host with Windows tooling. The demo contains synthetic sample rows only. Resize the window, click table headers, use Ctrl+K to switch views, and toggle the theme. Actual screenshots should be captured after running the example; no synthetic screenshot is represented as a running app.

## Verify

```sh
flutter pub get
(cd example && flutter pub get)
flutter analyze --no-fatal-infos
flutter test
flutter pub publish --dry-run
```

CI checks minimum Flutter 3.19.6 and current stable. Warnings and errors remain fatal; informational findings are still logged. Flutter tests must pass before cutting a release. No accounts or network services are required by the library at runtime.

## Contribute

See [CONTRIBUTING.md](CONTRIBUTING.md), [ROADMAP.md](ROADMAP.md), and [SECURITY.md](SECURITY.md). Please report reproducible bugs and actual use cases, not artificial engagement.

## License

MIT applies to this repository only, not to the separate CORE X commercial application or its assets. The maintainer must hold rights to all included code before publishing.
