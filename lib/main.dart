import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bmfbophytctnbtozomka.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJtZmJvcGh5dGN0bmJ0b3pvbWthIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIzMjExNTIsImV4cCI6MjA4Nzg5NzE1Mn0.C3rik1xrBtnIUQwqLH_R4EkV7eBauIF19-_7gUiKDGw',
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Luxi Home'),
      routes: {
        '/home': (context) => const MyHomePage(title: 'Luxi Home'),
        '/auth': (context) => const AuthPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;

  Future<void> _goToSuggestPage() async {
    setState(() {
      _isLoading = true;
    });
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SuggestPage()),
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Luxi",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
ElevatedButton(
  onPressed: _isLoading ? null : _goToSuggestPage,
  child: _isLoading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : const Text('Get Project Suggestions'),
),
          ],
        ),
      ),
    );
  }
}

// -------------------- Suggest Page --------------------


class Project {
  final String title;
  final String description;

  Project({required this.title, required this.description});
}

class SectionLine {
  final String text;
  final bool isBullet;
  final bool isNumbered;
  final bool isCheckbox;

  SectionLine(this.text, {this.isBullet = false, this.isNumbered = false, this.isCheckbox = false});
}

class SuggestPage extends StatefulWidget {
  const SuggestPage({super.key});

  @override
  State<SuggestPage> createState() => _SuggestPageState();
}

class _SuggestPageState extends State<SuggestPage> {
  final List<String> fixedCourses = ["ENGR2350", "ECSE2610", "ECSE2500"];
  final List<Project> savedProjects = [];
  bool _isLoading = true;

  final List<Color> cardColors = [
    Colors.deepPurple.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.pink.shade100,
  ];

  @override
  void initState() {
    super.initState();
    _getSuggestion(); // auto-run when page opens
  }

  Future<void> _getSuggestion() async {
    String aiResponse = '';
    try {
      aiResponse = await askAI(
          "Suggest a project based on these courses: ${fixedCourses.join(', ')}. "
          "Output clearly with these sections: Materials, Instructions, Learning Outcomes. "
          "Format exactly like this:\n\n"
          "Materials:\n"
          "- item 1\n"
          "- item 2\n\n"
          "Instructions:\n"
          "1. Step 1 description\n"
          "   ☐ optional checkbox or sub-step explanation\n"
          "2. Step 2 description\n"
          "   ☐ optional checkbox\n\n"
          "Learning Outcomes:\n"
          "- Outcome 1\n"
          "- Outcome 2\n\n"
          "Keep text plain, no ** or weird symbols. Each numbered step in Instructions should teach exactly one task and explain how to do it. "
          "Learning Outcomes should summarize what the user learns about the courses and how they interact. "
          "Make it simple and clear, suitable for beginners."
      );
    } catch (e) {
      aiResponse = "Error generating suggestion: $e";
    }

    setState(() {
      savedProjects.add(Project(title: "Project Idea", description: aiResponse));
      _isLoading = false;
    });
  }

Map<String, List<SectionLine>> parseAIResponse(String text) {
  final sections = <String, List<SectionLine>>{};
  String currentSection = '';
  final lines = text.split('\n');

  for (var line in lines) {
    line = line.trim();
    if (line.isEmpty) continue;

    // Detect section headers
    if (RegExp(r'^(Materials|Instructions|Learning Outcomes):$', caseSensitive: false)
        .hasMatch(line)) {
      currentSection = line.replaceAll(':', '');
      sections[currentSection] = [];
      continue;
    }

    if (currentSection.isEmpty) continue;

    bool isBullet = line.startsWith('- ');
    bool isNumbered = RegExp(r'^\d+\. ').hasMatch(line);
    bool isCheckbox = line.startsWith('[ ]') || line.startsWith('[x]');

    sections[currentSection]?.add(SectionLine(
      line,
      isBullet: isBullet,
      isNumbered: isNumbered,
      isCheckbox: isCheckbox,
    ));
  }

  return sections;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Suggestions')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: savedProjects.length,
                itemBuilder: (context, index) {
                  final project = savedProjects[index];
                  final parsed = parseAIResponse(project.description);
                  final color = cardColors[index % cardColors.length];

                  return Card(
                    color: color,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(project.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...parsed.entries.expand((entry) {
  return [
    SelectableText(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
    const SizedBox(height: 4),
    ...entry.value.map((line) {
      String displayText = line.text;
      if (line.isCheckbox) displayText = "☐ ${line.text.replaceAll('[ ]', '').trim()}";
      if (line.isBullet) displayText = "• ${line.text.replaceFirst('- ', '')}";
      return Padding(
        padding: EdgeInsets.only(left: line.isNumbered ? 16 : 0),
        child: SelectableText(
          displayText,
          style: const TextStyle(height: 1.5),
        ),
      );
    }),
    const SizedBox(height: 8),
  ];
}).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
// -------------------- Auth Page --------------------
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'AuthPage Placeholder',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}