import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/home/repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileLoading()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await profileRepository.getUserProfile();
        final banks = await profileRepository.getBanks();

        double totalAmount = 0;
        banks['banks'].forEach((bank) {
          totalAmount += bank.amount;
        });

        emit(ProfileLoaded(
          userProfile: profile,
          totalAmount: totalAmount,
        ));
      } catch (error) {
        emit(ProfileError(message: "Failed to load profile"));
      }
    });
  }
}
