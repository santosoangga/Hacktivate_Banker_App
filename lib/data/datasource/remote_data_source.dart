import 'package:firebase_database/firebase_database.dart';

class RemoteDataSource{
  Future<bool> checkAuthStatus({required String userId, required String userPassword}) async {
    try {
      final snapshot =
          await FirebaseDatabase.instance
              .ref('users')
              .child(userId)
              .child('password')
              .get();

      if (snapshot.exists) {
        final password = snapshot.value as String?;
        return password != null && password == userPassword;
      } else {
        return false;
      }
    }
    catch (e) {
      return false;
    }
  }
}
