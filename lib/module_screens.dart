import 'package:flutter/material.dart';

class ModuleScreen extends StatefulWidget {
  final String title;
  final List<String> slideTexts;
  final List<String>?
  slideImages; // NEW - now slides also has image of the steaks, cuts, pans, boards
  final String questionText;
  final VoidCallback onComplete;

  const ModuleScreen({
    super.key,
    required this.title,
    required this.slideTexts,
    required this.questionText,
    required this.onComplete,
    this.slideImages,
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
      feedback = correct
          // Emojis might be nice for the design (?) - keep or not? - we could add them to many other places
          // and they work on any device (iOS, android, website)
          ? 'Correct! 🎯'
          : 'Not quite – review the slides and try again.';
    }); // removed points from training modules
    // Navigator.of(context).pop() - goes back to the main training screen
    // this is nice becuase the user can review slides until the the .pop()
    if (correct) {
      widget.onComplete();
      Navigator.of(context).pop();
      return;
    }

    // goes back to the main training screen without marking the module complete
    // as the answer was incorrect
    if (!correct) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSlides = widget.slideTexts.length + 1; // +1 for quick check

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
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Slide ${index + 1} of $totalSlides',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  // Card with slide content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6).withOpacity(0.97),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.brown.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(child: _buildSlide()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Navigation / Complete
                  if (index < widget.slideTexts.length)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: index > 0 ? _back : null,
                          child: const Text('Back'),
                        ),
                        FilledButton(
                          onPressed: _next,
                          child: const Text('Next'),
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
                                fontWeight: FontWeight.w600,
                                color: feedback == 'Correct! 🎯'
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ),
                        if (feedback == 'Correct! 🎯')
                          FilledButton(
                            onPressed: () {
                              widget.onComplete();
                              Navigator.pop(context);
                            },
                            child: const Text('Module complete – back to menu'),
                          ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              index = 0;
                              feedback = null;
                            });
                          },
                          child: const Text('Review slides again'),
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
      final String? imagePath =
          (widget.slideImages != null && index < widget.slideImages!.length)
          ? widget.slideImages![index]
          : null;
      final double? imageHeight = imagePath == null
          ? null
          : (MediaQuery.of(context).size.height * 0.45).clamp(220.0, 420.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath != null && imageHeight != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            'Slide ${index + 1}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            widget.slideTexts[index],
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      );
    } else {
      final options = [
        (label: 'Option A', isCorrect: true),
        (label: 'Option B', isCorrect: false),
        (label: 'Option C', isCorrect: false),
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Quick Check',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            widget.questionText,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _answer(true),
            child: const Text('Option A'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => _answer(false),
            child: const Text('Option B'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => _answer(false),
            child: const Text('Option C'),
          ),
        ],
      );
    }
  }
}
