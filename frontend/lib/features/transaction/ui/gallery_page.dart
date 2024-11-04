// lib/features/gallery/ui/gallery_page.dart

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with WidgetsBindingObserver {
  int _photoCount = 0;
  bool _isLoading = true;
  bool _limitedAccessHandled = false; // Flag to prevent multiple dialogs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermissionAndCountPhotos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check permissions and update photo count
      _requestPermissionAndCountPhotos();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _requestPermissionAndCountPhotos() async {
    // Request extended permissions
    PermissionState result = await PhotoManager.requestPermissionExtend();

    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      // Permission granted (authorized or limited), proceed to count photos
      int count = await _countGalleryPhotos();
      setState(() {
        _photoCount = count;
        _isLoading = false;
      });

      if (result == PermissionState.limited && !_limitedAccessHandled) {
        _handleLimitedAccess();
        _limitedAccessHandled = true; // Prevent showing the dialog again
      }
    } else {
      // Permission denied, handle accordingly
      setState(() {
        _isLoading = false;
      });
      _showPermissionDeniedDialog();
    }
  }

  Future<int> _countGalleryPhotos() async {
    // Fetch the "All Photos" album
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: true,
    );

    AssetPathEntity? allPhotosAlbum;
    for (var album in albums) {
      if (album.isAll) {
        allPhotosAlbum = album;
        break;
      }
    }

    if (allPhotosAlbum == null) {
      return 0;
    }

    int count = await allPhotosAlbum.assetCountAsync;
    return count;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Denied'),
        content: Text('Please grant gallery access to count your photos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              PhotoManager.openSetting();
              Navigator.of(context).pop();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _handleLimitedAccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limited Access'),
        content: Text(
            'You have granted limited access to your photos. Would you like to allow full access?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Not Now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              PhotoManager.presentLimited();
            },
            child: Text('Update Access'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery Photo Count'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Text(
                'Total Photos: $_photoCount',
                style: TextStyle(fontSize: 24),
              ),
            ),
    );
  }
}
