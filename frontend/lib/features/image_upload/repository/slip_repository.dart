import 'package:fundflow/app.dart';
import 'package:photo_manager/photo_manager.dart';
import 'image_repository.dart';
import 'package:image_picker/image_picker.dart';

class SlipRepository {
  final ImageRepository _imageRepository;

  final List<String> slipIdentifiers = ["K PLUS", "MAKE by KBank"];

  SlipRepository() : _imageRepository = ImageRepository();

  // Fetch all images from the specified albums
  Future<List<AssetEntity>> fetchAllImages(
      {required List<String> albumNames}) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      throw Exception('Permission to access gallery is denied.');
    }

    // Calculate the date range for the last 30 days
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 30));

    final List<AssetPathEntity> allAlbums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(),
        createTimeCond: DateTimeCond(
          min: startDate,
          max: endDate,
        ),
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );

    logger.d(
        'All Albums: ${allAlbums.map((album) => album.name).toList().join(', ')}');

    // Filter albums based on the identifiers
    final List<AssetPathEntity> matchingAlbums = allAlbums.where((album) {
      return albumNames.any((identifier) => album.name == identifier);
    }).toList();

    if (matchingAlbums.isEmpty) {
      logger.w('No albums found matching the specified identifiers.');
      throw Exception('No albums found matching the specified identifiers.');
    }

    logger.d(
        'Matching Albums: ${matchingAlbums.map((album) => album.name).toList().join(', ')}');

    List<AssetEntity> images = [];
    Set<String> uniqueImageIds = {}; // Set to track unique image IDs

    for (var album in matchingAlbums) {
      try {
        final int count = await album.assetCountAsync;

        // Fetch assets in pages to avoid memory issues
        int page = 0;
        int pageSize = 100;
        while (page * pageSize < count) {
          try {
            final List<AssetEntity> albumImages =
                await album.getAssetListPaged(page: page, size: pageSize);

            for (var image in albumImages) {
              if (!uniqueImageIds.contains(image.id)) {
                images.add(image);
                uniqueImageIds.add(image.id);
              }
            }

            page++;
          } catch (e) {
            logger.e('Failed to fetch assets for album ${album.name}: $e');
            break;
          }
        }
      } catch (e) {
        logger.e('Failed to get asset count for album ${album.name}: $e');
      }
    }

    logger.d('Fetched ${images.length} images from matching albums.');
    return images;
  }

  // Get slip images from the specified albums
  Future<List<XFile>> getSlipImages() async {
    try {
      final images = await fetchAllImages(albumNames: slipIdentifiers);

      // Convert AssetEntity to XFile
      List<XFile> slipImages = [];
      for (var image in images) {
        final file = await image.file;
        if (file != null) {
          slipImages.add(XFile(file.path));
        }
      }

      logger.d('Detected ${slipImages.length} slip images.');
      return slipImages;
    } catch (e) {
      logger.e('Error fetching slip images: $e');
      rethrow;
    }
  }

  // Upload detected slip images with categories
  Future<void> uploadDetectedSlips() async {
    final slipImages = await getSlipImages();
    if (slipImages.isEmpty) {
      logger.w('No slip images detected.');
      throw Exception('No slip images detected.');
    }

    // Upload using ImageRepository
    await _imageRepository.uploadImages(
      images: slipImages,
    );
  }
}
