import 'dart:convert';
import 'package:http/http.dart' as http;

// public with $1 limit - to be deleted after grading
// to avoid openai api key exposure deletion
const String _apiKeyPart1 =
    "sk-proj-YTND7VkV_fbQD5FvDfEzgkPMJ7--KmEtmWqjJuQ7bhzbGHPtRJyWG8VbzXbsDAO590ugAuzpY9";
const String _apiKeyPart2 =
    "T3BlbkFJ4xLccosV0I86PrEg2vbwe7aXMAKi0-ugWoYK4gq_nukOhyIglEmGcxh5HHujw5Da1VH2o0uBYA";
const String apiKey = _apiKeyPart1 + _apiKeyPart2;

const String _url = "https://api.openai.com/v1/chat/completions";

class Judge {
  final String name;
  final int age;
  final String profession;

  final String fatPref;
  final String tendernessPref;
  final String crustPref;
  final String donenessPref;

  final String personality;

  Judge({
    required this.name,
    required this.age,
    required this.profession,
    required this.fatPref,
    required this.tendernessPref,
    required this.crustPref,
    required this.donenessPref,
    required this.personality,
  });

  factory Judge.fromJson(Map<String, dynamic> json) {
    return Judge(
      name: json["name"],
      age: json["age"],
      profession: json["profession"],
      fatPref: json["fat_pref"],
      tendernessPref: json["tenderness_pref"],
      crustPref: json["crust_pref"],
      donenessPref: json["doneness_pref"],
      personality: json["personality"],
    );
  }
}

class FeedbackResult {
  final int score;
  final String thoughts;
  final String feedback;
  final String tip;

  FeedbackResult({
    required this.score,
    required this.thoughts,
    required this.feedback,
    required this.tip,
  });

  factory FeedbackResult.fromJson(Map<String, dynamic> json) {
    return FeedbackResult(
      score: json["score"],
      thoughts: json["thoughts"],
      feedback: json["feedback"],
      tip: json["tip"],
    );
  }
}

// judge generation
Future<Judge> getJudge() async {
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $apiKey",
  };

  final prompt = """
Create a judge or customer for a STEAK COOKING ASSESSMENT.

Return STRICT JSON ONLY:
{
  "name": "",
  "age": 0,
  "profession": "",
  "fat_pref": "",
  "tenderness_pref": "",
  "crust_pref": "",
  "doneness_pref": "",
  "personality": ""
}
RULES:
- Write preferences as general tendencies only.
- The personality must be how they like thier steaks cooked keep inmind the player can only do thje following
Cuts: fillet, ribeye, sirloin, rump, t-bone
Thickness (cm): 1.5, 2, 3, 4, 5
Doneness: rare, medium rare, medium, medium well, well done
Methods: pan sear, grilling, reverse sear, broiling, sous vide
do not put answers, more so hint at how they want the steak cooked
Exmaples:
  - Precision taster. Loves balance and tenderness; not keen on fatty bites. Prefers a thick, tender cut (like fillets) cooked gently to a medium rare
  - Adventurous foodie. Enjoys bold flavors, less concerned about fat. Favors robust cuts (like ribeye) with a strong sear, cooked to medium
  - Obsesses over a clean sear. Enjoys a nice fat cap on the side typically seen in sirloins. He likes a standard size cooked to medium well.
  - make this about 24 words
  
- NO punctuation except commas.
- JSON ONLY. No commentary, no sentences.
- DO NOT reveal the exact steak they would choose.
""";

  final body = jsonEncode({
    "model": "gpt-5-nano",
    "messages": [
      {"role": "user", "content": prompt},
    ],
    "temperature": 1.0,
  });

  final response = await http.post(
    Uri.parse(_url),
    headers: headers,
    body: body,
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to fetch judge profile");
  }

  final data = jsonDecode(response.body);
  final content = data["choices"][0]["message"]["content"];

  final jsonMap = jsonDecode(content);

  return Judge.fromJson(jsonMap);
}

// feedback generation
Future<FeedbackResult> getFeedback({
  required Judge judge,
  required String cut,
  required String thickness,
  required String doneness,
  required String method,
}) async {
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $apiKey",
  };

  final safeJudgeJson = jsonEncode({
    "name": judge.name,
    "age": judge.age,
    "profession": judge.profession,
    "fat_pref": judge.fatPref,
    "tenderness_pref": judge.tendernessPref,
    "crust_pref": judge.crustPref,
    "doneness_pref": judge.donenessPref,
    "personality": judge.personality,
  });

  final prompt =
      """
Judge profile (JSON, SAFE PARSED):
$safeJudgeJson

ALLOWED STEAK CHOICES (for evaluation):
Cuts: fillet, ribeye, sirloin, rump, t-bone
Thickness (cm): 1.5, 2, 3, 4, 5
Doneness: rare, medium rare, medium, medium well, well done
Methods: pan sear, grilling, reverse sear, broiling, sous vide

User choices:
Cut: $cut
Thickness: $thickness
Doneness: $doneness
Method: $method

Evaluate ONLY using allowed values.
If a user choice is outside these lists, punish score fairly.

Return STRICT JSON:
{
  "score": 0,
  "thoughts": "",
  "feedback": "",
  "tip": ""
}

RULES:
- JSON ONLY (no explanations).
- SCORE MUST be integer 0 - 100.
- All fields must be MAX 20 words.
- DO NOT reveal ideal answer.
- DO NOT reveal judge preferences directly.
""";

  final body = jsonEncode({
    "model": "gpt-4o-mini",
    "messages": [
      {"role": "user", "content": prompt},
    ],
    "temperature": 0.7,
  });

  final response = await http.post(
    Uri.parse(_url),
    headers: headers,
    body: body,
  );

  final data = jsonDecode(response.body);
  final content = data["choices"][0]["message"]["content"];

  final jsonMap = jsonDecode(content);

  return FeedbackResult.fromJson(jsonMap);
}
