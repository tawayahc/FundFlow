import 'package:bloc/bloc.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';
import 'change_avatar_event.dart';
import 'change_avatar_state.dart';

class ChangeAvatarBloc extends Bloc<ChangeAvatarEvent, ChangeAvatarState> {
  final SettingsRepository settingsRepository;

  ChangeAvatarBloc({required this.settingsRepository})
      : super(ChangeAvatarInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<FetchAvatarPresets>(_onFetchAvatarPresets);
    on<ChangeAvatar>(_onChangeAvatar);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<ChangeAvatarState> emit) async {
    emit(UserProfileLoading());
    try {
      final userProfile = await settingsRepository.fetchUserProfile();
      emit(UserProfileLoaded(userProfile));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onFetchAvatarPresets(
      FetchAvatarPresets event, Emitter<ChangeAvatarState> emit) async {
    emit(AvatarPresetsLoading());
    try {
      final avatars = await settingsRepository.fetchAvatarPresets();
      emit(AvatarPresetsLoaded(avatars));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> _onChangeAvatar(
      ChangeAvatar event, Emitter<ChangeAvatarState> emit) async {
    try {
      await settingsRepository.changeAvatar(event.newAvatarUrl);
      emit(AvatarChangeSuccess());
    } catch (e) {
      emit(AvatarChangeFailure(e.toString()));
    }
  }
}
