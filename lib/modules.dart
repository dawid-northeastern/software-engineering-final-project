import 'package:flutter/material.dart';

enum ModuleStatus { notStarted, inProgress, completed }

class TrainingModule {
  final String id;
  final String title;
  ModuleStatus status;

  TrainingModule({
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

class CutsModule extends TrainingModule {
  CutsModule() : super(id: 'cuts', title: 'Understanding Cuts');
}

class ThicknessModule extends TrainingModule {
  ThicknessModule() : super(id: 'thickness', title: 'Thickness');
}

class DonenessModule extends TrainingModule {
  DonenessModule() : super(id: 'doneness', title: 'Doneness');
}

class TrainingProgress {
  final List<TrainingModule> modules;

  TrainingProgress({required this.modules});

  int get totalCount {
    return modules.length;
  }

  int get completedCount {
    int count = 0;
    for (final module in modules) {
      if (module.isCompleted) {
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
    final progress = TrainingProgress(
      modules: [CutsModule(), ThicknessModule(), DonenessModule()],
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
