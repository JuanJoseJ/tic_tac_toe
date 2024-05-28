import 'package:flutter/foundation.dart';

class MainProvider with ChangeNotifier {
  String? _multiPlayerGameId;

  String? get multiPlayerGameId => _multiPlayerGameId;

  void setGameId(String? newId) {
    _multiPlayerGameId = newId;
    notifyListeners();
  }

  bool _xIsLocalPlayer = true;

  bool get xIsLocalPlayer => _xIsLocalPlayer;

  void setXIsLocalPlayer(bool setLocalPlayer) {
    _xIsLocalPlayer = setLocalPlayer;
    notifyListeners();
  }
  

  String? _adversatyId;

  String? get adversaryId => _adversatyId;

  void setAdversaryId(String? newAdversaryId){
    _adversatyId = newAdversaryId;
  }
}
