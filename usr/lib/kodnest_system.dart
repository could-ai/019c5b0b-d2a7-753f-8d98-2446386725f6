import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// KODNEST DESIGN TOKENS
// -----------------------------------------------------------------------------

class KodNestColors {
  static const Color background = Color(0xFFF7F6F3); // Off-white
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF555555);
  static const Color accent = Color(0xFF8B0000); // Deep Red
  static const Color success = Color(0xFF4B7F52); // Muted Green
  static const Color warning = Color(0xFFD97706); // Muted Amber
  static const Color border = Color(0xFFE0E0E0);
  static const Color inputBorder = Color(0xFFCCCCCC);
}

class KodNestSpacing {
  static const double xs = 8.0;
  static const double s = 16.0;
  static const double m = 24.0;
  static const double l = 40.0;
  static const double xl = 64.0;
}

class KodNestTypography {
  static const String serifFont = 'Georgia'; // Fallback to system serif
  static const String sansFont = 'Roboto'; // Fallback to system sans

  static const TextStyle heading1 = TextStyle(
    fontFamily: serifFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: KodNestColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: serifFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: KodNestColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: sansFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: KodNestColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: sansFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: KodNestColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontFamily: sansFont,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}

// -----------------------------------------------------------------------------
// KODNEST COMPONENTS
// -----------------------------------------------------------------------------

class KodNestButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSecondary;
  final IconData? icon;

  const KodNestButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isSecondary ? Colors.transparent : KodNestColors.accent;
    final Color fgColor = isSecondary ? KodNestColors.textPrimary : Colors.white;
    final Color borderColor = isSecondary ? KodNestColors.textPrimary : KodNestColors.accent;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: KodNestSpacing.m,
          vertical: KodNestSpacing.s,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: fgColor),
              const SizedBox(width: KodNestSpacing.xs),
            ],
            Text(
              label,
              style: KodNestTypography.button.copyWith(color: fgColor),
            ),
          ],
        ),
      ),
    );
  }
}

class KodNestCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const KodNestCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(KodNestSpacing.m),
      decoration: BoxDecoration(
        color: KodNestColors.surface,
        border: Border.all(color: KodNestColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}

class KodNestInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final int maxLines;

  const KodNestInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: KodNestTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: KodNestSpacing.xs),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: KodNestTypography.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: KodNestTypography.body.copyWith(color: Colors.grey),
            filled: true,
            fillColor: KodNestColors.surface,
            contentPadding: const EdgeInsets.all(KodNestSpacing.s),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: KodNestColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: KodNestColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: KodNestColors.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class KodNestBadge extends StatelessWidget {
  final String status;

  const KodNestBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'shipped':
        bgColor = KodNestColors.success.withOpacity(0.1);
        textColor = KodNestColors.success;
        break;
      case 'in progress':
        bgColor = KodNestColors.warning.withOpacity(0.1);
        textColor = KodNestColors.warning;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = KodNestColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// KODNEST LAYOUT STRUCTURE
// -----------------------------------------------------------------------------

class KodNestScaffold extends StatelessWidget {
  final String projectName;
  final String stepProgress;
  final String status;
  final String title;
  final String subtext;
  final Widget body;
  final Widget panel;
  final Widget footer;

  const KodNestScaffold({
    super.key,
    required this.projectName,
    required this.stepProgress,
    required this.status,
    required this.title,
    required this.subtext,
    required this.body,
    required this.panel,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KodNestColors.background,
      body: Column(
        children: [
          // TOP BAR
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: KodNestSpacing.m),
            decoration: const BoxDecoration(
              color: KodNestColors.surface,
              border: Border(bottom: BorderSide(color: KodNestColors.border)),
            ),
            child: Row(
              children: [
                Text(
                  projectName,
                  style: KodNestTypography.body.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  stepProgress,
                  style: KodNestTypography.bodySmall,
                ),
                const Spacer(),
                KodNestBadge(status: status),
              ],
            ),
          ),

          // SCROLLABLE CONTENT AREA
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CONTEXT HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: KodNestSpacing.l,
                      vertical: KodNestSpacing.l,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: KodNestTypography.heading1),
                        const SizedBox(height: KodNestSpacing.xs),
                        Text(subtext, style: KodNestTypography.body.copyWith(color: KodNestColors.textSecondary)),
                      ],
                    ),
                  ),

                  // MAIN WORKSPACE + PANEL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: KodNestSpacing.l),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive check: if width < 900, stack them
                        if (constraints.maxWidth < 900) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              body,
                              const SizedBox(height: KodNestSpacing.l),
                              panel,
                              const SizedBox(height: KodNestSpacing.xl),
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: body),
                            const SizedBox(width: KodNestSpacing.l),
                            Expanded(flex: 3, child: panel),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100), // Space for footer
                ],
              ),
            ),
          ),

          // PROOF FOOTER
          Container(
            padding: const EdgeInsets.all(KodNestSpacing.m),
            decoration: const BoxDecoration(
              color: KodNestColors.surface,
              border: Border(top: BorderSide(color: KodNestColors.border)),
            ),
            child: footer,
          ),
        ],
      ),
    );
  }
}
