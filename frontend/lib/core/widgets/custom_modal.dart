import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final String text;

  const CustomModal({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF414141), // Use AppColors.darkGrey if defined
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Icon(
              Icons.warning,
              color: Color(0xFFFF5C5C),
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF414141), // Use AppColors.darkGrey if defined
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5C5C),
                minimumSize: const Size(213, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text(
                'ตกลง',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
