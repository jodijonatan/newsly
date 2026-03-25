import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String _apiKey = dotenv.get('GEMINI_API_KEY', fallback: '');
  
  static final _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  static Future<String> getSummary(String text) async {
    if (_apiKey.isEmpty) return "AI Summary not available (Missing API Key).";
    
    final prompt = "Summarize the following news article in 3-4 bullet points. Focus on key facts only:\n\n$text";
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? "Summary could not be generated.";
  }

  static Future<String> getSimplifiedExplanation(String text) async {
    if (_apiKey.isEmpty) return "Explanation not available (Missing API Key).";

    final prompt = "Explain this news snippet simply, as if explaining to a 10-year old:\n\n$text";
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? "Explanation could not be generated.";
  }

  static Future<String> analyzeSentiment(String text) async {
    if (_apiKey.isEmpty) return "NEUTRAL";

    final prompt = "Analyze the sentiment of this news title. Respond with only one word: POSITIVE, NEGATIVE, or NEUTRAL.\n\n$text";
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text?.trim().toUpperCase() ?? "NEUTRAL";
  }
}
