import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'modules.dart';
import 'judge_game_flow.dart';
import 'progress_manager.dart';

void main() {
  runApp(const SteakMasterApp());
}

class AudioController {
  static final AudioPlayer player = AudioPlayer();

  static Future<void> start() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('music/jazz.mp3'));
  }

  static void stop() {
    player.stop();
  }
}

class SteakMasterApp extends StatelessWidget {
  const SteakMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SteakMaster',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF7B3F00),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/judge_brief': (context) {
          final state = ModalRoute.of(context)!.settings.arguments as GameState;
          return JudgeBriefScreen(state: state);
        },
        '/judge_cut': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as CutFlowArgs;
          return CutPickScreen(state: args.state, selection: args.selection);
        },
        '/judge_thickness': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as CutFlowArgs;
          return ThicknessPickScreen(
            state: args.state,
            selection: args.selection,
          );
        },
        '/judge_doneness': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as CutFlowArgs;
          return DonenessPickScreen(
            state: args.state,
            selection: args.selection,
          );
        },
        '/judge_summary': (context) {
          final state = ModalRoute.of(context)!.settings.arguments as GameState;
          return SummaryScreen(state: state);
        },
        '/judge_ending': (context) {
          final a = ModalRoute.of(context)!.settings.arguments as EndingArgs;
          return EndingScreen(
            img: a.img,
            title: a.title,
            msg: a.msg,
            total: a.total,
            avg: a.avg,
            state: a
                .state, // NEW - adding final game state (Points, errors) to the ending screen
          );
        },
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    AudioController.start();
  }

  bool _practiceEnabled = true;
  bool _refreshScheduled = false;

  Future<void> _refreshPracticeEnabled() async {
    if (!mounted) return;
    setState(() => _practiceEnabled = true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() async {
      if (!mounted) return;
      setState(() => _practiceEnabled = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_refreshScheduled) {
      _refreshScheduled = true;
      Future.microtask(() async {
        await _refreshPracticeEnabled();
        _refreshScheduled = false;
      });
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/grill.jpg', fit: BoxFit.cover),
          Opacity(
            opacity: 0.6,
            child: IgnorePointer(
              child: Image.asset(
                'assets/smoke.gif',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.85),
                gaplessPlayback: true,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.35)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SteakMaster',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 8,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IntroScreen()),
                    );
                  },
                  child: const Text('Begin: Learn and Practice Mode'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // grayd out when disabled
                      }
                      return Colors.brown.shade700;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.white70;
                      }
                      return Colors.white;
                    }),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: _practiceEnabled
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const IntroScreen(mode: 'practice'),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Begin: Practice Mode'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final String? mode; // Mode for the game (training + judge or judge)
  const IntroScreen({super.key, this.mode});

  bool get isPractice => mode == 'practice';

  @override
  Widget build(BuildContext context) {
    // Added message based on if it's the training + judge game or only judge game
    final message = isPractice
        ? "Your goal is to prepare steaks exactly according to each client's preferences.\n\n"
              "Prepare the steaks according to requirements of the judges and clients.\n\n"
        : "Your goal is to prepare steaks exactly according to each client's preferences.\n\n"
              "Use the training modules to build your knowledge, then apply it in assessment rounds.\n\n"
              "Prepare the steaks according to requirements of the judges and clients.\n\n"
              "Your finally performance will be evaluated based on the judges' feedback.\n\n";

    final VoidCallback onContinue = isPractice
        ? () {
            Navigator.pushNamed(
              context,
              '/judge_brief',
              arguments: GameState(),
            );
          }
        : () {
            Navigator.push(
              context,
              // switch to modules screen
              MaterialPageRoute(builder: (_) => const ModulesScreen()),
            );
          };

    final continueLabel = isPractice ? 'Continue to Practice' : 'Continue';

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
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7E6).withOpacity(0.97),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.brown.withOpacity(0.25)),
                    ),
                    child: Text(
                      message, // refactored code for redundancy
                      style: const TextStyle(fontSize: 16.5, height: 1.35),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onContinue,
                      child: Text(continueLabel),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
