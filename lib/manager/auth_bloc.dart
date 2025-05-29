import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../domain/usecases/firebase_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({required this.checkAuthStatusUseCase}) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final isAuthenticated = await checkAuthStatusUseCase(
        userId: event.userId,
        userPassword: event.userPassword,
      );
      if (isAuthenticated) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure());
      }
    });
  }
}
