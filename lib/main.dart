import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/ai_service.dart';
import 'dart:async';
import 'dart:math';

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
  debugShowCheckedModeBanner: false,
  title: 'Luxi Home',
  theme: ThemeData.dark().copyWith(
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.dark().textTheme,
    ),
  ),
  home: const MyHomePage(title: 'Luxi Home'),
);
  }
}

// ... (keep the imports, MyApp, Project, SectionLine, AuthPage the same)

final List<Orb> orbs = List.generate(23, (_) => Orb());

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _orbController;
  bool _isLoading = false; // still useful to disable button

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(() {
        setState(() {
          for (var orb in orbs) {
            orb.move();
          }
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _orbController.dispose();
    super.dispose();
  }

  Future<void> _goToSuggestPage() async {
    setState(() {
      _isLoading = true;
      for (var orb in orbs) {
        orb.mode = BubbleMode.falling;
      }
    });

    // Let orbs fall and settle
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    setState(() {
      for (var orb in orbs) {
        if (orb.mode == BubbleMode.waiting) {
          orb.mode = BubbleMode.rising;
        }
      }
    });

    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SuggestPage()));

    if (mounted) {
      setState(() {
        for (var orb in orbs) {
          orb.mode = BubbleMode.idle;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black),
          ...orbs.map((orb) => Positioned(
                left: orb.x,
                top: orb.y,
                child: Container(
                  width: orb.size,
                  height: orb.size,
                  decoration: BoxDecoration(
                    color: orb.color.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: orb.color.withValues(alpha: 0.6),
                        blurRadius: 12,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                ),
              )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Luxi",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5A2EFF), Color.fromARGB(255, 128, 96, 255)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _goToSuggestPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                    ),
                    child: const Text(
                      "START PROJECT",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Orb class and BubbleMode stay exactly the same as before
enum BubbleMode { idle, falling, waiting, rising }

class SectionLine {
  final String text;
  final bool isBullet;
  final bool isNumbered;
  final bool isCheckbox;

  SectionLine(this.text, {this.isBullet = false, this.isNumbered = false, this.isCheckbox = false});
}

class Orb {
  // ... (keep your Orb class unchanged)
  double x = Random().nextDouble() * 400;
  double y = Random().nextDouble() * 800;
  double dx = Random().nextDouble() * 2.2 - 1.1;
  double dy = Random().nextDouble() * 2 - 1;
  double size = 25 + Random().nextDouble() * 65;
  int layer = Random().nextInt(3);
  late Color color;
  BubbleMode mode = BubbleMode.idle;
  DateTime? waitStartTime;

  Orb() {
    color = Colors.white.withValues(alpha: 0.55);
  }

 void move() {
    switch (mode) {
      case BubbleMode.idle:
        x += dx;
        y += dy;
        if (x < 0 || x > 400) dx = -dx;
        if (y < 0 || y > 800) dy = -dy;
        break;

      case BubbleMode.falling:
        y += 4.8 + 1.8 * sin(y / 35);
        x += dx * 0.65;
        if (y > 800 - size - 15) {
          y = 800 - size - 15;
          mode = BubbleMode.waiting;
          waitStartTime = DateTime.now();
        }
        break;

      case BubbleMode.waiting:
        if (waitStartTime != null && 
            DateTime.now().difference(waitStartTime!).inMilliseconds > 1200) {  // ← Increased to 1.2 seconds
          mode = BubbleMode.rising;
        }
        break;

      case BubbleMode.rising:
        y -= 4.8 + 2.0 * sin(y / 50);
        x += dx * 0.5;
        if (y < -size - 40) mode = BubbleMode.idle;
        break;
    }
  }
}

class Project {
  final String title;
  final String description;
  Project({required this.title, required this.description});
}

class SuggestPage extends StatefulWidget {
  const SuggestPage({super.key});

  @override
  State<SuggestPage> createState() => _SuggestPageState();
}

class _SuggestPageState extends State<SuggestPage> with SingleTickerProviderStateMixin {
  final List<String> fixedCourses = ["ENGR2350", "ECSE2610", "ECSE2500"];
  final List<Project> savedProjects = [];
  
  bool _isLoading = true;
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;

  late Timer _orbTimer;

  @override
  void initState() {
    super.initState();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),   // Longer to sync with rising orbs
    );
    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOutCubic),
    );

    _orbTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (mounted) setState(() => orbs.forEach((o) => o.move()));
    });

    _getSuggestion();
  }

  @override
  void dispose() {
    _revealController.dispose();
    _orbTimer.cancel();
    super.dispose();
  }

  Map<String, List<SectionLine>> parseAIResponse(String text) {
    final sections = <String, List<SectionLine>>{};
    String currentSection = '';
    final lines = text.split('\n');

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (RegExp(r'^(Materials|Instructions|Learning Outcomes)', caseSensitive: false).hasMatch(line)) {
        currentSection = line.replaceAll(':', '').trim();
        sections[currentSection] = [];
        continue;
      }

      if (currentSection.isEmpty) continue;

      bool isBullet = line.startsWith('- ');
      bool isNumbered = RegExp(r'^\d+\.').hasMatch(line);
      bool isCheckbox = line.startsWith('[ ]') || line.startsWith('[x]');

      sections[currentSection]!.add(
        SectionLine(
          line,
          isBullet: isBullet,
          isNumbered: isNumbered,
          isCheckbox: isCheckbox,
        ),
      );
    }
    return sections;
  }

Future<void> _getSuggestion() async {
  String aiResponse = 'Loading...';  // temporary placeholder

  try {
    print("=== Starting AI call ===");  // debug log

aiResponse = await askAI(
  "Suggest a beginner-friendly project based on these courses: ${fixedCourses.join(', ')}.\n\n"

  "Write a FULL step-by-step tutorial for a COMPLETE beginner.\n"
  "The tutorial must be EXTREMELY detailed and impossible to misunderstand.\n\n"

  "FORMAT:\n\n"

  "Title:\n"
  "Short project name\n\n"

  "Overview:\n"
  "2-3 sentences explaining what the project does\n\n"

  "Materials:\n"
  "- exact components with values\n\n"

  "Steps:\n\n"

  "CRITICAL RULES FOR STEPS:\n"
  "- Each step must contain ONLY ONE action\n"
  "- If a step contains multiple actions, split it into multiple steps\n"
  "- Do NOT summarize\n"
  "- Do NOT skip physical actions\n"
  "- Do NOT assume prior knowledge\n\n"

  "FOR EACH STEP USE THIS FORMAT:\n\n"

  "Step X: [Very specific action]\n"
  "Goal: What this step achieves\n\n"

  "Instructions:\n"
  "- Describe EXACTLY what to click, type, or connect\n"
  "- Include exact pin numbers, menu names, and values\n"
  "- Write as if the user has never used this tool before\n\n"

  "Why this matters:\n"
  "- Explain simply\n\n"

  "Common mistake:\n"
  "- One realistic beginner mistake\n\n"

  "MANDATORY EXPANSION RULE:\n"
  "If any instruction could be considered vague (examples: 'open IDE', 'write code', 'connect sensor'), you MUST expand it into multiple detailed steps.\n\n"

  "EXAMPLE OF REQUIRED DETAIL:\n"
  "Instead of: 'Open Arduino IDE'\n"
  "Write:\n"
  "- Click the Start menu\n"
  "- Type 'Arduino IDE'\n"
  "- Click the application\n\n"

  "Code:\n"
  "- Introduce code step-by-step\n"
  "- Explain EVERY line in plain language\n"
  "- Do NOT dump full code without explanation\n\n"

  "Learning Outcomes:\n"
  "- What the user learned\n\n"

  "FINAL RULE:\n"
  "Assume the user will fail if you are not specific enough. Prevent that.\n"
, fixedCourses
);

    print("AI call succeeded. Response length: ${aiResponse.length}");
    
  } catch (e, stack) {
    print("=== AI ERROR CAUGHT ===");
    print("Error: $e");
    print("Stack trace: $stack");
    aiResponse = "Error generating suggestion:\n\n$e";
  }
  print(aiResponse);

  // Small delay for orbs
  await Future.delayed(const Duration(milliseconds: 400));

  if (mounted) {
    setState(() {
      savedProjects.clear();
      savedProjects.add(Project(title: "Project Idea", description: aiResponse));
      _isLoading = false;
    });

    _revealController.forward();
  }
}
  @override
  Widget build(BuildContext context) {
    final sortedOrbs = [...orbs]..sort((a, b) => a.layer.compareTo(b.layer));

    return Scaffold(
      appBar: AppBar(title: const Text('Project Suggestions')),
      body: Stack(
        children: [
          if (!_isLoading)
            FadeTransition(
              opacity: _revealAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.25),   // stronger initial offset so it feels more "floating up"
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: _revealController, curve: Curves.easeOutCubic)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: savedProjects.length,
                    itemBuilder: (context, index) {
                      final project = savedProjects[index];
                      final parsed = parseAIResponse(project.description);

                      return Card(
                        color: Colors.deepPurple.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(project.title,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              ...parsed.entries.expand((entry) => [
                                    SelectableText(entry.key,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                    const SizedBox(height: 8),
                                    ...entry.value.map((line) {
                                      String displayText = line.text;

                                      if (line.isCheckbox) {
                                        displayText = "☐ ${line.text.replaceAll('[ ]', '').trim()}";
                                      } else if (line.isBullet) {
                                        displayText = "• ${line.text.replaceFirst('- ', '')}";
                                      }

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: line.isNumbered ? 20 : 0,
                                          bottom: 8,
                                        ),
                                        child: SelectableText(displayText,
                                            style: const TextStyle(height: 1.65)),
                                      );
                                    }),
                                    const SizedBox(height: 10),
                                  ]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          // Orbs always on top
          ...sortedOrbs.map((orb) => Positioned(
                left: orb.x.clamp(-50, 450),
                top: orb.y.clamp(-100, 900),
                child: Container(
                  width: orb.size,
                  height: orb.size,
                  decoration: BoxDecoration(
                    color: orb.color.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: orb.color.withValues(alpha: 0.65), blurRadius: 18, spreadRadius: 6)
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}