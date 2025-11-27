import 'package:flutter/material.dart';
import 'module_screens.dart';
import 'judge_game_flow.dart';

enum ModuleStatus { notStarted, completed }

class ModuleInfo {
  final String id;
  final String title;
  final List<String> slideTexts;
  final List<String>? slideImages;
  final String questionText;
  ModuleStatus status;

  ModuleInfo({
    required this.id,
    required this.title,
    required this.slideTexts,
    required this.questionText,
    this.slideImages,
    this.status = ModuleStatus.notStarted,
  });

  bool get isCompleted => status == ModuleStatus.completed;
}


class ModulesScreen extends StatefulWidget {
  final VoidCallback? onCompleteAll;

  const ModulesScreen({super.key, this.onCompleteAll});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  late List<ModuleInfo> modules;

  @override
  void initState() {
    super.initState();
    modules = [
      // CUTS MODULE
      ModuleInfo(
        id: 'cuts',
        title: 'Steak Cuts: The Basics',
        slideTexts: [
          'Overview\n\nIn this module you’ll learn the four core steaks used in the exam: '
              'Fillet, Ribeye, Sirloin and Rump. Focus on how tenderness, fat and flavour differ – '
              'that’s what will drive your choices with each judge.',
          'Fillet (Tenderloin)\n\n• Most tender cut\n• Very fine grain, almost no fat\n'
              '• Delicate, mild flavour\n• Great for premium dishes; often cooked from rare to medium.',
          'Ribeye\n\n• Cut from the rib with visible marbling\n'
              '• Fat melts and bastes the meat – big, beefy flavour\n'
              '• Not as tender as fillet but very juicy when cooked to medium / medium-rare\n'
              '• Needs a strong sear to render the fat properly.',
          'Sirloin\n\n• From the striploin, moderately worked muscle\n'
              '• Firm bite but still tender when cooked well\n'
              '• Strip of fat along one side – can be trimmed or served for extra flavour\n'
              '• Versatile: works from rare to well-done.',
          'Rump\n\n• From the hindquarter – well-used muscles\n'
              '• Leaner with more chew\n'
              '• Strong, “beefy” flavour\n'
              '• Often best around medium-rare / medium to keep some tenderness.',
        ],
        slideImages: [
          'assets/steak.jpg',
          'assets/fillet.png',
          'assets/ribeye.png',
          'assets/sirloin.png',
          'assets/rump.jpg',
        ],
        questionText:
            'Option A: Fillet is the most tender cut but usually has a milder flavour.\n\n'
            'Option B: Ribeye is the leanest cut with almost no fat.\n\n'
            'Option C: Rump is softer and more tender than fillet.\n\n'
            'Which statement about steak cuts is correct?',
      ),

      // THICKNESS MODULE
      ModuleInfo(
        id: 'thickness',
        title: 'Thickness & Control',
        slideTexts: [
          'Why thickness matters\n\n'
              '• Thicker steaks give you more control\n'
              '• You can build a crust without overcooking the centre\n'
              '• For ribeye and sirloin, aim around 2–2.5 cm (~1 inch).',
          'Cooking different thicknesses\n\n'
              '• Thin steaks cook very fast and can overcook in seconds\n'
              '• Steaks thicker than ~2.5 cm need longer, gentler cooking or finishing in the oven\n'
              '• Always adjust time to thickness – don’t rely on a fixed timer.',
          'Fillet and very thick cuts\n\n'
              '• Fillet is often 3–4 cm thick and very lean\n'
              '• Sear hard to get colour, then lower the heat / finish in the oven\n'
              '• Resting is essential so the centre finishes cooking without drying out.',
        ],
        slideImages: [
          'assets/ribeye.png',
          'assets/sirloin.png',
          'assets/fillet.png',
        ],
        questionText:
            'Option A: Around 2–2.5 cm is a good thickness for control, and thicker steaks need adjusted cooking time.\n\n'
            'Option B: Thin 1 cm steaks are easiest because you never need to adjust timing.\n\n'
            'Option C: Thickness doesn’t affect how you cook a steak.\n\n'
            'Which statement about steak thickness is correct?',
      ),

      // DONENESS MODULE
      ModuleInfo(
        id: 'doneness',
        title: 'Doneness Levels',
        slideTexts: [
          'Checking doneness\n\n'
              'Doneness describes how far the steak is cooked. A thermometer is the most reliable tool – '
              'colour alone can be misleading.\n\n'
              'You should still know the visual cues for each level.',
          'Rare & Medium-Rare\n\n'
              '• Rare: cool red centre, very soft, very juicy\n'
              '• Medium-rare: warm red centre, still very juicy, slightly firmer\n'
              'These are common targets for fillet and ribeye.',
          'Medium\n\n'
              '• Warm pink centre\n'
              '• More firm, slightly less juicy\n'
              'Often a safe choice for guests who don’t like “too much red”.',
          'Medium-Well & Well-Done\n\n'
              '• Medium-well: only a slight hint of pink, quite firm\n'
              '• Well-done: little or no pink, fully cooked through\n'
              'Flavour and juiciness drop, so you need careful cooking to avoid dryness.',
        ],
        slideImages: [
          'assets/doneness_chart.png', 
          'assets/fillet.png',
          'assets/ribeye.png',
          'assets/rump.jpg',
        ],
        questionText:
            'Option A: Medium-rare steak has a warm red centre and stays very juicy.\n\n'
            'Option B: Well-done steak is the juiciest because it is cooked the longest.\n\n'
            'Option C: Rare steak has no red in the centre.\n\n'
            'Which statement about doneness is correct?',
      ),

      // -------------------- COOKING METHOD MODULE --------------------
      ModuleInfo(
        id: 'cooking',
        title: 'Cooking Method: Searing & Beyond',
        slideTexts: [
          'The right pan\n\n'
              '• Use a heavy pan or cast-iron skillet\n'
              '• Pre-heat until very hot before the steak goes in\n'
              '• Heat retention = better crust.',
          'Oil, spacing & fat\n\n'
              '• Lightly oil the steak, not the whole pan\n'
              '• Don’t overcrowd – 1–2 steaks at a time\n'
              '• Let the fat on ribeye / sirloin render and crisp up for flavour.',
          'Season & turn\n\n'
              '• Season generously with salt and freshly ground pepper\n'
              '• Turn every 30–60 seconds for even cooking and colour\n'
              '• Add butter, garlic and herbs near the end for aroma.',
          'Resting\n\n'
              '• Rest the steak on a warm plate or board\n'
              '• Rest time ≈ cooking time\n'
              '• Juices redistribute, giving a more tender, juicy result.',
        ],
        slideImages: [
          'assets/hot_pan.jpg',
          'assets/ribeye.png',
          'assets/sirloin.png',
          'assets/steak_resting.jpg',
        ],
        questionText:
            'Option A: Use a very hot heavy pan, don’t overcrowd, oil the steak, season well, turn regularly and rest before serving.\n\n'
            'Option B: Put many cold steaks into a medium pan so they slowly steam.\n\n'
            'Option C: Skip resting to keep all the heat in the pan.\n\n'
            'Which approach to searing and cooking is correct?',
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

  void _openModule(ModuleInfo module) {
    if (module.isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${module.title} is already completed.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModuleScreen(
          title: module.title,
          slideTexts: module.slideTexts,
          slideImages: module.slideImages,
          questionText: module.questionText,
          onComplete: () {
            setState(() {
              module.status = ModuleStatus.completed;
            });
            if (_completedCount == modules.length) {
              widget.onCompleteAll?.call();
            }
          },
        ),
      ),
    );
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
                    onPressed: () => _openModule(cuts),
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
                    onPressed: () => _openModule(thickness),
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
                    onPressed: () => _openModule(doneness),
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
                    onPressed: () => _openModule(cooking),
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
                  if (allCompleted) // commented out for testing
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
