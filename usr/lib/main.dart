import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const JobTrackerApp());
}

class JobTrackerApp extends StatelessWidget {
  const JobTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Notification Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A), // Slate-900 like
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF3B82F6), // Blue-500
          surface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate-50
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE2E8F0)), // Slate-200
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/jt/proof': (context) => const ProofPage(),
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/jt/proof'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Go to Job Tracker Proof'),
        ),
      ),
    );
  }
}

class ProofPage extends StatefulWidget {
  const ProofPage({super.key});

  @override
  State<ProofPage> createState() => _ProofPageState();
}

class _ProofPageState extends State<ProofPage> {
  // Controllers
  final TextEditingController _lovableController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _deployedController = TextEditingController();

  // State
  bool _isLoading = true;
  String? _successMessage;

  // Mock Data - Steps (8 items)
  final List<Map<String, dynamic>> _steps = [
    {'title': 'Project Setup', 'completed': true},
    {'title': 'Database Schema', 'completed': true},
    {'title': 'Authentication', 'completed': true},
    {'title': 'Job Matching Logic', 'completed': true},
    {'title': 'Notification System', 'completed': true},
    {'title': 'UI Implementation', 'completed': true},
    {'title': 'State Management', 'completed': true},
    {'title': 'Testing & QA', 'completed': true}, // Initially true for demo
  ];

  // Mock Data - Checklist (10 items)
  // In a real app, these would come from a testing suite.
  // We make them toggleable here to demonstrate the "Shipped" logic.
  final List<Map<String, dynamic>> _checklist = [
    {'title': 'Unit Tests Passed', 'passed': false},
    {'title': 'Integration Tests Passed', 'passed': false},
    {'title': 'UI Responsive Check', 'passed': false},
    {'title': 'Dark Mode Verified', 'passed': false},
    {'title': 'Accessibility Audit', 'passed': false},
    {'title': 'Performance Profiling', 'passed': false},
    {'title': 'Security Audit', 'passed': false},
    {'title': 'API Error Handling', 'passed': false},
    {'title': 'Data Persistence Check', 'passed': false},
    {'title': 'Clean Code Review', 'passed': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lovableController.text = prefs.getString('jt_lovable_link') ?? '';
      _githubController.text = prefs.getString('jt_github_link') ?? '';
      _deployedController.text = prefs.getString('jt_deployed_link') ?? '';
      
      // Load checklist state if saved, otherwise default to false
      for (int i = 0; i < _checklist.length; i++) {
        _checklist[i]['passed'] = prefs.getBool('jt_check_$i') ?? false;
      }
      
      _isLoading = false;
    });
  }

  Future<void> _saveLink(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    setState(() {}); // Trigger rebuild to update status
  }

  Future<void> _toggleChecklist(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _checklist[index]['passed'] = !(_checklist[index]['passed'] as bool);
    });
    await prefs.setBool('jt_check_$index', _checklist[index]['passed']);
  }

  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https')) && uri.hasAbsolutePath;
  }

  bool get _allLinksValid {
    return _isValidUrl(_lovableController.text) &&
           _isValidUrl(_githubController.text) &&
           _isValidUrl(_deployedController.text);
  }

  bool get _allChecklistPassed {
    return _checklist.every((item) => item['passed'] == true);
  }

  String get _status {
    if (_allLinksValid && _allChecklistPassed) return 'Shipped';
    if (_lovableController.text.isNotEmpty || _githubController.text.isNotEmpty) return 'In Progress';
    return 'Not Started';
  }

  Color get _statusColor {
    switch (_status) {
      case 'Shipped': return const Color(0xFF10B981); // Emerald-500
      case 'In Progress': return const Color(0xFFF59E0B); // Amber-500
      default: return const Color(0xFF64748B); // Slate-500
    }
  }

  void _copyFinalSubmission() {
    final text = '''
------------------------------------------
Job Notification Tracker — Final Submission

Lovable Project:
${_lovableController.text}

GitHub Repository:
${_githubController.text}

Live Deployment:
${_deployedController.text}

Core Features:
- Intelligent match scoring
- Daily digest simulation
- Status tracking
- Test checklist enforced
------------------------------------------
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Final Submission copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isShipped = _status == 'Shipped';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project 1 — Job Notification Tracker'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              label: Text(
                _status,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: _statusColor,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Message
            if (isShipped)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5), // Emerald-50
                  border: Border.all(color: const Color(0xFF10B981)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Project 1 Shipped Successfully.",
                  style: TextStyle(
                    color: Color(0xFF065F46), // Emerald-800
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Section A: Step Completion Summary
            _buildSectionHeader('Step Completion Summary'),
            Card(
              margin: const EdgeInsets.only(bottom: 32),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _steps.map((step) => _buildStepItem(step)).toList(),
                ),
              ),
            ),

            // Section B: Artifact Collection Inputs
            _buildSectionHeader('Artifact Collection'),
            Card(
              margin: const EdgeInsets.only(bottom: 32),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUrlInput(
                      label: 'Lovable Project Link',
                      controller: _lovableController,
                      prefKey: 'jt_lovable_link',
                      hint: 'https://lovable.dev/...',
                    ),
                    const SizedBox(height: 20),
                    _buildUrlInput(
                      label: 'GitHub Repository Link',
                      controller: _githubController,
                      prefKey: 'jt_github_link',
                      hint: 'https://github.com/...',
                    ),
                    const SizedBox(height: 20),
                    _buildUrlInput(
                      label: 'Deployed URL',
                      controller: _deployedController,
                      prefKey: 'jt_deployed_link',
                      hint: 'https://vercel.com/...',
                    ),
                  ],
                ),
              ),
            ),

            // Checklist Section (Enforced)
            _buildSectionHeader('Test Checklist (10/10 Required)'),
            Card(
              margin: const EdgeInsets.only(bottom: 32),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _checklist.length,
                separatorBuilder: (c, i) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _checklist[index];
                  return CheckboxListTile(
                    value: item['passed'],
                    onChanged: (val) => _toggleChecklist(index),
                    title: Text(item['title']),
                    secondary: Icon(
                      item['passed'] ? Icons.check_circle : Icons.circle_outlined,
                      color: item['passed'] ? const Color(0xFF10B981) : Colors.grey,
                    ),
                    activeColor: const Color(0xFF0F172A),
                  );
                },
              ),
            ),

            // Final Submission Export
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _copyFinalSubmission,
                icon: const Icon(Icons.copy),
                label: const Text(
                  'Copy Final Submission',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildStepItem(Map<String, dynamic> step) {
    final isCompleted = step['completed'] as bool;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF10B981) : Colors.transparent,
              border: Border.all(
                color: isCompleted ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            step['title'],
            style: TextStyle(
              fontSize: 15,
              color: isCompleted ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              fontWeight: isCompleted ? FontWeight.w500 : FontWeight.normal,
              decoration: isCompleted ? null : TextDecoration.none,
            ),
          ),
          const Spacer(),
          Text(
            isCompleted ? 'Completed' : 'Pending',
            style: TextStyle(
              fontSize: 12,
              color: isCompleted ? const Color(0xFF10B981) : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlInput({
    required String label,
    required TextEditingController controller,
    required String prefKey,
    required String hint,
  }) {
    final isValid = _isValidUrl(controller.text);
    final isEmpty = controller.text.isEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: (val) => _saveLink(prefKey, val),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            suffixIcon: !isEmpty
                ? Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  )
                : null,
          ),
          keyboardType: TextInputType.url,
        ),
        if (!isEmpty && !isValid)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4),
            child: Text(
              'Please enter a valid URL starting with http:// or https://',
              style: TextStyle(color: Colors.red[400], fontSize: 12),
            ),
          ),
      ],
    );
  }
}
