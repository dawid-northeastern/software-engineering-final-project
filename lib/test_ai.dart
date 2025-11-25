import 'ai_service.dart';

void main() async {
  print("Testing judge...");
  final judge = await getJudge();
  print("Judge:");
  print(judge);

  print("\nTesting feedback...");
  final fb = await getFeedback(
    judge: judge,
    cut: "Ribeye",
    thickness: "Thick",
    doneness: "Medium Rare",
    method: "Pan-Seared",
  );
  print("Feedback:");
  print(fb);
}
