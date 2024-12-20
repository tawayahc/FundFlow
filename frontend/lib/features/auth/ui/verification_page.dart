import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_bloc.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_event.dart';
import 'package:fundflow/features/auth/bloc/repassword/repassword_state.dart';
import 'package:fundflow/features/auth/models/otp_verify_request.dart';
import 'package:fundflow/features/auth/ui/reset_page.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  // Controllers for each OTP digit
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  // FocusNodes for each OTP digit
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // To store the full OTP
  String _otp = '';

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Method to collect OTP from all fields
  void _collectOTP() {
    _otp = _controllers.map((controller) => controller.text).join();
  }

  bool _isDialogShowing = false;

  void _showModal(BuildContext context, String text) {
    if (_isDialogShowing) {
      return;
    }

    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (BuildContext context) {
        return CustomModal(text: text);
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  // Method to handle OTP submission
  void _verifyOTP() {
    _collectOTP();
    if (_otp.length < 6) {
      _showModal(context, 'กรุณาใส่รหัส OTP ทั้งหมด');

      return;
    }
    // Dispatch VerifyOTPEvent with collected OTP
    BlocProvider.of<RepasswordBloc>(context).add(
      VerifyOTPEvent(
        OTPVerifyRequest(email: widget.email, otp: _otp),
      ),
    );
  }

// Widget for each OTP input field
  Widget _buildOTPField(int index) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.icon, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.icon, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.darkBlue, width: 3),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          }
        },
        onSubmitted: (_) {
          if (index == 5) {
            _verifyOTP();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าก่อนหน้า (ForgetPage)
          },
        ),
        centerTitle: true,
        title: const Text(
          'ยืนยันรหัส OTP',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<RepasswordBloc, RepasswordState>(
          listener: (context, state) {
            if (state is RepasswordOTPVerified) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPasswordPage(email: widget.email),
                ),
              );
            } else if (state is RepasswordFailure) {
              _showModal(context, 'รหัส OTP ไม่ถูกต้อง');
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'ใส่รหัสยืนยันตัวตน 6 หลัก',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: 328,
                  child: Form(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          List.generate(6, (index) => _buildOTPField(index)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<RepasswordBloc, RepasswordState>(
                builder: (context, state) {
                  bool isLoading = state is RepasswordLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : CustomButton(
                                text: 'ยืนยัน', onPressed: _verifyOTP)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
