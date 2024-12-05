import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_input_transaction_box.dart';
import 'package:fundflow/features/transaction/model/form_model.dart';
import 'package:fundflow/core/widgets/custom_input_inkwell.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_dropdown.dart';
import 'package:fundflow/core/widgets/transaction/transfer_card.dart';
import '../model/bank_model.dart';

class TransferForm extends StatefulWidget {
  final List<Bank> banks;
  final void Function(CreateTransferData) onSubmit;

  const TransferForm({Key? key, required this.banks, required this.onSubmit})
      : super(key: key);

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  Bank? _fromBank;
  Bank? _toBank;
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
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
      if (_fromBank == null) {
        return;
      }
      final data = CreateTransferData(
        fromBank: _fromBank!,
        toBank: _toBank!,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        time: _selectedTime,
      );
      widget.onSubmit(data);
      _formKey.currentState!.reset();
      setState(() {
        _fromBank = null;
        _toBank = null;
        _selectedDate = DateTime.now();
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Bank> toBankOptions = widget.banks;
    if (_fromBank != null) {
      toBankOptions =
          widget.banks.where((bank) => bank.id != _fromBank!.id).toList();
    }

    List<Bank> fromBankOptions = widget.banks;
    if (_toBank != null) {
      fromBankOptions =
          widget.banks.where((bank) => bank.id != _toBank!.id).toList();
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          TransferCard(
              fromBank: _fromBank,
              toBank: _toBank,
              amount: _amountController,
              selectedTime: _selectedDate),
          const SizedBox(
            height: 16,
          ),
          // From Bank Dropdown
          const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'ย้ายธนาคารจาก',
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
            selectedItem: _fromBank,
            items: widget.banks,
            onChanged: (Bank? newValue) {
              setState(() {
                _fromBank = newValue;
              });
            },
            displayItem: (Bank bank) => bank.name,
            validator: (value) => value == null ? 'กรุณาเลือกธนาคาร' : null,
          ),

          const SizedBox(height: 16),
          // To Bank Dropdown
          const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'ไปยังธนาคาร',
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
            selectedItem: _toBank,
            items: widget.banks,
            onChanged: (Bank? newValue) {
              setState(() {
                _toBank = newValue;
              });
            },
            displayItem: (Bank bank) => bank.name,
            validator: (value) => value == null ? 'กรุณาเลือกธนาคาร' : null,
          ),

          const SizedBox(height: 16),
          // Amount Field
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
              color: AppColors.icon,
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
          // Date Picker
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
          // Time Picker
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
          CustomButton(text: 'ยืนยัน', onPressed: _submit),
        ],
      ),
    );
  }
}
