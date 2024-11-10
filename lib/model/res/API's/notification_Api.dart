import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendNotification(String title, String message) async {
  const String appId = 'f8d63d16-4294-4e67-8dc6-32ce553af11f';
  const String restApiKey = 'OWQzOTQ4MzItZDdmZC00YTk2LWI2MGEtNWRmMjY1OGFkOTE4';

  final response = await http.post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Basic $restApiKey',
    },
    body: jsonEncode({
      'app_id': appId,
      'included_segments': ['All'], // You can customize this to target specific users or segments
      'headings': {'en': title},
      'contents': {'en': message},
    }),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully!');
  } else {
    print('Failed to send notification. Status code: ${response.statusCode}');
    print('Response: ${response.body}');
  }
}
