//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: app_theme.dart                                                                                   #
//# File Description: Defines the SAS CI360 brand-consistent Material 3 theme, colour palette, text styles, and reusable component styles used across the app. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── SAS CI360 brand colours ──────────────────────────────────────────────────
const Color kPrimary = Color(0xFF0C5CA8); // SAS blue
const Color kSecondary = Color(0xFF00A3E0); // SAS light blue
const Color kBackground = Color(0xFFF4F6FA); // page background
const Color kSurface = Colors.white;
const Color kBorder = Color(0xFFDDE1E7);
const Color kTextMuted = Color(0xFF6B7280);
const Color kTextLight = Color(0xFF9CA3AF);

// ── Icon accent colours (used on nav tiles) ─────────────────────────────────
const Color kIconBlue = kPrimary;
const Color kIconTeal = kSecondary;
const Color kIconPurple = Color(0xFF7B61FF);
const Color kIconGreen = Color(0xFF10B981);
const Color kIconAmber = Color(0xFFF59E0B);

// ── App-wide MaterialApp theme ───────────────────────────────────────────────
ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      primary: kPrimary,
      secondary: kSecondary,
      surface: kSurface,
      background: kBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    scaffoldBackgroundColor: kBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: kSurface,
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimary,
        side: const BorderSide(color: kPrimary),
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kPrimary,
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: const TextStyle(color: kTextMuted, fontSize: 14),
      hintStyle: const TextStyle(color: kTextLight, fontSize: 13),
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: kPrimary,
      unselectedItemColor: Color(0xFF9E9E9E),
      backgroundColor: kSurface,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEF0F4),
      thickness: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? kPrimary
            : const Color(0xFFBDBDBD),
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? kPrimary.withOpacity(0.35)
            : const Color(0xFFE0E0E0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? kPrimary : kTextMuted,
      ),
    ),
    chipTheme: ChipThemeData(
      selectedColor: kPrimary.withOpacity(0.15),
      labelStyle: GoogleFonts.inter(fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

// ── Reusable section header ──────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: kTextMuted,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
        ),
      );
}

// ── Navigation list tile used on the home screen ─────────────────────────────
class NavTile extends StatelessWidget {
  const NavTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(12))
              : BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: kTextMuted,
                            ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFFCBD5E1)),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 70, endIndent: 0),
      ],
    );
  }
}

// ── Labelled info row (replaces button + black TextField pattern) ─────────────
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onRefresh,
  });

  final String label;
  final String value;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: kTextMuted,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value.isEmpty ? '—' : value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: value.isEmpty ? kTextLight : const Color(0xFF1F2937),
                  ),
            ),
          ),
          if (onRefresh != null)
            GestureDetector(
              onTap: onRefresh,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.refresh_rounded, size: 18, color: kTextMuted),
              ),
            ),
        ],
      ),
    );
  }
}
