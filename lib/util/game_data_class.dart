import 'dart:convert'; // Required for jsonEncode and jsonDecode

class GameData {
  /// The game works like this:
  /// At the beginning p1 starts a game. A gId and a pId are assigned. The game starts
  /// when p2 joins, in which case the p2Id is assigned. The game ends when the p1IsWinner
  /// is assigned.
  final String gameId;
  final String player1Id;
  List<String> board;
  bool xIsPlaying;
  String? player2Id;
  bool? p1IsWinner;
  bool isTie;

  GameData(
    this.gameId, {
    required this.player1Id,
    this.board = const [],
    this.xIsPlaying = true,
    this.isTie = false,
    this.player2Id,
    this.p1IsWinner,
  });

  // Factory constructor to create a GameData instance from a map
  factory GameData.fromMap(Map<dynamic, dynamic> map) {
    return GameData(
      map['gameId'],
      player1Id: map['player1Id'],
      board: List<String>.from(map['board'] ?? []),
      xIsPlaying: map['xIsPlaying'] ?? false,
      player2Id: map['player2Id'],
      p1IsWinner: map['p1IsWinner'],
    );
  }

  // Factory constructor to create a GameData instance from JSON
  factory GameData.fromJson(String source) {
    return GameData.fromMap(jsonDecode(source));
  }

  // Convert GameData instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'player1Id': player1Id,
      'board': board,
      'xIsPlaying': xIsPlaying,
      'player2Id': player2Id,
      'p1IsWinner': p1IsWinner,
    };
  }

  // Convert GameData instance to JSON
  String toJson() {
    return jsonEncode(toMap());
  }
}
