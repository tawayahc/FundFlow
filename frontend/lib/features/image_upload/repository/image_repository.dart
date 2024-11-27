// image_repository.dart
import 'package:archive/archive_io.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/transaction/model/transaction.dart';
import 'package:fundflow/utils/api_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ImageRepository {
  final ImagePicker _picker;
  final ApiHelper _apiHelper;

  // Note: URL for the AI server
  ImageRepository()
      : _picker = ImagePicker(),
        _apiHelper = ApiHelper(baseUrl: 'http://10.0.2.2:3000/');

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
  }) async {
    if (images.isEmpty) {
      throw Exception('No images selected to send.');
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

    // Create FormData and add the ZIP file and categories
    FormData formData = FormData.fromMap({
      'file':
          zipMultipartFile, // Adjust the field name as per your server requirements
    });

    try {
      // FIXME: Update with your server's URL
      final response = await _apiHelper.dio.post(
        '/get_transaction', // Update to your server's endpoint
        data: formData,
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
      logger.e('DioException: ${e.message}');
      if (e.response != null) {
        logger.e('Response data: ${e.response?.data}');
      }
      throw Exception('DioException: ${e.message}');
    } catch (e) {
      logger.e('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    } finally {
      // Clean up the temporary ZIP file
      if (await zipFile.exists()) {
        await zipFile.delete();
      }
    }
  }
}
