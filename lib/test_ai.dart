// Example usage of the AI Service, this is to test and guide the implementation - Saf :)
// run with: dart run lib/test_ai.dart

import 'ai_service.dart';

void main() async {
  print("Testing judge generation...");
  print("");

  // creating the judge profile - same everytime
  final judge = await getJudge();

  print("Judge Data:");
  print("Name: ${judge.name}");
  print("Age: ${judge.age}");
  print("Profession: ${judge.profession}");
  print("Personality: ${judge.personality}");

  print("");
  print("Preferences:");
  print("Fat: ${judge.fatPref}");
  print("Tenderness: ${judge.tendernessPref}");
  print("Crust: ${judge.crustPref}");
  print("Doneness: ${judge.donenessPref}");

  print("");
  print("-----------------------------------------");
  print("Testing feedback generation...");
  print("");

  // sample user choices (replace these with the variables from the users input)
  final feedback = await getFeedback(
    judge: judge,
    cut: "Ribeye",
    thickness: "Thick",
    doneness: "Medium Rare",
    method: "Pan-Seared",
  );

  print("Feedback Result:");
  print("Score: ${feedback.score}");
  print("Thoughts: ${feedback.thoughts}");
  print("Feedback: ${feedback.feedback}");
  print("Tip: ${feedback.tip}");

  print("");
  print("DONE.");
}
