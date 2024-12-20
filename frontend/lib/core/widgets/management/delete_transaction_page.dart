import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_state.dart';
import 'package:fundflow/features/home/models/transaction.dart';

class DeleteTransactionPage extends StatelessWidget {
  final Transaction transaction;

  const DeleteTransactionPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionDeleted) {
          Navigator.of(context).pop();
        } else if (state is TransactionsLoadError) {
          _showModal(context, 'ลบรายการไม่สำเร็จ');
        }
      },
      child: Dialog(
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
                    color: AppColors.darkGrey,
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
              const Text(
                'คุณต้องการที่จะลบ\nรายการนี้หรือไม่',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<TransactionBloc>(context).add(
                    DeleteTransaction(transactionId: transaction.id),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C5C),
                  minimumSize: const Size(213, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text(
                  'ลบรายการ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
