import 'package:firebase_database/firebase_database.dart';

class RealtimeDBSerice {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  RealtimeDBSerice();
  void read() {
    DatabaseReference ref = db.ref();
  }

  void write() async {
    DatabaseReference ref = db.ref();
    try {
      await ref.set({
        "name": "John",
        "age": 18,
        "address": {"line1": "100 Mountain View"}
      });
    } catch (e) {
      print("Error while writing to the RTDB: $e");
    }
  }
}
