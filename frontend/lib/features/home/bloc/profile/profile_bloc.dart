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
        final cashBox = await profileRepository.getCashBox();

        emit(ProfileLoaded(
          userProfile: profile,
          cashBox: cashBox['cashBox'],
        ));
      } catch (error) {
        emit(ProfileError(message: "Failed to load profile"));
      }
    });
  }
}
