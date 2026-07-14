# Parking Operations — Flutter App

A Flutter conversion of the 7 HTML/Tailwind mockups: Login, Dashboard,
Scan/Enter Ticket, Manual Transaction, Ticket Detail (QR), Sync Transactions,
and Settings.

## Setup

```bash
# from this folder
flutter pub get
flutter run -d chrome   # or any connected device/emulator
```

## Structure

```
lib/
  main.dart                      # MaterialApp + named routes
  theme/app_colors.dart          # Color palette (matches Tailwind hex values)
  widgets/
    app_header.dart              # Shared "Parking Operations" header + triangle
    header_triangle.dart         # CustomPainter for the corner triangle accent
    bottom_nav_bar.dart          # Dashboard / Tickets / Settings nav bar
    transaction_list_item.dart   # Reusable transaction row
    app_icons.dart               # Exact SVG icon set (via flutter_svg)
  screens/
    login_screen.dart
    dashboard_screen.dart
    scan_ticket_screen.dart
    manual_transaction_screen.dart
    ticket_detail_screen.dart
    sync_transactions_screen.dart
    settings_screen.dart
```

## Navigation flow

- `/login` → `/dashboard` (on successful login)
- Bottom nav switches between `/dashboard`, `/tickets`, `/settings`
- `/tickets` → `/ticket-detail` ("Enter Ticket") or `/manual-transaction`
  ("Manual Transaction")
- `/settings` → Logout returns to `/login`
- `/sync-transactions` isn't wired to a nav tab in the mockups, so it's
  reachable only via direct route (`Navigator.pushNamed(context, '/sync-transactions')`)
  — hook it up to wherever your app needs it (e.g. a "Sync" action).

## Notes on 1:1 fidelity

- **Icons**: recreated using the exact `<path>` data from the HTML SVGs
  (via `flutter_svg`'s `SvgPicture.string`), not swapped for generic
  Material icons — so shapes match precisely.
- **Header triangle**: the CSS `border-width` corner-triangle trick is
  recreated with a `CustomPainter`.
- **Dashed QR scanner border**: Flutter's `BoxDecoration` has no built-in
  dashed border, so this is drawn with a small `CustomPainter`.
- **Bottom nav active-tab color**: the mockups use 4 slightly different
  blues (`#D1E4FF`, `#D1E5F7`, `#D3E3FD`, `#d1e5ff`) and two different
  shapes (pill vs. rounded-rect) across screens. This build unifies them
  into one consistent pill style/color for a cleaner design system —
  functionally identical, minor cosmetic simplification.
- **Fonts**: uses the platform default sans-serif (Segoe UI on Windows,
  San Francisco on macOS/iOS, Roboto on Android) rather than the `Inter`
  font some mockups `@import`ed. `google_fonts` was deliberately left
  out — it depends on `path_provider`, a plugin with native platform code
  that requires Windows Developer Mode / symlink support to build. Since
  `flutter_svg` (used for icons) is pure Dart with no native code, this
  project now has **zero plugins**, so `flutter run -d windows` works
  out of the box with no extra machine setup. If you want pixel-exact
  Inter, download the font files and bundle them as local assets in
  `pubspec.yaml`'s `fonts:` section instead of using the `google_fonts`
  package.
- Static `data-purpose` values / placeholder empty spans (e.g. blank
  License Plate/Time-In on the ticket detail screen) are preserved as
  empty text, ready to be wired to real data.
