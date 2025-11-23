import 'package:flutter/material.dart';

class CutsScreen extends StatefulWidget {
  const CutsScreen({super.key});

  @override
  State<CutsScreen> createState() => _CutsScreenState();
}

class _CutsScreenState extends State<CutsScreen> {
  int index = 0;
  String? feedback;

  void _next() {
    setState(() {
      if (index < 2) {
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
                  const Text(
                    'Understanding Cuts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Slide ${index + 1} of 3',
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
                  if (index < 2)
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
                                color: Colors.brown.shade100,
                              ),
                            ),
                          ),
                        if (feedback == 'Correct!')
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Module Complete - Return'),
                          )
                        else
                          const SizedBox.shrink(),
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
    if (index == 0) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intro',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('SAMPLE TEXT for cuts module - slide 1.'),
        ],
      );
    } else if (index == 1) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('SAMPLE TEXT for cuts module - slide 2.'),
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
          const Text('SAMPLE QUESTION for cuts module.'),
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

class ThicknessScreen extends StatefulWidget {
  const ThicknessScreen({super.key});

  @override
  State<ThicknessScreen> createState() => _ThicknessScreenState();
}

class _ThicknessScreenState extends State<ThicknessScreen> {
  int index = 0;
  String? feedback;

  void _next() {
    setState(() {
      if (index < 2) {
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
                  const Text(
                    'Thickness',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Slide ${index + 1} of 3',
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
                  if (index < 2)
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
                                color: Colors.brown.shade100,
                              ),
                            ),
                          ),
                        if (feedback == 'Correct!')
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Module Complete - Return'),
                          )
                        else
                          const SizedBox.shrink(),
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
    if (index == 0) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intro',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('SAMPLE TEXT for thickness module - slide 1.'),
        ],
      );
    } else if (index == 1) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('SAMPLE TEXT for thickness module - slide 2.'),
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
          const Text('SAMPLE QUESTION for thickness module.'),
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

class DonenessScreen extends StatefulWidget {
  const DonenessScreen({super.key});

  @override
  State<DonenessScreen> createState() => _DonenessScreenState();
}

class _DonenessScreenState extends State<DonenessScreen> {
  int index = 0;
  String? feedback;

  void _next() {
    setState(() {
      if (index < 2) {
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
                  const Text(
                    'Doneness',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Slide ${index + 1} of 3',
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
                  if (index < 2)
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
                                color: Colors.brown.shade100,
                              ),
                            ),
                          ),
                        if (feedback == 'Correct!')
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Module Complete - Return'),
                          )
                        else
                          const SizedBox.shrink(),
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
    if (index == 0) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intro',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('SAMPLE TEXT for doneness module - slide 1.'),
        ],
      );
    } else if (index == 1) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('SAMPLE TEXT for doneness module - slide 2.'),
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
          const Text('SAMPLE QUESTION for doneness module.'),
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

class CookingScreen extends StatefulWidget {
  const CookingScreen({super.key});

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  int index = 0;
  String? feedback;

  void _next() {
    setState(() {
      if (index < 2) {
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
                  const Text(
                    'Cooking Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Slide ${index + 1} of 3',
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
                  if (index < 2)
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
                                color: Colors.brown.shade100,
                              ),
                            ),
                          ),
                        if (feedback == 'Correct!')
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Module Complete - Return'),
                          )
                        else
                          const SizedBox.shrink(),
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
    if (index == 0) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intro',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('SAMPLE TEXT for cooking method module - slide 1.'),
        ],
      );
    } else if (index == 1) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('SAMPLE TEXT for cooking method module - slide 2.'),
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
          const Text('SAMPLE QUESTION for cooking method module.'),
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
