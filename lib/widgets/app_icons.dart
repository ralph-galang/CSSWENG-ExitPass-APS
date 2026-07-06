import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders one of the raw SVG path strings copied from the source HTML,
/// tinted with [color]. Using the exact path data (rather than swapping in
/// a generic Material icon) keeps the shapes pixel-faithful to the mockups.
class AppIcon extends StatelessWidget {
  final String svg;
  final double size;
  final Color color;

  const AppIcon({
    super.key,
    required this.svg,
    this.size = 24,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

/// Raw SVG strings, one per icon used across the mockups.
class AppIcons {
  AppIcons._();

  // Warning triangle (Alert banner) — stroke-width 2.5
  static const warning = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2.5">
  <path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Stacked bars / "Pending Sync" icon
  static const stackedBars = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2">
  <path d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Clock (transaction list items)
  static const clock = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2">
  <path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Chevron right (fill based)
  static const chevronRight = '''
<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" fill="black">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"/>
</svg>''';

  // Chevron down (select dropdown)
  static const chevronDown = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2">
  <path d="M19 9l-7 7-7-7" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Grid / dashboard icon
  static const grid = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2">
  <path d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Ticket icon
  static const ticket = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2">
  <path d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Settings gear icon
  static const settingsGear = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2">
  <path d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Cloud upload icon (Sync Transactions button)
  static const cloudUpload = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2">
  <path d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  // Cash / banknote icon (Amount Due field)
  static const cash = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2">
  <rect x="2" y="6" width="20" height="12" rx="2"/>
  <circle cx="12" cy="12" r="3"/>
</svg>''';

  // QR-frame corner-brackets icon (scan screen placeholder)
  static const qrFrame = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="black" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3" y="3" width="7" height="7"/>
  <rect x="14" y="3" width="7" height="7"/>
  <rect x="14" y="14" width="7" height="7"/>
  <rect x="3" y="14" width="7" height="7"/>
  <line x1="7" y1="7" x2="7" y2="7"/>
  <line x1="17" y1="7" x2="17" y2="7"/>
  <line x1="17" y1="17" x2="17" y2="17"/>
  <line x1="7" y1="17" x2="7" y2="17"/>
</svg>''';

  // Generated QR code graphic (ticket detail screen) — fill based
  static const qrCode = '''
<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" fill="black">
  <path d="M0 0h30v10H10v20H0V0zm70 0h30v30h-10V10H70V0zM0 70h10v20h20v10H0V70zm100 30H70v-10h20V70h10v30zM20 20h20v20H20V20zm40 0h20v20H60V20zm0 40h20v20H60V60zM45 45h10v10H45v-10zM30 60h10v10H30v-10zm10 10h10v10H40v-10zm10-10h10v10H50v-10z"/>
</svg>''';
}
