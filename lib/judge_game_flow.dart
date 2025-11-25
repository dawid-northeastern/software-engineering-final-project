import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final double score;

  const JudgeResult({
    required this.judge,
    required this.selection,
    required this.score,
  });
}

class ScoreEngine {
  double cutScore(Cut picked, Cut preferred) => picked == preferred ? 10 : 5;
  double thicknessScore(Thickness picked, Thickness preferred) =>
      picked == preferred ? 10 : 5;

  double donenessScore(Doneness picked, Doneness preferred) {
    final i = Doneness.values.indexOf(picked);
    final j = Doneness.values.indexOf(preferred);
    final steps = (i - j).abs();
    final score = 10 - 2.5 * steps;
    return score < 0 ? 0 : score;
  }

  double total(JudgeSelection s, JudgeProfile j) {
    return cutScore(s.cut!, j.preferredCut) +
        thicknessScore(s.thickness!, j.preferredThickness) +
        donenessScore(s.doneness!, j.preferredDoneness);
  }
}

class GameState {
  final ScoreEngine engine = ScoreEngine();
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

  void submit(JudgeSelection sel) {
    final score = engine.total(sel, current);
    results.add(JudgeResult(judge: current, selection: sel, score: score));
    index++;
  }

  double get totalScore => results.fold(0, (s, r) => s + r.score);
  double get averageScore => totalScore / judges.length;
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
  EndingArgs(this.img, this.title, this.msg, this.total, this.avg);
}

class BoardBackground extends StatelessWidget {
  final Widget child;
  const BoardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
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

class JudgeBriefScreen extends StatelessWidget {
  final GameState state;
  const JudgeBriefScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isFinished) {
      return SummaryScreen(state: state);
    }

    final j = state.current;

    return Scaffold(
      appBar: AppBar(
        title: Text('Judge ${state.index + 1}'),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: BoardBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                    state: state,
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
      Navigator.pushReplacementNamed(
        context,
        '/judge_ending',
        arguments: EndingArgs(
          'assets/ending_empty.jpg',
          '…Wait, Salad?',
          'The judges came for steak. You served salad.',
          widget.state.totalScore,
          widget.state.averageScore,
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

  void _serve() {
    widget.selection.doneness = Doneness.values[_index];

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => ServeJudgeAnimation(
        onCompleted: () {
          entry.remove();

          widget.state.submit(widget.selection);

          if (widget.state.isFinished) {
            Navigator.pushReplacementNamed(
              context,
              '/judge_summary',
              arguments: widget.state,
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              '/judge_brief',
              arguments: widget.state,
            );
          }
        },
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final labels = Doneness.values.map(labelDoneness).toList();
    final j = widget.state.current;

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
    final total = state.totalScore;
    final avg = state.averageScore;

    if (total >= 85) {
      Navigator.pushReplacementNamed(
        context,
        '/judge_ending',
        arguments: EndingArgs(
          'assets/ending_michelin.jpg',
          'Michelin Moment!',
          'You impressed everyone!',
          total,
          avg,
        ),
      );
    } else if (total >= 75) {
      Navigator.pushReplacementNamed(
        context,
        '/judge_ending',
        arguments: EndingArgs(
          'assets/ending_tripadvisor.jpg',
          'Tripadvisor Approved!',
          'Great job!',
          total,
          avg,
        ),
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/judge_ending',
        arguments: EndingArgs(
          'assets/ending_empty.jpg',
          'Room to Improve',
          'Try again for a perfect steak.',
          total,
          avg,
        ),
      );
    }
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
            const SizedBox(height: 6),
            Text('Score: ${result.score.toStringAsFixed(1)}'),
          ],
        ),
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

  const EndingScreen({
    super.key,
    required this.img,
    required this.title,
    required this.msg,
    required this.total,
    required this.avg,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(msg),
                  const SizedBox(height: 16),
                  Text('Total: ${total.toStringAsFixed(1)}'),
                  Text('Avg: ${avg.toStringAsFixed(1)}'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.popUntil(
                      context,
                      ModalRoute.withName('/home'),
                    ),
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
