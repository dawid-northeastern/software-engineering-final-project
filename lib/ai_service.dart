import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey =
    "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";

Future<String> getJudge() async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    "model": "gpt-5-nano", // $0.05 per 1M tokens
    "messages": [
      {
        "role": "user",
        "content": """
Create a fictional steak customer.

Return ONLY JSON:
{
  "name": "...",
  "age": ...,
  "profession": "...",
  "fat_preference": "...",
  "tenderness": "...",
  "crust": "...",
  "doneness": "..."
}
""",
      },
    ],
    "temperature": 1.0,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"].trim();
  } else {
    throw Exception('Failed to fetch judge');
  }
}

Future<String> getFeedback({
  required String judge,
  required String cut,
  required String thickness,
  required String doneness,
  required String method,
}) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    "model": "gpt-4o-mini",
    "messages": [
      {
        "role": "user",
        "content":
            """
Judge:
$judge

User choices:
Cut: $cut
Thickness: $thickness
Doneness: $doneness
Cooking Method: $method

Return ONLY JSON:
{
  "score": ...,
  "explanation": "...",
  "tip": "..."
}
""",
      },
    ],
    "temperature": 0.7,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"].trim();
  } else {
    throw Exception('Failed to fetch feedback');
  }
}
