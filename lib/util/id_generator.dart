import 'dart:math';

String generateGameId() {
  const int length = 6;
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random random = Random();
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String randomString = List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  
  // Combine the timestamp and random string to form the game ID
  String gameId = '$randomString$timestamp';

  // If you want a shorter ID, you can hash the combination and take the first few characters
  return gameId.substring(0, 12);  // Adjust length as needed
}