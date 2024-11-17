import 'package:photo_manager/photo_manager.dart';

class PermissionService {
  static Future<bool> requestPhotoPermission() async {
    PermissionState result = await PhotoManager.requestPermissionExtend();
    return result.isAuth;
  }
}
