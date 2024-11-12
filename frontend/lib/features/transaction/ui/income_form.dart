// ui/income_form.dart
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
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
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectDate() {
    BottomPicker.date(
      pickerTitle: Text(
        'Select Date',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: EdgeInsets.all(20),
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
      pickerTitle: Text(
        'Select Time',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: EdgeInsets.all(20),
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
    if (widget.banks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No banks available.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-bank');
              },
              child: const Text('Add Bank'),
            ),
          ],
        ),
      );
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Bank Dropdown
          DropdownButtonFormField<Bank>(
            value: _selectedBank,
            hint: const Text('Select Bank'),
            items: widget.banks.map((Bank bank) {
              return DropdownMenuItem<Bank>(
                value: bank,
                child: Text(bank.name),
              );
            }).toList(),
            onChanged: (Bank? newValue) {
              setState(() {
                _selectedBank = newValue;
              });
            },
            validator: (value) => value == null ? 'Please select a bank' : null,
            decoration: const InputDecoration(
              labelText: 'Bank',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Amount Field
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Date Picker
          InkWell(
            onTap: _selectDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_selectedDate.toLocal()}".split(' ')[0],
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Time Picker
          InkWell(
            onTap: _selectTime,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Select Time',
                  ),
                  const Icon(Icons.access_time),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Note Field
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}