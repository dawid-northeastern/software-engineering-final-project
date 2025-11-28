import 'package:shared_preferences/shared_preferences.dart';

// NEW - Game State Management System
// It tracks the XP and number of errors
// The game is 'won' meaning the training and test is passed if
// the XP is > 50 and errors < 5
// This can definitely be changed

class ProgressLoadResult {
  final Set<String> completedModules;
  final int? judgeIndex;
  final bool judgeUnlocked;
  ProgressLoadResult({
    required this.completedModules,
    this.judgeIndex,
    required this.judgeUnlocked,
  });
}

class ProgressManager {
  ProgressManager._();
  static final ProgressManager instance = ProgressManager._();

  static const _xpKey = 'progress_xp';
  static const _errorsKey = 'progress_errors';
  static const _completedKey = 'progress_completed_modules';
  static const _judgeIndexKey = 'progress_judge_index';
  static const _judgeUnlockedKey = 'progress_judge_unlocked';

  int experience = 0;
  int errors = 0;
  bool judgeUnlocked = false;

  void addCorrect({int count = 1}) {
    experience += 15 * count;
  }

  void addIncorrect({int count = 1}) {
    errors += count;
    experience -= 10 * count;
    if (experience < 0) experience = 0;
  }

  Future<void> saveState({
    Iterable<String> completedModules = const [],
    int? judgeIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, experience);
    await prefs.setInt(_errorsKey, errors);
    await prefs.setStringList(_completedKey, completedModules.toList());
    if (judgeIndex != null) {
      await prefs.setInt(_judgeIndexKey, judgeIndex);
    }
    await prefs.setBool(_judgeUnlockedKey, judgeUnlocked);
  }

  Future<ProgressLoadResult> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    experience = prefs.getInt(_xpKey) ?? 0;
    errors = prefs.getInt(_errorsKey) ?? 0;
    final completed = prefs.getStringList(_completedKey) ?? const [];
    final judgeIndex = prefs.getInt(_judgeIndexKey);
    judgeUnlocked = prefs.getBool(_judgeUnlockedKey) ?? false;
    return ProgressLoadResult(
      completedModules: completed.toSet(),
      judgeIndex: judgeIndex,
      judgeUnlocked: judgeUnlocked,
    );
  }

  Future<void> resetState() async {
    experience = 0;
    errors = 0;
    judgeUnlocked = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_xpKey);
    await prefs.remove(_errorsKey);
    await prefs.remove(_completedKey);
    await prefs.remove(_judgeIndexKey);
    await prefs.remove(_judgeUnlockedKey);
  }
}
