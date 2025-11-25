import 'package:flutter/material.dart';
import 'module_screens.dart';
import 'judge_game_flow.dart';

enum ModuleStatus { notStarted, completed }

class ModuleInfo {
  final String id;
  final String title;
  final List<String> slideTexts;
  final String questionText;
  ModuleStatus status;

  ModuleInfo({
    required this.id,
    required this.title,
    required this.slideTexts,
    required this.questionText,
    this.status = ModuleStatus.notStarted,
  });

  bool get isCompleted {
    return status == ModuleStatus.completed;
  }
}

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  late List<ModuleInfo> modules;

  @override
  void initState() {
    super.initState();
    modules = [
      // NOTE: you can add as many or as few slides as you want - just change the number of items in the list
      ModuleInfo(
        id: 'cuts',
        title: 'Understanding Cuts',
        slideTexts: [
          'SAMPLE TEXT for cuts module - slide 1.',
          'SAMPLE TEXT for cuts module - slide 2.',
          'SAMPLE TEXT for cuts module - slide 3.',
          'SAMPLE TEXT for cuts module - slide 4.',
        ],
        questionText: 'SAMPLE QUESTION for cuts module.',
      ),
      ModuleInfo(
        id: 'thickness',
        title: 'Thickness',
        slideTexts: [
          'SAMPLE TEXT for thickness module - slide 1.',
          'SAMPLE TEXT for thickness module - slide 2.',
        ],
        questionText: 'SAMPLE QUESTION for thickness module.',
      ),
      ModuleInfo(
        id: 'doneness',
        title: 'Doneness',
        slideTexts: [
          'SAMPLE TEXT for doneness module - slide 1.',
          'SAMPLE TEXT for doneness module - slide 2.',
        ],
        questionText: 'SAMPLE QUESTION for doneness module.',
      ),
      ModuleInfo(
        id: 'cooking',
        title: 'Cooking Method',
        slideTexts: [
          'SAMPLE TEXT for cooking method module - slide 1.',
          'SAMPLE TEXT for cooking method module - slide 2.',
        ],
        questionText: 'SAMPLE QUESTION for cooking method module.',
      ),
    ];
  }

  int get _completedCount {
    int count = 0;
    for (final m in modules) {
      if (m.isCompleted) {
        count++;
      }
    }
    return count;
  }

  Color _buttonColor(ModuleInfo m) {
    if (m.isCompleted) {
      return Colors.brown.shade300; // lighter when done
    }
    return Colors.brown;
  }

  @override
  Widget build(BuildContext context) {
    final total = modules.length;
    final done = _completedCount;
    final allCompleted = done == total && total > 0;

    final cuts = modules[0];
    final thickness = modules[1];
    final doneness = modules[2];
    final cooking = modules[3];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/kitchen.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.35)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7E6).withOpacity(0.97),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.brown.withOpacity(0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Training Modules',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Learn core steak fundamentals here before entering the application.',
                          style: TextStyle(fontSize: 16.5, height: 1.35),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Modules completed: $done / $total',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModuleScreen(
                            title: cuts.title,
                            slideTexts: cuts.slideTexts,
                            questionText: cuts.questionText,
                            onComplete: () {
                              setState(() {
                                cuts.status = ModuleStatus.completed;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _buttonColor(cuts),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(cuts.title),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModuleScreen(
                            title: thickness.title,
                            slideTexts: thickness.slideTexts,
                            questionText: thickness.questionText,
                            onComplete: () {
                              setState(() {
                                thickness.status = ModuleStatus.completed;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _buttonColor(thickness),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(thickness.title),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModuleScreen(
                            title: doneness.title,
                            slideTexts: doneness.slideTexts,
                            questionText: doneness.questionText,
                            onComplete: () {
                              setState(() {
                                doneness.status = ModuleStatus.completed;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _buttonColor(doneness),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(doneness.title),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModuleScreen(
                            title: cooking.title,
                            slideTexts: cooking.slideTexts,
                            questionText: cooking.questionText,
                            onComplete: () {
                              setState(() {
                                cooking.status = ModuleStatus.completed;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _buttonColor(cooking),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(cooking.title),
                  ),
                  const SizedBox(height: 16),
                  //if (allCompleted) // commented out for testing
                  FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/judge_brief',
                        arguments:
                            GameState(), // i passed the game state as an argument here but we need to fix the state managemtent for sure
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 81, 57, 48),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continue to app'),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
