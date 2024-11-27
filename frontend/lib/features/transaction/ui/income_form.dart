// ui/income_form.dart
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_input_inkwell.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_dropdown.dart';
import 'package:fundflow/core/widgets/custom_input_transaction_box.dart';
import 'package:fundflow/core/widgets/transaction/income_card.dart';
import '../model/bank_model.dart';
import '../model/form_model.dart';

class IncomeForm extends StatefulWidget {
  final void Function(CreateIncomeData) onSubmit;

  List<Bank> banks;

  IncomeForm({
    Key? key,
    required this.banks,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _IncomeFormState createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _formKey = GlobalKey<FormState>();
  Bank? _selectedBank;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectDate() {
    BottomPicker.date(
      pickerTitle: const Text(
        'เลือกวันที่',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: const EdgeInsets.all(20),
      dismissable: true,
      initialDateTime: _selectedDate,
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(2100),
      onSubmit: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      onClose: () {
        Navigator.of(context).pop();
      },
      buttonSingleColor: AppColors.primary,
    ).show(context);
  }

  Time _timeOfDayToTime(TimeOfDay timeOfDay) {
    return Time(hours: timeOfDay.hour, minutes: timeOfDay.minute);
  }

  void _selectTime() {
    BottomPicker.time(
      pickerTitle: const Text(
        'เลือกเวลา',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: const EdgeInsets.all(20),
      dismissable: true,
      initialTime:
          _selectedTime != null ? _timeOfDayToTime(_selectedTime!) : Time.now(),
      onSubmit: (newTime) {
        setState(() {
          _selectedTime = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
        });
      },
      onClose: () {
        Navigator.of(context).pop();
      },
      buttonSingleColor: AppColors.primary,
    ).show(context);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = CreateIncomeData(
        bank: _selectedBank!,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        time: _selectedTime,
        note: _noteController.text,
      );
      widget.onSubmit(data);
      _formKey.currentState!.reset();
      setState(() {
        _selectedBank = null;
        _selectedDate = DateTime.now();
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          IncomeCard(
              selectedBank: _selectedBank,
              amount: _amountController,
              note: _noteController,
              selectedTime: _selectedDate),
          const SizedBox(
            height: 16,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'ระบุธนาคาร',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Bank Dropdown
          CustomDropdown<Bank>(
            prefixIcon: Icons.balance,
            hintText: 'กรอกธนาคาร',
            selectedItem: _selectedBank,
            items: widget.banks,
            onChanged: (Bank? newValue) {
              setState(() {
                _selectedBank = newValue;
              });
            },
            displayItem: (Bank bank) => bank.name,
            validator: (value) => value == null ? 'กรุณาเลือกธนาคาร' : null,
          ),

          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'ระบุจำนวนเงิน',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CustomInputTransactionBox(
            labelText: 'ระบุจำนวนเงิน',
            prefixIcon: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFFD0D0D0),
            ),
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณาระบุจำนวนเงิน';
              }
              if (double.tryParse(value) == null) {
                return 'กรุณาระบุจำนวนเงินที่ถูกต้อง';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'ระบุวันที่',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CustomInputInkwell(
              prefixIcon: Icons.calendar_today,
              labelText: "${_selectedDate.toLocal()}".split(' ')[0],
              onTap: _selectDate),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'ระบุเวลา',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Time Picker
          CustomInputInkwell(
              prefixIcon: Icons.access_time,
              labelText: _selectedTime != null
                  ? _selectedTime!.format(context)
                  : 'กรอกเวลา(ไม่จำเป็น)',
              onTap: _selectTime),

          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'โน้ตเพิ่มเติม',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CustomInputTransactionBox(
              labelText: 'โน้ต',
              prefixIcon: const Icon(
                Icons.note,
                color: Color(0xFFD0D0D0),
              ),
              controller: _noteController),
          const SizedBox(height: 16),

          CustomButton(text: 'ยืนยัน', onPressed: _submit)
        ],
      ),
    );
  }
}
