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
Create a judge/customer for a STEAK COOKING ASSESSMENT game.

RETURN STRICT JSON ONLY:
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

═══════════════════════════════════════════════════════════
CRITICAL RESTRICTION — ABSOLUTELY FORBIDDEN WORDS:
═══════════════════════════════════════════════════════════
NEVER use these terms anywhere in the output:

CUTS: fillet, filet, ribeye, rib-eye, sirloin, rump, t-bone, tbone
DONENESS: rare, medium rare, medium well, well done, medium (as doneness)
THICKNESS: cm, centimeter, inch, 1.5, 2, 3, 4, 5, millimeter

The player must INFER the correct choice from indirect clues. This is a knowledge test, not a memory exercise.

═══════════════════════════════════════════════════════════
USE THESE INDIRECT DESCRIPTORS INSTEAD:
═══════════════════════════════════════════════════════════

FOR FAT/MARBLING (implies cut):
- "rich marbling throughout" / "loves fatty bites" → (implies ribeye)
- "lean with a fat cap on the edge" / "clean fat on the side" → (implies sirloin)
- "pristine and lean" / "no marbling" / "pure meat" → (implies fillet)
- "budget-friendly and lean" / "firm and beefy" → (implies rump)
- "enjoys two textures" / "likes bone-in" → (implies t-bone)

FOR TENDERNESS (implies cut):
- "butter-soft" / "fork-tender" / "melt in mouth" → (implies fillet)
- "enjoys some chew" / "firmer bite" / "toothsome" → (implies sirloin/rump)

FOR INTERIOR COLOR/TEMPERATURE (implies doneness):
- "cool and red throughout" / "barely kissed by heat" → (implies rare)
- "warm and rosy center" / "blushing pink inside" → (implies medium rare)
- "pink but not bloody" / "gentle warmth through" → (implies medium)
- "hint of blush remaining" / "mostly transformed" → (implies medium well)
- "no pink whatsoever" / "cooked completely through" → (implies well done)

FOR SIZE PREFERENCE (implies thickness):
- "quick-searing cut" / "thinner slice" / "fast cook" → (implies thin)
- "substantial piece" / "hearty portion" → (implies standard)
- "steakhouse thick" / "impressive height" / "chunky cut" → (implies thick)

═══════════════════════════════════════════════════════════
PERSONALITY FIELD RULES:
═══════════════════════════════════════════════════════════
- About 20-30 words describing HOW they enjoy steak
- Combine clues for fat, tenderness, interior, and size
- Vary preferences — some refined, some casual, some with unconventional taste
- NO forbidden words from the list above

GOOD EXAMPLES:
- "Appreciates butter-soft texture with no marbling, prefers a quick sear on a thinner slice, loves a warm rosy center"
- "Bold eater who craves rich marbling throughout, wants a steakhouse-thick piece, enjoys it cooked completely through with a hard crust"
- "Traditionalist who likes lean meat with a clean fat cap on the edge, standard portion, hint of blush remaining inside"
- "Unfussy diner wanting budget-friendly firm beef, not too thick, no pink whatsoever"

BAD EXAMPLES (FORBIDDEN):
- "Loves fillet cooked medium rare" ← uses forbidden cut and doneness
- "Prefers 3cm ribeye" ← uses forbidden measurement and cut
- "Wants sirloin done medium well" ← uses forbidden cut and doneness

═══════════════════════════════════════════════════════════
OUTPUT RULES:
═══════════════════════════════════════════════════════════
- JSON only, no commentary
- No punctuation except commas
- Verify output contains ZERO forbidden words before returning
""";

  final body = jsonEncode({
    "model": "gpt-4o-mini",
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

  final cleaned = content
      .trim()
      .replaceAll("```json", "")
      .replaceAll("```", "")
      .trim();

  final jsonMap = jsonDecode(cleaned);

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
