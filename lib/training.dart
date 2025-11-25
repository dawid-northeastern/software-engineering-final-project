import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SteakCut { fillet, ribeye, sirloin, rump }
enum SteakThickness { thin, standard, thick }
enum SteakDoneness { rare, mediumRare, medium }

String cutLabel(SteakCut cut) {
  switch (cut) {
    case SteakCut.fillet:
      return 'Fillet';
    case SteakCut.ribeye:
      return 'Ribeye';
    case SteakCut.sirloin:
      return 'Sirloin';
    case SteakCut.rump:
      return 'Rump';
  }
}

String thicknessLabel(SteakThickness thickness) {
  switch (thickness) {
    case SteakThickness.thin:
      return 'Thin';
    case SteakThickness.standard:
      return 'Standard';
    case SteakThickness.thick:
      return 'Thick';
  }
}

String donenessLabel(SteakDoneness doneness) {
  switch (doneness) {
    case SteakDoneness.rare:
      return 'Rare (~52°C)';
    case SteakDoneness.mediumRare:
      return 'Medium Rare (~57°C)';
    case SteakDoneness.medium:
      return 'Medium (~63°C)';
  }
}

class SteakScenario {
  final String title;
  final String description;
  final SteakCut correctCut;
  final SteakThickness correctThickness;
  final SteakDoneness correctDoneness;

  const SteakScenario({
    required this.title,
    required this.description,
    required this.correctCut,
    required this.correctThickness,
    required this.correctDoneness,
  });
}

class PracticeScenarioState extends ChangeNotifier {
  PracticeScenarioState()
      : _scenarios = const [
          SteakScenario(
            title: 'Customer: Lean & Red',
            description:
                'A health-conscious guest wants a very tender steak, almost no visible fat, '
                'and a red centre. They prefer a gentle cook, not heavy char.',
            correctCut: SteakCut.fillet,
            correctThickness: SteakThickness.standard,
            correctDoneness: SteakDoneness.rare,
          ),
          SteakScenario(
            title: 'Customer: Rich & Juicy',
            description:
                'A food critic loves rich flavour and visible marbling. They want a juicy steak '
                'with a warm red-pink centre and a good seared crust.',
            correctCut: SteakCut.ribeye,
            correctThickness: SteakThickness.thick,
            correctDoneness: SteakDoneness.mediumRare,
          ),
          SteakScenario(
            title: 'Customer: Balanced & Safe',
            description:
                'A home cook is nervous about undercooked meat. They want a balanced steak, not too fatty, '
                'with a pink but not red centre and a comfortable, “safe” doneness.',
            correctCut: SteakCut.sirloin,
            correctThickness: SteakThickness.standard,
            correctDoneness: SteakDoneness.medium,
          ),
        ];

  final List<SteakScenario> _scenarios;

  int _currentIndex = 0;
  int _totalScore = 0; 
  int _roundsPlayed = 0;
  int _bestScore = 0; 

  SteakCut? selectedCut;
  SteakThickness? selectedThickness;
  SteakDoneness? selectedDoneness;
  String? feedbackText;    
  int? lastScore;          

  SteakScenario get currentScenario => _scenarios[_currentIndex];

  int get currentIndex => _currentIndex;
  int get totalScenarios => _scenarios.length;
  int get totalScore => _totalScore;
  int get roundsPlayed => _roundsPlayed;
  int get bestScore => _bestScore;

  double get averageScore =>
      _roundsPlayed == 0 ? 0 : _totalScore / _roundsPlayed;

  bool get hasNextScenario => _currentIndex < _scenarios.length - 1;
  bool get selectionsComplete =>
      selectedCut != null &&
      selectedThickness != null &&
      selectedDoneness != null;

  void chooseCut(SteakCut cut) {
    selectedCut = cut;
    feedbackText = null;
    lastScore = null;
    notifyListeners();
  }

  void chooseThickness(SteakThickness thickness) {
    selectedThickness = thickness;
    feedbackText = null;
    lastScore = null;
    notifyListeners();
  }

  void chooseDoneness(SteakDoneness doneness) {
    selectedDoneness = doneness;
    feedbackText = null;
    lastScore = null;
    notifyListeners();
  }

  void _resetSelections() {
    selectedCut = null;
    selectedThickness = null;
    selectedDoneness = null;
    feedbackText = null;
    lastScore = null;
  }

  void checkAnswers() {
    final scenario = currentScenario;
    int score = 0;
    final buffer = StringBuffer();

    if (selectedCut == scenario.correctCut) {
      score++;
      buffer.writeln(
        'CUT: ${cutLabel(selectedCut!)} matches the brief.\n'
        'Tip: For this customer, tenderness and fat level line up well with this cut.',
      );
    } else {
      buffer.writeln(
        'CUT: ${cutLabel(selectedCut!)} is not ideal here.\n'
        'Tip: ${cutLabel(scenario.correctCut)} better matches the requested tenderness and fat level.',
      );
    }

    buffer.writeln();

    if (selectedThickness == scenario.correctThickness) {
      score++;
      buffer.writeln(
        'THICKNESS: ${thicknessLabel(selectedThickness!)} is a good choice.\n'
        'Tip: This thickness gives you enough control over the centre temperature.',
      );
    } else {
      buffer.writeln(
        'THICKNESS: ${thicknessLabel(selectedThickness!)} is not the best.\n'
        'Tip: ${thicknessLabel(scenario.correctThickness)} fits the cooking style and doneness they want.',
      );
    }

    buffer.writeln();

    if (selectedDoneness == scenario.correctDoneness) {
      score++;
      buffer.writeln(
        'DONENESS: ${donenessLabel(selectedDoneness!)} matches their description.\n'
        'Tip: Focus on how the inside looks and feels, not just the number.',
      );
    } else {
      buffer.writeln(
        'DONENNESS: ${donenessLabel(selectedDoneness!)} doesn’t fully match what they asked for.\n'
        'Tip: ${donenessLabel(scenario.correctDoneness)} is closer to the colour and temperature they described.',
      );
    }

    buffer.writeln('\nRound score: $score / 3 correct.');

    _roundsPlayed++;
    _totalScore += score;

    if (score > _bestScore) _bestScore = score;

    lastScore = score;
    feedbackText = buffer.toString();
    notifyListeners();
  }

  void nextScenario() {
    if (hasNextScenario) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    _resetSelections();
    notifyListeners();
  }

  void resetSession() {
    _currentIndex = 0;
    _totalScore = 0;
    _roundsPlayed = 0;
    _bestScore = 0;

    _resetSelections();

    notifyListeners();
  }
}

class PracticeScenarioScreen extends StatelessWidget {
  const PracticeScenarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PracticeScenarioState(),
      child: const _PracticeScenarioView(),
    );
  }
}

class _PracticeScenarioView extends StatelessWidget {
  const _PracticeScenarioView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PracticeScenarioState>();
    final scenario = state.currentScenario;

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
                  Text(
                    'Practice Scenario',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Scenario ${state.currentIndex + 1} of ${state.totalScenarios}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.brown.shade300,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bar_chart, size: 18, color: Colors.brown),
                          const SizedBox(width: 8),
                          Text(
                            'Avg: '
                            '${state.roundsPlayed == 0 ? '–' : state.averageScore.toStringAsFixed(1)}/3',
                            style: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.emoji_events_outlined, size: 18, color: Colors.brown),
                          const SizedBox(width: 4),
                          Text(
                            'Best: ${state.bestScore}/3',
                            style: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.refresh, size: 18, color: Colors.brown),
                          const SizedBox(width: 4),
                          Text(
                            'Rounds: ${state.roundsPlayed}',
                            style: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6).withOpacity(0.97),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.brown.withOpacity(0.25),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Customer Brief',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              scenario.description,
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '1. Choose Cut',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButton<SteakCut>(
                              isExpanded: true,
                              value: state.selectedCut,
                              hint: const Text('Select cut'),
                              items: SteakCut.values
                                  .map(
                                    (cut) => DropdownMenuItem(
                                      value: cut,
                                      child: Text(cutLabel(cut)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<PracticeScenarioState>()
                                      .chooseCut(value);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '2. Choose Thickness',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButton<SteakThickness>(
                              isExpanded: true,
                              value: state.selectedThickness,
                              hint: const Text('Select thickness'),
                              items: SteakThickness.values
                                  .map(
                                    (thickness) => DropdownMenuItem(
                                      value: thickness,
                                      child: Text(thicknessLabel(thickness)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<PracticeScenarioState>()
                                      .chooseThickness(value);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '3. Choose Doneness',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButton<SteakDoneness>(
                              isExpanded: true,
                              value: state.selectedDoneness,
                              hint: const Text('Select doneness'),
                              items: SteakDoneness.values
                                  .map(
                                    (doneness) => DropdownMenuItem(
                                      value: doneness,
                                      child: Text(donenessLabel(doneness)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<PracticeScenarioState>()
                                      .chooseDoneness(value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            Center(
                              child: FilledButton(
                                onPressed: () {
                                  final get_state = context.read<PracticeScenarioState>();
                                  if (!get_state.selectionsComplete) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Choose a cut, thickness and doneness before checking.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  get_state.checkAnswers();
                                },
                                child: const Text('Check my decisions'),
                              ),
                            ),

                            if (state.feedbackText != null) ...[
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 8),
                              const Text(
                                'Feedback',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.feedbackText!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          context
                              .read<PracticeScenarioState>()
                              .resetSession();
                        },
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset session'),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              context
                                  .read<PracticeScenarioState>()
                                  .nextScenario();
                            },
                            child: const Text('Next scenario'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
