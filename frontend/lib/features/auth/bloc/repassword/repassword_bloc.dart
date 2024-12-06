import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_event.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_state.dart';
import 'package:fundflow/features/auth/repository/repassword_repository.dart';

class RepasswordBloc extends Bloc<RepasswordEvent, RepasswordState> {
  final RepasswordRepository repasswordRepository;

  RepasswordBloc({required this.repasswordRepository})
      : super(RepasswordInitial()) {
    on<GenerateOTPEvent>((event, emit) async {
      emit(RepasswordLoading());
      try {
        await repasswordRepository.generateOTP(event.request);
        emit(RepasswordOTPSent());
      } catch (e) {
        emit(RepasswordFailure(e.toString()));
      }
    });

    on<VerifyOTPEvent>((event, emit) async {
      emit(RepasswordLoading());
      try {
        await repasswordRepository.verifyOTP(event.request);
        emit(RepasswordOTPVerified());
      } catch (e) {
        emit(RepasswordFailure(e.toString()));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(RepasswordLoading());
      try {
        await repasswordRepository.resetPassword(event.request);
        emit(RepasswordPasswordReset());
      } catch (e) {
        emit(RepasswordFailure(e.toString()));
      }
    });
  }
}
