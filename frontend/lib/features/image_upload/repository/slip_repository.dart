// repository/slip_repository.dart
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:fundflow/features/transaction/repository/transaction_repository.dart';
import 'package:fundflow/utils/api_helper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'image_repository.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';

class SlipRepository {
  final ImageRepository _imageRepository;
  final TransactionAddRepository _transactionAddRepository;
  final Logger _logger;

  // Predefined slip identifiers
  final List<String> slipIdentifiers = [
    "K PLUS",
    "MAKE BY KBANK"
  ]; // Ensure consistent casing

  SlipRepository({
    ImageRepository? imageRepository,
    TransactionAddRepository? transactionAddRepository,
    Logger? logger,
  })  : _imageRepository = imageRepository ?? ImageRepository(),
        _transactionAddRepository = transactionAddRepository ??
            TransactionAddRepository(
                apiHelper:
                    //FIXME: Replace with actual API base URL
                    ApiHelper(baseUrl: 'https://api.fundflow.dev')),
        _logger = logger ?? Logger();

  // Fetch all images from the gallery
  Future<List<AssetEntity>> fetchAllImages() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      throw Exception('Permission to access gallery is denied.');
    }

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(),
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );

    if (albums.isEmpty) {
      _logger.w('No albums found in the gallery.');
      return [];
    }

    List<AssetEntity> images = [];
    for (var album in albums) {
      try {
        // Get the asset count using the asynchronous method and await it
        final int count = await album.assetCountAsync;

        // Fetch assets in pages to avoid memory issues
        int page = 0;
        int pageSize = 100;
        while (page * pageSize < count) {
          try {
            final List<AssetEntity> albumImages =
                await album.getAssetListPaged(page: page, size: pageSize);
            images.addAll(albumImages);
            page++;
          } catch (e) {
            _logger.e('Failed to fetch assets for album ${album.name}: $e');
            break;
          }
        }
      } catch (e) {
        _logger.e('Failed to get asset count for album ${album.name}: $e');
        // Fallback: try to fetch some assets without count
        try {
          final List<AssetEntity> albumImages = await album.getAssetListRange(
              start: 0, end: 10000); // Reasonable maximum
          images.addAll(albumImages);
        } catch (fallbackError) {
          _logger.e(
              'Fallback fetch failed for album ${album.name}: $fallbackError');
        }
      }
    }

    return images;
  }

  // Filter images based on predefined identifiers
  Future<List<XFile>> filterSlipImages() async {
    List<XFile> slipImages = [];
    try {
      final images = await fetchAllImages();

      for (var image in images) {
        // Implement more sophisticated image analysis if needed
        // Currently, filter based on file name containing the identifiers
        final fileName = await image.titleAsync;
        if (fileName != null &&
            slipIdentifiers.any(
                (id) => fileName.toUpperCase().contains(id.toUpperCase()))) {
          final file = await image.file;
          if (file != null) {
            slipImages.add(XFile(file.path));
          }
        }
      }
    } catch (e) {
      _logger.e('Error filtering slip images: $e');
      rethrow;
    }
    return slipImages;
  }

  // Fetch categories from TransactionAddRepository
  Future<List<Category>> getCategories() async {
    return await _transactionAddRepository.fetchCategories();
  }

  // Upload detected slip images with categories
  Future<void> uploadDetectedSlips(List<Category> categories) async {
    final slipImages = await filterSlipImages();
    if (slipImages.isEmpty) {
      _logger.w('No slip images detected.');
      throw Exception('No slip images detected.');
    }

    // Upload using ImageRepository
    await _imageRepository.uploadImages(
      images: slipImages,
      categories: categories,
    );
  }

  // Manual upload slips with categories
  Future<void> manualUploadSlips({
    required List<XFile> images,
    required List<Category> categories,
  }) async {
    if (images.isEmpty) {
      throw Exception('No images selected to send.');
    }

    if (categories.isEmpty) {
      throw Exception('No categories selected.');
    }

    // Upload using ImageRepository
    await _imageRepository.uploadImages(
      images: images,
      categories: categories,
    );
  }
}
