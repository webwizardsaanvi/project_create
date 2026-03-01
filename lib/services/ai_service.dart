import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
    //adding API information for supabase
    static const _endpoint = "https://bmfbophytctnbtozomka.supabase.co";
    static const _anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJtZmJvcGh5dGN0bmJ0b3pvbWthIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIzMjExNTIsImV4cCI6MjA4Nzg5NzE1Mn0.C3rik1xrBtnIUQwqLH_R4EkV7eBauIF19-_7gUiKDGw";
    //stuff to send message
    static Future<String> sendMessage(List<Map<String, String>> messages) async {
      final url = Uri.parse(_endpoint);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_anonKey',
        },
        body: jsonEncode({
          "messages": messages,
        }),
      );

      if(response.statusCode != 200){
        throw Exception("AI request failed: ${response.body}");
      }

      final data = jsonDecode(response.body);
      return data["reply"];
    }
}