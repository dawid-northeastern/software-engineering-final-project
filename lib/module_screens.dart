import 'package:flutter/material.dart';

class ModuleScreen extends StatefulWidget {
  final String title;
  final List<String> slideTexts;
  final String questionText;
  final VoidCallback onComplete;

  const ModuleScreen({
    super.key,
    required this.title,
    required this.slideTexts,
    required this.questionText,
    required this.onComplete,
  });

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  int index = 0;
  String? feedback;

  void _next() {
    setState(() {
      if (index < widget.slideTexts.length) {
        index++;
        feedback = null;
      }
    });
  }

  void _back() {
    setState(() {
      if (index > 0) {
        index--;
        feedback = null;
      }
    });
  }

  void _answer(bool correct) {
    setState(() {
      if (correct) {
        feedback = 'Correct!';
      } else {
        feedback = 'Incorrect';
      }
    });
  }

  void _skip() {
    // temporary skip action for testing: mark complete and close
    widget.onComplete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Slide ${index + 1} of ${widget.slideTexts.length + 1}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
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
                      child: _buildSlide(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (index < widget.slideTexts.length)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: index > 0 ? _back : null,
                          child: const Text('Back'),
                        ),
                        Row(
                          children: [
                            FilledButton(
                              onPressed: _next,
                              child: const Text('Next'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: _skip,
                              child: const Text('Skip'),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (feedback != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              feedback!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.brown.shade100,
                              ),
                            ),
                          ),
                        if (feedback == 'Correct!')
                          FilledButton(
                            onPressed: () {
                              widget.onComplete();
                              Navigator.pop(context);
                            },
                            child: const Text('Module Complete - Return'),
                          )
                        else
                          const SizedBox.shrink(),
                        // temporary skip option on final screen as well
                        TextButton(
                          onPressed: _skip,
                          child: const Text('Skip Module'),
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

  Widget _buildSlide() {
    if (index < widget.slideTexts.length) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Slide ${index + 1}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(widget.slideTexts[index]),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Quick Check',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(widget.questionText),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              _answer(true);
            },
            child: const Text('Option A (sample correct)'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              _answer(false);
            },
            child: const Text('Option B (sample incorrect)'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              _answer(false);
            },
            child: const Text('Option C (sample incorrect)'),
          ),
        ],
      );
    }
  }
}
