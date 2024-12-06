// image_upload_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_event.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fundflow/core/widgets/global_padding.dart';

class ImageUploadPage extends StatelessWidget {
  const ImageUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDialogShowing = false;

    void showModal(BuildContext context, String text,
        {Color? color, Icon? icon}) {
      if (isDialogShowing) {
        return;
      }

      isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.1),
        builder: (BuildContext context) {
          return CustomModal(text: text, color: color, icon: icon);
        },
      ).then((_) {
        isDialogShowing = false;
      });
    }

    return BlocConsumer<ImageBloc, ImageState>(
      listener: (context, state) {
        if (state is ImageOperationFailure) {
          showModal(context, 'Error: ${state.error}');
        } else if (state is ImageSendSuccess) {
          showModal(context, 'Images uploaded successfully',
              color: Colors.green, icon: const Icon(Icons.check));
        }
      },
      builder: (context, state) {
        List<XFile> images = [];
        bool isLoading = false;

        if (state is ImageLoadSuccess) {
          images = state.images;
        } else if (state is ImageLoadInProgress) {
          isLoading = true;
        }

        return GlobalPadding(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                iconSize: 20,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: const Text('อัพโหลดรูปภาพ'),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    // Upload Slip Button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () {
                          context.read<ImageBloc>().add(PickImages());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1,
                              )),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'เลือกรูปภาพ',
                                style: TextStyle(
                                    fontSize: 18.0, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Display Selected Images
                    Expanded(
                      child: images.isEmpty
                          ? (isLoading
                              ? const Center(
                                  child: Text("Images are uploading..."),
                                )
                              : const Center(
                                  child: Text('No images selected'),
                                ))
                          : ListView.builder(
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Image.file(
                                    File(images[index].path),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(images[index].name),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      context
                                          .read<ImageBloc>()
                                          .add(RemoveImage(index));
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: AppColors.darkBlue, // ปุ่มสีน้ำเงินเข้ม
                  ),
                  onPressed: (images.isEmpty || isLoading)
                      ? null
                      : () {
                          context
                              .read<ImageBloc>()
                              .add(SendImages(images: images));
                        },
                  child: const Text(
                    'ยืนยัน',
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xffffffff)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
