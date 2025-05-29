import '../datasources/firebase_data_source.dart';
import '../../domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImplementation implements FirebaseRepository {
  final FirebaseDataSource _firebaseDataSource;

  FirebaseRepositoryImplementation(this._firebaseDataSource);

  @override
  Future<bool> checkAuthStatus({
    required String userId,
    required String userPassword,
  }) async {
    return await _firebaseDataSource.checkAuthStatus(
      userId: userId,
      userPassword: userPassword,
    );
  }
}
