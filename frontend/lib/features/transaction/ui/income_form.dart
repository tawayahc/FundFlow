// ui/income_form.dart
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_input_box.dart';
import 'package:fundflow/core/widgets/custom_input_inkwell.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_dropdown.dart';
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

    if (widget.banks.isEmpty) {
      print(widget.banks.isEmpty);
      WidgetsBinding.instance.addPostFrameCallback((_) => _showNoBanksDialog());
    }
  }

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
              /*border: Border.all(
                color: Color(0xFF41486D),
                width: 2,
              ),*/
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
                  margin: EdgeInsets.all(9),
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
    /*if (widget.banks.isEmpty) {
      return Container(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF41486D),
                width: 2
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: const Icon(
                    Icons.warning
                  ),
                ),
                Container(
                  child: Text(
                    'คุณยังไม่มีบัญชีธนาคาร\nกรุณากดเพิ่มธนาคาร'
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-bank');
                  },
                  child: const Text('เพิ่มธนาคาร'),
                ),
              ],
            ),
          ),
        )
        /*Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No banks available.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addBank');
              },
              child: const Text('Add Bank'),
            ),
          ],
        ),*/
      );
    }*/
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
            validator: (value) => value == null ? 'Please select a bank' : null,
          ),
          /*Container(
            height: 40,
            width: 382,
            child: DropdownButtonFormField<Bank>(
              value: _selectedBank,
              hint: const Text('กรอกธนาคาร',
              style: TextStyle(
                color: Color(0xFFD0D0D0),
                fontSize: 14,
                fontWeight: FontWeight.normal
              )),
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
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                //labelText: 'Bank',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Color(0xFFD0D0D0),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D0D0),
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF41486D),
                  )
                )
              ),
            ),
          ),*/
          const SizedBox(height: 16),
          // Amount Field
          /*TextFormField(
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
          ),*/
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
          CustomInputBox(
            labelText: 'ระบุจำนวนเงิน',
            prefixIcon: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFFD0D0D0),
            ),
            controller: _amountController,
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
          /*Container(
            height: 40,
            width: 382,
            child: InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFFD0D0D0),
                    ),
                  //labelText: 'Bank',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Color(0xFFD0D0D0),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFD0D0D0),
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF41486D),
                    )
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*const Icon(
                      Icons.calendar_today,
                      color: Color(0xFFD0D0D0),
                    ),*/
                    Text(
                      "${_selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        color: Color(0xFFD0D0D0),
                        fontSize: 14,
                        fontWeight: FontWeight.normal
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),*/
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
          /*Container(
            height: 40,
            width: 382,
            child: InkWell(
              onTap: _selectTime,
              child: InputDecorator(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    prefixIcon: const Icon(
                      Icons.access_time,
                      color: Color(0xFFD0D0D0),),
                    //labelText: 'Bank',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color(0xFFD0D0D0),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFD0D0D0),
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF41486D),
                      )
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Select Time',
                      style: const TextStyle(
                        color: Color(0xFFD0D0D0),
                        fontSize: 14,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                    //const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
          ),*/

          const SizedBox(height: 16),
          // Note Field
          /*TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(),
            ),
          ),*/
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
          CustomInputBox(
              labelText: 'โน้ต',
              prefixIcon: const Icon(
                Icons.note,
                color: Color(0xFFD0D0D0),
              ),
              controller: _noteController),
          const SizedBox(height: 16),

          /*ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),*/
          CustomButton(text: 'ยืนยัน', onPressed: _submit)
        ],
      ),
    );
  }
}
