import 'package:flutter/material.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatefulWidget {
  final Category? selectedCategory;
  final TextEditingController amount;
  final TextEditingController note;
  final DateTime selectedTime;

  const ExpenseCard({
    Key? key,
    required this.selectedCategory,
    required this.amount,
    required this.note,
    required this.selectedTime,
  }) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<ExpenseCard> {
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
        color: widget.selectedCategory?.color ?? Colors.grey.shade200,
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
                widget.selectedCategory?.name ?? 'หมวดหมู่',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: widget.selectedCategory != null
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Text(
                '฿ $_amountText',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.selectedCategory != null
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
                  color: widget.selectedCategory != null
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Text(
                _formatTime(widget.selectedTime),
                style: TextStyle(
                  fontSize: 10,
                  color: widget.selectedCategory != null
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
