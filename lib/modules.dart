import 'package:flutter/material.dart';
import 'module_screens.dart';
import 'judge_game_flow.dart';
import 'progress_manager.dart'; // NEW - this is the file with state management
import 'audio_controller.dart';

enum ModuleStatus { notStarted, completed }

class ModuleInfo {
  final String id;
  final String title;
  final List<String> slideTexts;
  final List<String>? slideImages;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  ModuleStatus status;

  ModuleInfo({
    required this.id,
    required this.title,
    required this.slideTexts,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
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
      // -------------------- CUTS MODULE--------------------
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
          'assets/different_cuts.jpeg',
          'assets/fillet.png',
          'assets/ribeye.png',
          'assets/sirloin.png',
          'assets/rump.jpg',
        ],
        questionText: 'Which statement best describes ribeye compared to rump?',
        options: [
          'Ribeye has heavy marbling and big beefy flavour when cooked to medium/medium-rare.',
          'Fillet is fattier than ribeye and has the strongest flavour.',
          'Rump is the most tender cut with the finest grain.',
        ],
        correctOptionIndex: 0,
      ),

      // -------------------- THICKNESS MODULE--------------------
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
          'assets/thickness_image.jpeg',
          'assets/sirloin.png',
          'assets/fillet.png',
        ],
        questionText:
            'You have a very thin steak (around 2cm) steak. What approach keeps the centre juicy while getting a good crust?',
        options: [
          'Treat it like a thin steak; it won’t overcook.',
          'Sear on low heat for a long time so a crust never forms.',
          'Sear hot to build colour, then finish more gently (or in the oven) and rest to even out heat.',
        ],
        correctOptionIndex: 2,
      ),

      // -------------------- DONENESS MODULE --------------------
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
          'assets/medium_rare.jpg',
          'assets/medium.jpg',
          'assets/well.jpg',
        ],
        questionText: 'Which statement about doneness is accurate?',
        options: [
          'Well-done steaks stay juiciest because they cook the longest.',
          'Medium steak should have a warm pink centre and be firmer than medium-rare.',
          'Rare steak has no red in the centre.',
        ],
        correctOptionIndex: 1,
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
          'assets/oil_cooking.jpg',
          'assets/turning_steak.jpg',
          'assets/steak_resting.jpg',
        ],
        questionText:
            'Which approach delivers the best sear and even cook on steaks?',
        options: [
          'Use a very hot heavy pan, oil the steak lightly, turn regularly, finish with butter/aromatics, and rest.',
          'Put the steaks into a cold pan and gradually heat them up in a gentle manner.',
          'Cook steaks without oil to avoid flare-ups and skip resting to keep them hot.',
        ],
        correctOptionIndex: 0,
      ),
    ];

    // Load progress
    Future.microtask(() async {
      final pm = ProgressManager.instance;
      final result = await pm.loadState();
      if (!mounted) return;
      setState(() {
        for (final m in modules) {
          m.status = result.completedModules.contains(m.id)
              ? ModuleStatus.completed
              : ModuleStatus.notStarted;
        }
      });
    });
  }

  @override // had to add for audio controller to work properly when going back to modules screen
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      AudioController.playMenu(force: true);
    }
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

  // Changes to Future becuase now it's an async (asynchronous)
  // function whuch awaits the check to see if the module is completed
  // If it is show the notification on the bottom of the screen (SnackBar)
  // that doesn't interrupt the game but just informs the user
  // Otherise it opens the module to learn
  Future<void> _openModule(ModuleInfo module) async {
    // Pushed to navigator the learning module screen if the module was
    // not completed
    // Push (and pop) is useful for moving between the modules screen and the
    // main 'Training' screen
    // The module is on until it's popped which allows to review the slides again
    // easily witout moving to the main screen
    //
    // onComplete is passed to mark the module as done when the user answer correctly
    // If all modeuls are completed then it turns the onCompleteAll which allows to move
    // to practical training and the judges game (AKA training completed)
    //
    // setState forces the main screen to pick up all the changes (shaded buttons of comleted modules
    // and the progress text, update all the information corretly on the main screen)
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModuleScreen(
          title: module.title,
          slideTexts: module.slideTexts,
          slideImages: module.slideImages,
          questionText: module.questionText,
          options: module.options,
          correctOptionIndex: module.correctOptionIndex,
          onComplete: () {
            setState(() {
              module.status = ModuleStatus.completed;
            });

            final pm = ProgressManager.instance;
            final completedIds = modules
                .where((m) => m.isCompleted)
                .map((m) => m.id)
                .toList();
            pm.saveState(completedModules: completedIds);
            if (_completedCount == modules.length) {
              widget.onCompleteAll?.call();
            }
          },
        ),
      ),
    );
    setState(() {});
  }

  // This function saves the game progress through shared preferences
  // It's Future as it awaits the completition, meaning the correct
  // time and state of the game saves, regardless if the user makes
  // an action in the meantime
  //
  // Save gets all the completed module ids in a simple way
  //
  // Floating snack bar is a simple notification on the bottom of the screen
  // that doesn't interrupt the game
  Future<void> _saveProgress() async {
    final pm = ProgressManager.instance;
    final completedIds = modules
        .where((m) => m.isCompleted)
        .map((m) => m.id)
        .toList();
    await pm.saveState(completedModules: completedIds);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress saved'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {});
  }

  // This function loads the save from previous funtion
  // It loads it from SharedPreferences
  // setState here updates each moduleinfo.status based on what was saved
  Future<void> _loadProgress() async {
    final pm = ProgressManager.instance;
    final result = await pm.loadState();
    setState(() {
      for (final m in modules) {
        m.status = result.completedModules.contains(m.id)
            ? ModuleStatus.completed
            : ModuleStatus.notStarted;
      }
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress loaded'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // This resets all the game to originial and moves to main screen
  // from the start
  // It's a TOTAL reset - no saved games
  // In the different function user is asked if user wish to continue
  // which avoids accidental, annoying resets
  Future<void> _resetProgress() async {
    await ProgressManager.instance.resetState();
    setState(() {
      for (final m in modules) {
        m.status = ModuleStatus.notStarted;
      }
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress reset'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = modules.length;
    final done = _completedCount;
    final allCompleted =
        done == total &&
        total > 0; // Removed points and errors from learning modules

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
                        const SizedBox(
                          height: 6,
                        ), // Removed points and errors from training modules
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: _saveProgress,
                              child: const Text('Save'),
                            ),
                            OutlinedButton(
                              onPressed: _loadProgress,
                              child: const Text('Load'),
                            ),
                            OutlinedButton(
                              child: const Text('Restart'),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  // Added a warning that the 'Restart' is a hot restart and added a check if user wished to continue
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Warning'),
                                      content: const Text(
                                        'Warning: this restarts the game completely and clears the saved game.\n\nDo you want to continue?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(
                                            context,
                                          ).pop(false), // Don't restart
                                          child: const Text('Cancel'),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.of(
                                            context,
                                          ).pop(true), // Restart
                                          child: const Text('Restart'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm != true) return;

                                await ProgressManager.instance.resetState();
                                if (context.mounted) {
                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst);
                                }
                              },
                            ),
                          ],
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
                  if (allCompleted)
                    FilledButton(
                      onPressed: () async {
                        await AudioController.playGameplay();
                        Navigator.pushNamed(
                          context,
                          '/judge_brief',
                          arguments:
                              GameState(), // NEW - I think all good now with the game state managment and it can work like that
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
