import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_input_inkwell.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_dropdown.dart';
import 'package:fundflow/core/widgets/custom_input_transaction_box.dart';
import 'package:fundflow/core/widgets/transaction/expense_card.dart';
import '../model/bank_model.dart';
import '../model/category_model.dart';
import '../model/form_model.dart';

class ExpenseForm extends StatefulWidget {
  final void Function(CreateExpenseData) onSubmit;
  final CreateExpenseData? initialData;
  // Remove final from banks and categories
  List<Bank> banks;
  List<Category> categories;

  ExpenseForm({
    Key? key,
    required this.banks,
    required this.categories,
    required this.onSubmit,
    this.initialData,
  }) : super(key: key);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  Bank? _selectedBank;
  Category? _selectedCategory;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.banks.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showNoBanksDialog());
    }
    if (widget.categories.isEmpty) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _showNoCategoriesDialog());
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // FIX: Dialog with no banks
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

  void _showNoCategoriesDialog() {
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
                  'คุณยังไม่มีบัญชีหมมวดหมู่\nกรุณากดเพิ่มหมวดหมู่',
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
                      Navigator.pushNamed(context, '/addCategory');
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
      final data = CreateExpenseData(
        bank: _selectedBank!,
        category: _selectedCategory!,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        time: _selectedTime,
        note: _noteController.text,
      );
      widget.onSubmit(data);
      _formKey.currentState!.reset();
      setState(() {
        _selectedBank = null;
        _selectedCategory = null;
        _selectedDate = DateTime.now();
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFormEnabled = widget.categories.isNotEmpty;
    /*if (widget.banks.isEmpty) {
      return Center(
        child: Column(
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
        ),
      );
    }

    if (widget.categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No categories available.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addCategory');
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      );
    }*/
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            ExpenseCard(
              selectedCategory: _selectedCategory,
              amount: _amountController,
              note: _noteController,
              selectedTime: _selectedDate,
            ),
            const SizedBox(
              height: 16,
            ),
            // Bank Dropdown
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
              validator: (value) =>
                  value == null ? 'Please select a bank' : null,
            ),
            /*DropdownButtonFormField<Bank>(
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
            ),*/
            const SizedBox(height: 16),
            // Category Dropdown
            const Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'ระบุหมวดหมู่',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomDropdown<Category>(
              prefixIcon: Icons.category,
              hintText: 'ระบุหมวดหมู่',
              selectedItem: _selectedCategory,
              items: widget.categories,
              onChanged: (Category? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              /*isFormEnabled
                  ? (Category? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  : null, */
              displayItem: (Category category) => category.name,
              validator: (value) =>
                  value == null ? 'Please select a category' : null,
            ),
            /*DropdownButtonFormField<Category>(
              value: _selectedCategory,
              hint: const Text('Select Category'),
              items: widget.categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: isFormEnabled
                  ? (Category? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  : null,
              validator: (value) =>
                  value == null ? 'Please select a category' : null,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),*/
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
            /*InkWell(
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
            ),*/
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
            CustomInputInkwell(
                prefixIcon: Icons.access_time,
                labelText: _selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'กรอกเวลา(ไม่จำเป็น)',
                onTap: _selectTime),
            /*InkWell(
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
            ),*/
            const SizedBox(height: 16),
            // Note Field
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
            /*TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
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
            onPressed: isFormEnabled ? _submit : null,
            child: const Text('ยันยัน'),
          ),
        ],
            ),*/
            const SizedBox(height: 16),
            CustomButton(text: 'ยืนยัน', onPressed: _submit),
            /*ElevatedButton(
              onPressed: isFormEnabled ? _submit : null,
              child: const Text('Submit'),
            ),*/
          ],
        ),
      ),
    );
  }
}
