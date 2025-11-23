import 'package:flutter/material.dart';
import 'module_screens.dart';

enum ModuleStatus { notStarted, inProgress, completed }

class Module {
  final String id;
  final String title;
  ModuleStatus status;

  Module({
    required this.id,
    required this.title,
    this.status = ModuleStatus.notStarted,
  });

  bool get isCompleted {
    return status == ModuleStatus.completed;
  }

  void markInProgress() {
    status = ModuleStatus.inProgress;
  }

  void markCompleted() {
    status = ModuleStatus.completed;
  }
}

class Cuts extends Module {
  Cuts() : super(id: 'cuts', title: 'Understanding Cuts');
}

class Thickness extends Module {
  Thickness() : super(id: 'thickness', title: 'Thickness');
}

class Doneness extends Module {
  Doneness() : super(id: 'doneness', title: 'Doneness');
}

class Cooking extends Module {
  Cooking() : super(id: 'cooking', title: 'Cooking Method');
}

class Progress {
  final List<Module> modules;

  Progress({required this.modules});

  int get totalCount {
    return modules.length;
  }

  int get completedCount {
    int count = 0;
    for (final m in modules) {
      if (m.isCompleted) {
        count++;
      }
    }
    return count;
  }

  bool get allCompleted {
    return completedCount == totalCount && totalCount > 0;
  }
}

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = Progress(
      modules: [Cuts(), Thickness(), Doneness(), Cooking()],
    );

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
                          'Modules completed: ${progress.completedCount} / ${progress.totalCount}',
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
                        MaterialPageRoute(builder: (_) => const CutsScreen()),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Understanding Cuts'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ThicknessScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Thickness'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DonenessScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Doneness'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CookingScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cooking Method'),
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
