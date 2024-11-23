// image_repository.dart
import 'package:archive/archive_io.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:fundflow/features/transaction/model/transaction.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class ImageRepository {
  final ImagePicker _picker;
  final Dio _dio;
  final Logger _logger;

  ImageRepository({
    ImagePicker? picker,
    Dio? dio,
    Logger? logger,
  })  : _picker = picker ?? ImagePicker(),
        _dio = dio ?? Dio(),
        _logger = logger ?? Logger() {
    // Configure Dio interceptors if needed
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.d("REQUEST[${options.method}] => PATH: ${options.path}");
          _logger.d("Headers: ${options.headers}");
          _logger.d("Data: ${options.data}");
          return handler.next(options); // continue
        },
        onResponse: (response, handler) {
          _logger
              .d("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
          return handler.next(response); // continue
        },
        onError: (DioException e, handler) {
          _logger
              .e("ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}");
          if (e.response != null) {
            _logger.e("Response data: ${e.response?.data}");
          }
          return handler.next(e); //continue
        },
      ),
    );
  }

  Future<List<XFile>?> pickImages() async {
    try {
      final images = await _picker.pickMultiImage();
      return images;
    } catch (e) {
      throw Exception('Failed to pick images: $e');
    }
  }

  Future<List<TransactionResponse>> uploadImages({
    required List<XFile> images,
    required List<Category> categories,
  }) async {
    if (images.isEmpty) {
      throw Exception('No images selected to send.');
    }

    if (categories.isEmpty) {
      throw Exception('No categories selected.');
    }

    // Create an Archive object
    Archive archive = Archive();

    for (var image in images) {
      String fileName = image.path.split('/').last;
      List<int> fileBytes = await image.readAsBytes();

      // Add each image as an ArchiveFile to the archive
      archive.addFile(ArchiveFile(fileName, fileBytes.length, fileBytes));
    }

    // Encode the archive as a ZIP file
    List<int>? zipBytes = ZipEncoder().encode(archive);

    // Save the ZIP file to a temporary directory
    String tempDir = Directory.systemTemp.path;
    String zipFilePath = '$tempDir/images.zip';
    File zipFile = File(zipFilePath);
    await zipFile.writeAsBytes(zipBytes!);

    // Create a MultipartFile from the ZIP file
    MultipartFile zipMultipartFile = await MultipartFile.fromFile(
      zipFile.path,
      filename: 'images.zip',
      contentType: MediaType('application', 'zip'),
    );

    // Serialize categories to JSON
    String categoriesJson = jsonEncode(
      categories.map((c) => {'id': c.id, 'name': c.name}).toList(),
    );

    // Create FormData and add the ZIP file and categories
    FormData formData = FormData.fromMap({
      'zip_file':
          zipMultipartFile, // Adjust the field name as per your server requirements
      'categories': categoriesJson, // Send categories as JSON string
    });

    try {
      // FIXME: Update with your server's URL
      final response = await _dio.post(
        'http://10.0.2.2:3000/upload', // Update to your server's endpoint
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) =>
              status! < 500, // Accept all status codes below 500
        ),
      );

      if (response.statusCode == 200) {
        // Parse transaction data
        List<dynamic> responseData = response.data;
        List<TransactionResponse> transactions = responseData
            .map((transactionJson) =>
                TransactionResponse.fromJson(transactionJson))
            .toList();
        return transactions;
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to send images';
        throw Exception('Failed to send images: $errorMsg');
      }
    } on DioException catch (e) {
      _logger.e('DioException: ${e.message}');
      if (e.response != null) {
        _logger.e('Response data: ${e.response?.data}');
      }
      throw Exception('DioException: ${e.message}');
    } catch (e) {
      _logger.e('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    } finally {
      // Clean up the temporary ZIP file
      if (await zipFile.exists()) {
        await zipFile.delete();
      }
    }
  }
}
