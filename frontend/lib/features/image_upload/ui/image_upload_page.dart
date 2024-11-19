import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload_bloc.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload_event.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload_state.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatelessWidget {
  const ImageUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageBloc, ImageState>(
      listener: (context, state) {
        if (state is ImageOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is ImageSendSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Images sent successfully!')),
          );
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

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 20,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: const Text('Image Upload'),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        context.read<ImageBloc>().add(PickImages());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(
                            16.0), // Padding inside the container
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // Gray color
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Center content horizontally
                          children: [
                            Icon(Icons.add, size: 24.0), // Icon
                            SizedBox(width: 8.0), // Space between icon and text
                            Text(
                              'Upload Slip',
                              style: TextStyle(fontSize: 18.0), // Text style
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: images.isEmpty
                        ? (isLoading
                            ? const Center(
                                child: Text("images are uploading..."),
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
                onPressed: images.isEmpty || isLoading
                    ? null
                    : () {
                        context.read<ImageBloc>().add(SendImages());
                      },
                child: const Text('Send'),
              ),
            ),
          ),
        );
      },
    );
  }
}
