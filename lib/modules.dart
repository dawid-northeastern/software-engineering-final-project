import 'package:flutter/material.dart';
import 'module_screens.dart';

enum ModuleStatus { notStarted, completed }

class ModuleInfo {
  final String id;
  final String title;
  final String slide1Text;
  final String slide2Text;
  final String questionText;
  ModuleStatus status;

  ModuleInfo({
    required this.id,
    required this.title,
    required this.slide1Text,
    required this.slide2Text,
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
      ModuleInfo(
        id: 'cuts',
        title: 'Understanding Cuts',
        slide1Text: 'SAMPLE TEXT for cuts module - slide 1.',
        slide2Text: 'SAMPLE TEXT for cuts module - slide 2.',
        questionText: 'SAMPLE QUESTION for cuts module.',
      ),
      ModuleInfo(
        id: 'thickness',
        title: 'Thickness',
        slide1Text: 'SAMPLE TEXT for thickness module - slide 1.',
        slide2Text: 'SAMPLE TEXT for thickness module - slide 2.',
        questionText: 'SAMPLE QUESTION for thickness module.',
      ),
      ModuleInfo(
        id: 'doneness',
        title: 'Doneness',
        slide1Text: 'SAMPLE TEXT for doneness module - slide 1.',
        slide2Text: 'SAMPLE TEXT for doneness module - slide 2.',
        questionText: 'SAMPLE QUESTION for doneness module.',
      ),
      ModuleInfo(
        id: 'cooking',
        title: 'Cooking Method',
        slide1Text: 'SAMPLE TEXT for cooking method module - slide 1.',
        slide2Text: 'SAMPLE TEXT for cooking method module - slide 2.',
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
                            slide1Text: cuts.slide1Text,
                            slide2Text: cuts.slide2Text,
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
                            slide1Text: thickness.slide1Text,
                            slide2Text: thickness.slide2Text,
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
                            slide1Text: doneness.slide1Text,
                            slide2Text: doneness.slide2Text,
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
                            slide1Text: cooking.slide1Text,
                            slide2Text: cooking.slide2Text,
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
                  if (allCompleted)
                    FilledButton(
                      onPressed: () {
                        // TODO: Add logic to continue to app
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
