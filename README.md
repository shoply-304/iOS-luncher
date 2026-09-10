# iOS Launcher

Flutter Android launcher project.

## GitHub-only build
Upload the complete project to GitHub and the workflow in `.github/workflows/build.yml`
will build a release APK automatically.

## Main source files
- `lib/main.dart`
- `lib/models.dart`
- `lib/layout_store.dart`
- `lib/home_screen.dart`
- `lib/control_center.dart`
- `lib/settings_screen.dart`
- `lib/wallpaper_service.dart`

The launcher is iPhone-inspired but remains a normal Android app. System actions that
Android does not permit a third-party launcher to perform directly open the appropriate
Android settings/system panel instead of showing a fake state.
