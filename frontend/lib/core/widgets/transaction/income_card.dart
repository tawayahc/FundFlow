import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:intl/intl.dart';

class IncomeCard extends StatefulWidget {
  final Bank? selectedBank;
  final TextEditingController amount;
  final TextEditingController note;
  final DateTime selectedTime;

  const IncomeCard({
    Key? key,
    required this.selectedBank,
    required this.amount,
    required this.note,
    required this.selectedTime,
  }) : super(key: key);

  @override
  _IncomeCardState createState() => _IncomeCardState();
}

class _IncomeCardState extends State<IncomeCard> {
  late String _amountText;
  late String _noteText;

  @override
  void initState() {
    super.initState();

    // Initialize with default or existing values
    _amountText = widget.amount.text.isNotEmpty ? widget.amount.text : '0.00';
    _noteText = widget.note.text.isNotEmpty ? widget.note.text : 'โน๊ต';

    // Add listeners for dynamic updates
    widget.amount.addListener(_updateAmountText);
    widget.note.addListener(_updateNoteText);
  }

  @override
  void dispose() {
    widget.amount.removeListener(_updateAmountText);
    widget.note.removeListener(_updateNoteText);
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return DateFormat('yyyy-MM-dd').format(time);
  }

  void _updateAmountText() {
    setState(() {
      //_amountText = widget.amount.text;
      _amountText = widget.amount.text.isNotEmpty ? widget.amount.text : '0.00';
    });
  }

  void _updateNoteText() {
    setState(() {
      _noteText = widget.note.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      height: 90,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.selectedBank?.color ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.selectedBank?.name ?? 'ธนาคาร',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: widget.selectedBank != null
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Text(
                '฿ $_amountText',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.selectedBank != null
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _noteText,
                style: TextStyle(
                  fontSize: 10,
                  color: widget.selectedBank != null
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Text(
                _formatTime(widget.selectedTime),
                style: TextStyle(
                  fontSize: 10,
                  color: widget.selectedBank != null
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
