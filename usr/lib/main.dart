import 'package:flutter/material.dart';
import 'kodnest_system.dart';

void main() {
  runApp(const KodNestApp());
}

class KodNestApp extends StatelessWidget {
  const KodNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KodNest Premium Build System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: KodNestColors.background,
        primaryColor: KodNestColors.accent,
        fontFamily: KodNestTypography.sansFont,
        colorScheme: ColorScheme.fromSeed(
          seedColor: KodNestColors.accent,
          surface: KodNestColors.surface,
        ),
        useMaterial3: true,
      ),
      home: const DesignSystemDemoPage(),
    );
  }
}

class DesignSystemDemoPage extends StatefulWidget {
  const DesignSystemDemoPage({super.key});

  @override
  State<DesignSystemDemoPage> createState() => _DesignSystemDemoPageState();
}

class _DesignSystemDemoPageState extends State<DesignSystemDemoPage> {
  // Proof Footer State
  bool _uiBuilt = false;
  bool _logicWorking = false;
  bool _testPassed = false;
  bool _deployed = false;

  @override
  Widget build(BuildContext context) {
    return KodNestScaffold(
      projectName: 'KodNest Premium Build System',
      stepProgress: 'Step 1 / 5',
      status: 'In Progress',
      title: 'Define the Foundation',
      subtext: 'Establish the core design tokens, typography, and layout structure for the system.',
      
      // PRIMARY WORKSPACE (70%)
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KodNestCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Design Philosophy', style: KodNestTypography.heading2),
                SizedBox(height: KodNestSpacing.s),
                Text(
                  'The system prioritizes clarity and intent over decoration. Every element exists for a reason. '
                  'Whitespace is used actively to group related information and separate distinct contexts.',
                  style: KodNestTypography.body,
                ),
              ],
            ),
          ),
          const SizedBox(height: KodNestSpacing.m),
          KodNestCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Component Gallery', style: KodNestTypography.heading2),
                const SizedBox(height: KodNestSpacing.m),
                Wrap(
                  spacing: KodNestSpacing.s,
                  runSpacing: KodNestSpacing.s,
                  children: [
                    KodNestButton(
                      label: 'Primary Action',
                      onPressed: () {},
                    ),
                    KodNestButton(
                      label: 'Secondary Action',
                      isSecondary: true,
                      onPressed: () {},
                    ),
                    KodNestButton(
                      label: 'With Icon',
                      icon: Icons.check,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: KodNestSpacing.m),
                const KodNestInput(
                  label: 'Project Name',
                  hint: 'e.g. KodNest SaaS Platform',
                ),
              ],
            ),
          ),
        ],
      ),

      // SECONDARY PANEL (30%)
      panel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Instructions', style: KodNestTypography.heading2),
          const SizedBox(height: KodNestSpacing.s),
          const Text(
            'Review the design tokens and ensure they match the specifications. '
            'Test the responsive layout by resizing the window.',
            style: KodNestTypography.body,
          ),
          const SizedBox(height: KodNestSpacing.m),
          Container(
            padding: const EdgeInsets.all(KodNestSpacing.s),
            decoration: BoxDecoration(
              color: KodNestColors.surface,
              border: Border.all(color: KodNestColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PROMPT:\nVerify that the accent color is #8B0000 and the background is #F7F6F3.',
              style: TextStyle(fontFamily: 'Courier', fontSize: 13),
            ),
          ),
          const SizedBox(height: KodNestSpacing.m),
          SizedBox(
            width: double.infinity,
            child: KodNestButton(
              label: 'Copy Prompt',
              isSecondary: true,
              icon: Icons.copy,
              onPressed: () {},
            ),
          ),
        ],
      ),

      // PROOF FOOTER
      footer: Row(
        children: [
          const Text('Validation:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: KodNestSpacing.m),
          _buildCheckbox('UI Built', _uiBuilt, (v) => setState(() => _uiBuilt = v!)),
          const SizedBox(width: KodNestSpacing.s),
          _buildCheckbox('Logic Working', _logicWorking, (v) => setState(() => _logicWorking = v!)),
          const SizedBox(width: KodNestSpacing.s),
          _buildCheckbox('Test Passed', _testPassed, (v) => setState(() => _testPassed = v!)),
          const SizedBox(width: KodNestSpacing.s),
          _buildCheckbox('Deployed', _deployed, (v) => setState(() => _deployed = v!)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: KodNestColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        Text(label, style: KodNestTypography.bodySmall),
      ],
    );
  }
}
