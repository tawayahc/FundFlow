import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/transaction/model/form_model.dart';
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
  void dispose() {
    _amountController.dispose();
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
    if (widget.banks.length < 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child:
                  Text('At least two banks are required to make a transfer .'),
            ),
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
          // From Bank Dropdown
          DropdownButtonFormField<Bank>(
            value: _fromBank,
            hint: const Text('Select From Bank'),
            items: fromBankOptions.map((Bank bank) {
              return DropdownMenuItem<Bank>(
                value: bank,
                child: Text(bank.name),
              );
            }).toList(),
            onChanged: (Bank? newValue) {
              setState(() {
                _fromBank = newValue;
                // Reset toBank if it's the same as fromBank
                if (_toBank != null && _toBank!.id == _fromBank!.id) {
                  _toBank = null;
                }
              });
            },
            validator: (value) =>
                value == null ? 'Please select a from bank' : null,
            decoration: const InputDecoration(
              labelText: 'From Bank',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // To Bank Dropdown
          DropdownButtonFormField<Bank>(
            value: _toBank,
            hint: const Text('Select To Bank'),
            items: toBankOptions.map((Bank bank) {
              return DropdownMenuItem<Bank>(
                value: bank,
                child: Text(bank.name),
              );
            }).toList(),
            onChanged: (Bank? newValue) {
              setState(() {
                _toBank = newValue;
                // Reset fromBank if it's the same as toBank
                if (_fromBank != null && _fromBank!.id == _toBank!.id) {
                  _fromBank = null;
                }
              });
            },
            validator: (value) =>
                value == null ? 'Please select a to bank' : null,
            decoration: const InputDecoration(
              labelText: 'To Bank',
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
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// Model class for Transfer Data

