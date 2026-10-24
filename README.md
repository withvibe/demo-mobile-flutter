# FieldOps (Flutter) — demo mobile app

The Flutter twin of [withvibe/demo-mobile](https://github.com/withvibe/demo-mobile),
used to demonstrate WithVibe environments running Flutter projects.

The repo intentionally ships only `pubspec.yaml` + `lib/` — the WithVibe
template's bootstrap runs `flutter create --platforms web .` on first start,
then `flutter run -d web-server` with a file watcher that hot-reloads on edits.

Local run: `flutter create --platforms web . && flutter run -d chrome`.
