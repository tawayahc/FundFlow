// ui/income_form.dart
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_input_inkwell.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_dropdown.dart';
import 'package:fundflow/core/widgets/custom_input_transaction_box.dart';
import 'package:fundflow/core/widgets/transaction/income_card.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/utils/bank_mapper.dart';
import '../model/form_model.dart';

class IncomeForm extends StatefulWidget {
  final void Function(CreateIncomeData) onSubmit;

  IncomeForm({
    Key? key,
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
  bool _hasShownNoBanksDialog = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showNoBanksDialog() {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 268,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/home');
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 22,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'คุณยังไม่มีบัญชีธนาคาร\nกรุณากดเพิ่มธนาคาร',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
                //const SizedBox(height: 16),
                Container(
                  height: 40,
                  width: 200,
                  margin: const EdgeInsets.all(9),
                  child: ElevatedButton(
                    onPressed: () {
                      //Navigator.pop(context);
                      Navigator.pushNamed(context, '/addBank');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor:
                          const Color(0xFF41486D), // ปุ่มสีน้ำเงินเข้ม
                    ),
                    child: const Text(
                      'เพิ่มธนาคาร',
                      style: TextStyle(fontSize: 16, color: Color(0xffffffff)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectDate() {
    BottomPicker.date(
      pickerTitle: const Text(
        'Select Date',
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
        'Select Time',
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
    return BlocListener<BankBloc, BankState>(
      listener: (context, state) {
        if (state is BanksLoaded && !_hasShownNoBanksDialog) {
          if (state.banks.isEmpty) {
            _hasShownNoBanksDialog = true;
            _showNoBanksDialog();
          }
        }
      },
      child: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    List<Bank> banks = [];

    return BlocBuilder<BankBloc, BankState>(builder: (context, state) {
      if (state is BanksLoaded) {
        banks = state.banks
            .map((homeBank) => BankMapper.toTransactionBank(homeBank))
            .toList();
      }
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
              items: banks,
              onChanged: (Bank? newValue) {
                setState(() {
                  _selectedBank = newValue;
                });
              },
              displayItem: (Bank bank) => bank.name,
              validator: (value) =>
                  value == null ? 'Please select a bank' : null,
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
    });
  }
}
