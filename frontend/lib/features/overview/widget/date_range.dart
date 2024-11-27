import 'package:flutter/material.dart';

class DateRangeDropdown extends StatefulWidget {
  final void Function(DateTimeRange?)? onDateRangeSelected;

  const DateRangeDropdown({Key? key, required this.onDateRangeSelected})
      : super(key: key);

  @override
  _DateRangeDropdownState createState() => _DateRangeDropdownState();
}

class _DateRangeDropdownState extends State<DateRangeDropdown> {
  String? _selectedDateRange;

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _selectedDateRange =
                '${picked.start.toLocal().toShortDateString()} - ${picked.end.toLocal().toShortDateString()}';
          });
          widget.onDateRangeSelected!(picked);
        }
      },
      child: Container(
        width: 143,
        height: 30,
        //padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: EdgeInsets.only(left: 2, right: 2, top: 10, bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey)
          ),
          //borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDateRange ?? 'เลือกช่วงเวลา',
              style: TextStyle(
                fontSize: 11,
                color: _selectedDateRange == null ? Colors.grey : Colors.black,
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: Colors.grey,
              size: 15
            ),
          ],
        ),
      ),
    );
  }
}

extension DateTimeFormatting on DateTime {
  String toShortDateString() {
    const monthNames = {
      1: 'ม.ค.',
      2: 'ก.พ.',
      3: 'มี.ค.',
      4: 'เม.ย.',
      5: 'พ.ค.',
      6: 'มิ.ย.',
      7: 'ก.ค.',
      8: 'ส.ค.',
      9: 'ก.ย.',
      10: 'ต.ค.',
      11: 'พ.ย.',
      12: 'ธ.ค.',
    };
    return '${this.day.toString().padLeft(2, '0')} ${monthNames[this.month]}';
  }
}
