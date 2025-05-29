abstract class FirebaseRepository {
  Future<bool> checkAuthStatus({
    required String userId,
    required String userPassword,
  });
}
