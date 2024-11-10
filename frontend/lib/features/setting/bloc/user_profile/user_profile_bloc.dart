// user_profile_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fundflow/features/setting/models/change_email_request.dart';
import 'package:fundflow/features/setting/models/user_profile.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final SettingsRepository repository;

  UserProfileBloc({required this.repository}) : super(UserProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<SubmitChangeEmailEvent>(_onSubmitChangeEmail);
    on<FetchAvatarPresets>(_onFetchAvatarPresets);
    on<ChangeAvatar>(_onChangeAvatar);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final userProfile = await repository.fetchUserProfile();
      emit(UserProfileLoaded(userProfile));
    } catch (e) {
      emit(UserProfileError(error: e.toString()));
    }
  }

  Future<void> _onSubmitChangeEmail(
      SubmitChangeEmailEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      await repository
          .changeEmail(ChangeEmailRequest(newEmail: event.newEmail));
      final updatedProfile = await repository.fetchUserProfile();
      emit(UserProfileLoaded(updatedProfile));
    } catch (e) {
      emit(UserProfileError(error: e.toString()));
    }
  }

  Future<void> _onFetchAvatarPresets(
      FetchAvatarPresets event, Emitter<UserProfileState> emit) async {
    emit(AvatarPresetsLoading());
    try {
      final avatars = await repository.fetchAvatarPresets();
      emit(AvatarPresetsLoaded(avatars));
    } catch (e) {
      emit(UserProfileError(error: e.toString()));
    }
  }

  Future<void> _onChangeAvatar(
      ChangeAvatar event, Emitter<UserProfileState> emit) async {
    try {
      await repository.changeAvatar(event.newAvatarUrl);
      emit(AvatarChangeSuccess());
    } catch (e) {
      emit(AvatarChangeFailure(e.toString()));
    }
  }
}
