import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'progress_manager.dart'; // NEW - game state managmenet is updated on each decision and gives final result
import 'ai_service.dart'; // NEW - added the ai_serivce to the feedback from the 'judges'

// enums below (we got to refactor and separate files later)

enum Cut { fillet, ribeye, sirloin, rump, salad }

enum Thickness { thin, standard, thick }

enum Doneness { rare, mediumRare, medium, mediumWell, wellDone }

// following variables are placeholders for the AI generations

// Placeholder variables for AI generations
String judgeName = "Jordan Reed";
int judgeAge = 34;
String judgeProfession = "Food critic";
String judgePersonality =
    "calm analytical listener patient with precise feedback warm and respectful";

int judgeScore = 85;
String judgeThoughts = "Ribeye is a great choice for flavor and tenderness.";
String judgeFeedback = "Medium rare aligns well with juiciness.";
String judgeTip = "Ensure a well-seared crust for enhanced aroma.";

String labelCut(Cut c) {
  switch (c) {
    case Cut.fillet:
      return 'Fillet';
    case Cut.ribeye:
      return 'Ribeye';
    case Cut.sirloin:
      return 'Sirloin';
    case Cut.rump:
      return 'Rump';
    case Cut.salad:
      return 'Salad';
  }
}

String labelThickness(Thickness t) {
  switch (t) {
    case Thickness.thin:
      return 'Thin (~2 cm)';
    case Thickness.standard:
      return 'Standard (~3 cm)';
    case Thickness.thick:
      return 'Thick (4+ cm)';
  }
}

String labelDoneness(Doneness d) {
  switch (d) {
    case Doneness.rare:
      return 'Rare';
    case Doneness.mediumRare:
      return 'Medium Rare';
    case Doneness.medium:
      return 'Medium';
    case Doneness.mediumWell:
      return 'Medium Well';
    case Doneness.wellDone:
      return 'Well Done';
  }
}

String assetForCut(Cut c) {
  switch (c) {
    case Cut.fillet:
      return 'assets/fillet.png';
    case Cut.ribeye:
      return 'assets/ribeye.png';
    case Cut.sirloin:
      return 'assets/sirloin.png';
    case Cut.rump:
      return 'assets/rump.jpg';
    case Cut.salad:
      return 'assets/salad.png';
  }
}

// judge profiles models

class JudgeProfile {
  final String name;
  final String level;
  final String bio;
  final String portraitAsset;
  final Alignment portraitAlign;

  final Cut preferredCut;
  final Thickness preferredThickness;
  final Doneness preferredDoneness;

  const JudgeProfile({
    required this.name,
    required this.level,
    required this.bio,
    required this.portraitAsset,
    this.portraitAlign = Alignment.center,
    required this.preferredCut,
    required this.preferredThickness,
    required this.preferredDoneness,
  });
}

class JudgeSelection {
  Cut? cut;
  Thickness? thickness;
  Doneness? doneness;

  JudgeSelection({this.cut, this.thickness, this.doneness});
}

class JudgeResult {
  final JudgeProfile judge;
  final JudgeSelection selection;

  // Changed the game state managment system so that is not needed anymore
  const JudgeResult({required this.judge, required this.selection});
}

// NEW - improved the game state management system that is based on both the training part
// and the 'judges game' part, it's throughout the whole learning and the whole app
// The final results and if the game was completed successfuly is based on that state managment
class GameState {
  final List<JudgeProfile> judges = const [
    JudgeProfile(
      name: 'Adam',
      level: 'High-level judge',
      bio:
          'Precision taster. Loves balance and tenderness; not keen on fatty bites.',
      portraitAsset: 'assets/judge1.png',
      portraitAlign: Alignment(0, -0.28),
      preferredCut: Cut.fillet,
      preferredThickness: Thickness.thick,
      preferredDoneness: Doneness.mediumRare,
    ),
    JudgeProfile(
      name: 'Amanda',
      level: 'Butcher judge',
      bio:
          'All about marbling and aroma. Prefers a classic ribeye, standard thickness.',
      portraitAsset: 'assets/judge2.png',
      portraitAlign: Alignment(0, -0.18),
      preferredCut: Cut.ribeye,
      preferredThickness: Thickness.standard,
      preferredDoneness: Doneness.medium,
    ),
    JudgeProfile(
      name: 'Lucas',
      level: 'Technique judge',
      bio: 'Obsessed with sear quality. Loves sirloins at medium well.',
      portraitAsset: 'assets/judge3.png',
      portraitAlign: Alignment(0, -0.35),
      preferredCut: Cut.sirloin,
      preferredThickness: Thickness.standard,
      preferredDoneness: Doneness.mediumWell,
    ),
  ];

  final List<JudgeResult> results = [];
  int index = 0;

  JudgeProfile get current => judges[index];
  bool get isFinished => index >= judges.length;

  // submit function was extended to not just record the choice
  // it calls _trackExperience which compares the player's selection against judge
  // preferences, adjusts points and errors in ProgresssManager and show snackbar (the
  // notification on bottom of the screen that doesn't interrupt the game) for correct/incorrect
  // It adds JudgeResult like previously and increments the index to move to the next judge
  void submit(BuildContext context, JudgeSelection sel) {
    _trackExperience(context, sel, current);
    results.add(JudgeResult(judge: current, selection: sel));
    index++;
  }

  // _trackExperience compares player selection to judge prerefence
  // it updates points and errors based on it
  // seperate points for each: thickness, cut, doneness
  void _trackExperience(
    BuildContext context,
    JudgeSelection sel,
    JudgeProfile j,
  ) {
    final pm = ProgressManager.instance;
    if (sel.cut == j.preferredCut) {
      pm.addCorrect();
      _notify(context, true);
    } else {
      pm.addIncorrect();
      _notify(context, false);
    }

    if (sel.thickness == j.preferredThickness) {
      pm.addCorrect();
      _notify(context, true);
    } else {
      pm.addIncorrect();
      _notify(context, false);
    }

    if (sel.doneness == j.preferredDoneness) {
      pm.addCorrect();
      _notify(context, true);
    } else {
      pm.addIncorrect();
      _notify(context, false);
    }
  }

  // creates a simple notification (snackbar) for each decision
  void _notify(BuildContext context, bool correct) {
    final text = correct
        ? 'Correct answer: +15 Points'
        : 'Incorrect answer: -10 Points';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  // restarts from first judge and clears the current results
  void restart() {
    results.clear();
    index = 0;
  }
}

class CutFlowArgs {
  final GameState state;
  final JudgeSelection selection;
  CutFlowArgs({required this.state, required this.selection});
}

class EndingArgs {
  final String img;
  final String title;
  final String msg;
  final double total;
  final double avg;
  final GameState
  state; // NEW - now ending arguments have the state managment system essential for the app now
  EndingArgs(this.img, this.title, this.msg, this.total, this.avg, this.state);
}

class BoardBackground extends StatelessWidget {
  final Widget child;
  const BoardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/cutting_board.png', fit: BoxFit.cover),
        Container(color: Colors.black.withOpacity(0.12)),
        SafeArea(child: child),
      ],
    );
  }
}

class LabelChip extends StatelessWidget {
  final String text;
  final bool selected;
  const LabelChip(this.text, {super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.brown.shade700 : Colors.brown.shade50;
    final fg = selected ? Colors.white : Colors.brown.shade900;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? Colors.brown.shade700 : Colors.brown.shade300,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

// different screens for judge game flow

// NEW - this is a Stateful widget now as it reacts to game state manaagmenet
// and the current state (points, errors)
// It also allows to save/load/restart
// It provides notification based on the user actions
// Bascially, it rebuilds the game when state changes all based on 'GameState' instance which
// holds those states
class JudgeBriefScreen extends StatefulWidget {
  final GameState state;
  const JudgeBriefScreen({super.key, required this.state});

  @override
  State<JudgeBriefScreen> createState() => _JudgeBriefScreenState();
}

class _JudgeBriefScreenState extends State<JudgeBriefScreen> {
  // saves current judge index to Progessmanager,
  // shows the snack bar (bar at the bottom of the screen which doesn't interrupt the game)
  // setState refreshes the UI to avoid any inconsistancies
  Future<void> _save() async {
    await ProgressManager.instance.saveState(
      completedModules: const [],
      judgeIndex: widget.state.index,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress saved'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {});
  }

  // load clears existing results, and loads the saved game
  Future<void> _load() async {
    final result = await ProgressManager.instance.loadState();
    widget.state.results.clear();
    widget.state.index = (result.judgeIndex ?? 0).clamp(
      0,
      widget.state.judges.length,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress loaded'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {});
  }

  // completely restarts the game
  Future<void> _restart() async {
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
              onPressed: () =>
                  Navigator.of(context).pop(false), // Don't restrat
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true), // Restatr
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await ProgressManager.instance.resetState();
    widget.state.restart();
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    // it's now widget.state.isFinished as state is not
    // local anymore
    // In a State class widgets are accessed via 'widget'
    //
    // GameState is passed into JudgeBriefScreen as widget.state
    // and now it's passed here to check if it's finished
    if (widget.state.isFinished) {
      return SummaryScreen(state: widget.state);
    }

    // j - gets the current judge profile from the GameState
    // pm - gets the ProgressManager (a singleton pattern in that case) so the game state mananagmenet
    //      can be rendered in the screen
    final j = widget.state.current;
    final pm = ProgressManager.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Judge ${widget.state.index + 1}',
        ), // NEW - had to change from state.index to widget.state.index based on the new structued (explained above)
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: BoardBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // NEw - just added the new inforamtion to the game screen/UI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatBadge(label: 'Points', value: pm.experience),
                _StatBadge(label: 'Errors', value: pm.errors),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
                FilledButton(
                  onPressed: _load,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Load'),
                ),
                FilledButton(
                  onPressed: _restart,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Restart'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${j.name} • ${j.level}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(j.bio, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/judge_cut',
                  arguments: CutFlowArgs(
                    state: widget
                        .state, // NEW - again had to change from state to widget.state
                    selection: JudgeSelection(),
                  ),
                );
              },
              child: const Text("I remember — let's cook"),
            ),
          ],
        ),
      ),
    );
  }
}

class CutPickScreen extends StatefulWidget {
  final GameState state;
  final JudgeSelection selection;
  const CutPickScreen({
    super.key,
    required this.state,
    required this.selection,
  });

  @override
  State<CutPickScreen> createState() => _CutPickScreenState();
}

class _CutPickScreenState extends State<CutPickScreen> {
  Cut? _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.selection.cut ?? Cut.fillet;
  }

  void _next() {
    widget.selection.cut = _picked;

    if (_picked == Cut.salad) {
      // Deals with the very wrong salad choice
      ProgressManager.instance.addIncorrect();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect answer: -10 Points'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(
        context,
        '/judge_ending',
        arguments: EndingArgs(
          'assets/ending_empty.jpg',
          '…Wait, Salad?',
          'The judges came for steak. You served salad.',
          0, // NEW - there is not totalScore anymore based on new game state managmenet
          0, // NEW - there is not avergageScore anymore based on new game state managmenet
          widget.state, // NEW - there is now state for new game state managment
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/judge_thickness',
      arguments: CutFlowArgs(state: widget.state, selection: widget.selection),
    );
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.state.current;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Cut • ${j.name}'),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: BoardBackground(
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          childAspectRatio: .92,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            for (final c in Cut.values)
              _CutCard(
                cut: c,
                selected: _picked == c,
                onTap: () => setState(() => _picked = c),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: _next,
          child: Text(_picked == Cut.salad ? 'Serve Salad' : 'Next: Thickness'),
        ),
      ),
    );
  }
}

class _CutCard extends StatelessWidget {
  final Cut cut;
  final bool selected;
  final VoidCallback onTap;

  const _CutCard({
    required this.cut,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF7E6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(assetForCut(cut), fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                LabelChip(labelCut(cut), selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThicknessPickScreen extends StatefulWidget {
  final GameState state;
  final JudgeSelection selection;
  const ThicknessPickScreen({
    super.key,
    required this.state,
    required this.selection,
  });

  @override
  State<ThicknessPickScreen> createState() => _ThicknessPickScreenState();
}

class _ThicknessPickScreenState extends State<ThicknessPickScreen> {
  Thickness? _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.selection.thickness ?? Thickness.standard;
  }

  void _next() {
    widget.selection.thickness = _picked;
    Navigator.pushReplacementNamed(
      context,
      '/judge_doneness',
      arguments: CutFlowArgs(state: widget.state, selection: widget.selection),
    );
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.state.current;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Thickness • ${j.name}'),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: BoardBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ThicknessCard(
              title: labelThickness(Thickness.thin),
              selected: _picked == Thickness.thin,
              onTap: () => setState(() => _picked = Thickness.thin),
              barHeight: 8,
              caption: 'Fast sear, quick to overcook',
            ),
            const SizedBox(height: 10),
            _ThicknessCard(
              title: labelThickness(Thickness.standard),
              selected: _picked == Thickness.standard,
              onTap: () => setState(() => _picked = Thickness.standard),
              barHeight: 16,
              caption: 'Balanced cook & crust',
            ),
            const SizedBox(height: 10),
            _ThicknessCard(
              title: labelThickness(Thickness.thick),
              selected: _picked == Thickness.thick,
              onTap: () => setState(() => _picked = Thickness.thick),
              barHeight: 26,
              caption: 'Juicier center, slower cook',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: _next,
          child: const Text('Next: Doneness'),
        ),
      ),
    );
  }
}

class _ThicknessCard extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final double barHeight;
  final String caption;

  const _ThicknessCard({
    required this.title,
    required this.selected,
    required this.onTap,
    required this.barHeight,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? Colors.brown.shade700
        : Colors.brown.withOpacity(0.35);

    return Material(
      color: const Color(0xFFFFF7E6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  height: barHeight,
                  width: 60,
                  color: Colors.brown.shade300,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelChip(title, selected: selected),
                      Text(caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DonenessPickScreen extends StatefulWidget {
  final GameState state;
  final JudgeSelection selection;
  const DonenessPickScreen({
    super.key,
    required this.state,
    required this.selection,
  });

  @override
  State<DonenessPickScreen> createState() => _DonenessPickScreenState();
}

class _DonenessPickScreenState extends State<DonenessPickScreen> {
  int _index = 1;

  @override
  void initState() {
    super.initState();
    _index = Doneness.values.indexOf(
      widget.selection.doneness ?? Doneness.mediumRare,
    );
  }

  // this finalises the current judge 'round'
  // stores choosen doneness into 'selection'
  // the new code is here as doneness is the last part before evaluation
  Future<void> _serve() async {
    final judgeProfile = widget
        .state
        .current; // capture before state advances - this fixes the issue after no AI feedback for the last judge
    widget.selection.doneness = Doneness.values[_index];

    // scores the selections, updates progress, and go to next judge
    widget.state.submit(context, widget.selection);

    // Displau the judge (AI) feedback
    await _showFeedback(
      context,
      judgeProfile,
    ); // Added to make sure the AI feedback correctly displays for each judge

    // go to final stage or go to next judge if there is one
    final targetRoute = widget.state.isFinished
        ? '/judge_summary'
        : '/judge_brief';

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => ServeJudgeAnimation(
        onCompleted: () {
          entry.remove();
          Navigator.pushReplacementNamed(
            context,
            targetRoute, // NEW - refactored based on new targetRoute which is run AFTER the judge (AI) feedback
            arguments: widget.state,
          );
        },
      ),
    );

    overlay.insert(entry);
  }

  // Imporant function that deals with judge (AI) feedback
  Future<void> _showFeedback(
    BuildContext context,
    JudgeProfile judgeProfile,
  ) async {
    try {
      final judge = Judge(
        name: judgeProfile.name,
        age: 30, // for now hardcoded
        profession: judgeProfile.level,
        fatPref: labelCut(judgeProfile.preferredCut),
        tendernessPref: labelThickness(judgeProfile.preferredThickness),
        crustPref: 'Crusty sear', // for now hardcoded
        donenessPref: labelDoneness(judgeProfile.preferredDoneness),
        personality: 'picky but fair', // for now hardcoded
      );

      final feedback = await getFeedback(
        judge: judge,
        cut: labelCut(widget.selection.cut!),
        thickness: labelThickness(widget.selection.thickness!),
        doneness: labelDoneness(widget.selection.doneness!),
        method: "Pan-Seared",
      );

      if (!mounted) return;
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Judge Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                _FeedbackBulletPoints(
                  title: 'Score',
                  text: feedback.score.toString(),
                ),
                _FeedbackBulletPoints(
                  title: 'Feedback',
                  text: feedback.feedback,
                ),
                _FeedbackBulletPoints(
                  title: 'Thoughts',
                  text: feedback.thoughts,
                ),
                _FeedbackBulletPoints(title: 'Tips', text: feedback.tip),
              ],
            ),
          );
        },
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not fetch AI feedback right now.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = Doneness.values.map(labelDoneness).toList();
    final j = widget.state.isFinished
        ? widget.state.judges.last
        : widget
              .state
              .current; // Fixes the issue of displaying the feedback for the last judge before moving to 'Results' screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Doneness • ${j.name}'),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: BoardBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Slider(
              value: _index.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              label: labels[_index],
              onChanged: (v) => setState(() => _index = v.round()),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < labels.length; i++)
              _DonenessCard(
                text: labels[i],
                selected: _index == i,
                onTap: () => setState(() => _index = i),
              ),
            const SizedBox(height: 16),
            Image.asset('assets/doneness_chart.png'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: _serve,
          icon: const Icon(Icons.restaurant),
          label: const Text('Serve Steak'),
        ),
      ),
    );
  }
}

class _DonenessCard extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _DonenessCard({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.brown.shade700 : const Color(0xFFFFF7E6);
    final fg = selected ? Colors.white : Colors.brown.shade900;

    return Material(
      color: bg,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(color: fg, fontWeight: FontWeight.w700),
              ),
              if (selected) Icon(Icons.check, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final GameState state;
  const SummaryScreen({super.key, required this.state});

  void _finish(BuildContext context) {
    // NEW - check the new state management system and if ex > 50 and errors < 5 then game won
    final pm = ProgressManager.instance;
    final win = pm.experience > 50 && pm.errors < 5;
    final img = win ? 'assets/ending_michelin.jpg' : 'assets/ending_empty.jpg';
    Navigator.pushReplacementNamed(
      context,
      '/judge_ending',
      arguments: EndingArgs(img, '', '', 0, 0, state),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: BoardBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final r in state.results) _ResultCard(result: r),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _finish(context),
              icon: const Icon(Icons.emoji_events),
              label: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final JudgeResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final j = result.judge;
    final s = result.selection;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              j.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text('Cut: ${labelCut(s.cut!)}'),
            Text('Thickness: ${labelThickness(s.thickness!)}'),
            Text('Doneness: ${labelDoneness(s.doneness!)}'),
          ],
        ),
      ),
    );
  }
}

// Rendering for the state management (Points and Error number)
// used to display errors and points in structured way
class _StatBadge extends StatelessWidget {
  final String label;
  final int value;
  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.brown.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.brown.shade800,
            ),
          ),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// Displaying AI feedback in structured bullet points for user clarity and experience
class _FeedbackBulletPoints extends StatelessWidget {
  final String title;
  final String text;
  const _FeedbackBulletPoints({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14.5),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EndingScreen extends StatelessWidget {
  final String img;
  final String title;
  final String msg;
  final double total;
  final double avg;
  final GameState
  state; // NEW - need to new game staate management for the ending screen

  const EndingScreen({
    super.key,
    required this.img,
    required this.title,
    required this.msg,
    required this.total,
    required this.avg,
    required this.state, // NEW - for new game state management system
  });

  @override
  Widget build(BuildContext context) {
    // NEW - gives how many ex more needed to win or how many errors less to win
    final pm = ProgressManager.instance;
    final points = pm.experience;
    final errs = pm.errors;
    final bool win = points > 50 && errs < 5;
    final int pointsShort = win ? 0 : (points >= 50 ? 0 : 50 - points);
    final int errOver = win ? 0 : (errs <= 5 ? 0 : errs - 5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Epilogue'),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Image.asset(
            img,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black.withOpacity(0.35)),
          Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // NEW - changes to epilogue screen based on if won or not, resettng the game
                  Text(
                    win ? 'You Win!' : 'Keep Training',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    win
                        ? 'Great job! You reached the target with solid execution.'
                        : _lossMessage(
                            pointsShort: pointsShort,
                            errOver: errOver,
                          ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Points: $points',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total Errors: $errs',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      await ProgressManager.instance.resetState();
                      state.restart();
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Specific message on how many points and errors needed to win
  static String _lossMessage({required int pointsShort, required int errOver}) {
    final parts = <String>[];
    if (pointsShort > 0) parts.add('You need $pointsShort more Points');
    if (errOver > 0) parts.add('Reduce errors by $errOver');
    if (parts.isEmpty) return 'Keep training to sharpen your skills.';
    return parts.join(' • ');
  }
}

// kept my old animation but lets change it up (could add like a grill animation that would be cool)

class ServeJudgeAnimation extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onCompleted;

  const ServeJudgeAnimation({
    super.key,
    this.duration = const Duration(milliseconds: 1600),
    this.onCompleted,
  });

  @override
  State<ServeJudgeAnimation> createState() => _ServeJudgeAnimationState();
}

class _ServeJudgeAnimationState extends State<ServeJudgeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  late final Animation<double> _plateSlide;
  late final Animation<double> _plateScale;
  late final Animation<double> _plateTilt;

  late final List<Animation<double>> _steamRise;
  late final List<Animation<double>> _steamFade;
  late final List<Animation<double>> _steamDrift;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);

    _plateSlide = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.00, 0.45, curve: Curves.easeOutCubic),
    );

    _plateScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.00, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _plateTilt =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: -0.03, end: 0.0), weight: 35),
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.03), weight: 15),
          TweenSequenceItem(tween: Tween(begin: 0.03, end: 0.0), weight: 20),
        ]).animate(
          CurvedAnimation(
            parent: _c,
            curve: const Interval(0.30, 0.80, curve: Curves.easeInOut),
          ),
        );

    Animation<double> rise(double start, double end) =>
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _c,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

    Animation<double> drift(double start, double end) =>
        Tween<double>(begin: -1.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _c,
            curve: Interval(start, end, curve: Curves.easeInOut),
          ),
        );

    _steamRise = [rise(0.30, 0.90), rise(0.38, 0.98), rise(0.46, 1.00)];
    _steamFade = [
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.30, 0.90, curve: Curves.easeInOut),
      ),
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.38, 0.98, curve: Curves.easeInOut),
      ),
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.46, 1.00, curve: Curves.easeInOut),
      ),
    ];
    _steamDrift = [drift(0.30, 0.90), drift(0.38, 0.98), drift(0.46, 1.00)];

    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        widget.onCompleted?.call();
      }
    });

    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              return SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, (1 - _plateSlide.value) * 80),
                      child: Transform.rotate(
                        angle: _plateTilt.value,
                        child: Transform.scale(
                          scale: _plateScale.value,
                          child: _PlateWidget(),
                        ),
                      ),
                    ),
                    for (int i = 0; i < 3; i++)
                      _SteamPuff(
                        rise: _steamRise[i].value,
                        fade: _steamFade[i].value,
                        drift: _steamDrift[i].value,
                        xOffset: (i - 1) * 22.0,
                      ),
                    if (_c.value > 0.75 && _c.value < 0.92) _Sparkle(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PlateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 170,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.brown.shade200, width: 6),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                color: Colors.black12,
                offset: Offset(0, 6),
              ),
            ],
          ),
        ),
        Container(
          width: 92,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF7B3F00),
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [const Color(0xFF7B3F00), Colors.brown.shade700],
            ),
          ),
          child: Center(
            child: Container(
              width: 62,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.brown.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SteamPuff extends StatelessWidget {
  final double rise;
  final double fade;
  final double drift;
  final double xOffset;

  const _SteamPuff({
    required this.rise,
    required this.fade,
    required this.drift,
    required this.xOffset,
  });

  @override
  Widget build(BuildContext context) {
    final dy = -90 * Curves.easeOut.transform(rise);
    final dx = 14 * drift;

    return Opacity(
      opacity: fade.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(xOffset + dx, -30 + dy),
        child: Container(
          width: 20 - 6 * rise,
          height: 16 - 4 * rise,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85 - 0.6 * rise),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(60, -40),
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
