import '../repositories/firebase_repository.dart';

class CheckAuthStatusUseCase {
  final FirebaseRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<bool> call({
    required String userId,
    required String userPassword,
  }) async {
    return await repository.checkAuthStatus(
      userId: userId,
      userPassword: userPassword,
    );
  }
}
