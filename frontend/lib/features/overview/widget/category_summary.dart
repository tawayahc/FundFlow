// features/overview/ui/routine_summary_item.dart
import 'package:flutter/material.dart';

class CategorySummaryItem extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  final double totalIn;
  final double totalOut;
  final double balance;

  const CategorySummaryItem({
    Key? key,
    required this.categoryName,
    required this.categoryColor,
    required this.totalIn,
    required this.totalOut,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color balanceColor = balance >= 0 ? Colors.green : Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
          color: Colors.white, 
          width: 1.0, 
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,  
            blurRadius: 3,    
            offset: Offset(0, 0),  
          )
        ]
      ),
      //margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Container(
                    color: categoryColor, 
                    width: 23,                 
                    height: 23,                
                  ),
                ),
                SizedBox(width: 3.5,),
                Text(
                  categoryName,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("เงินออกทั้งหมด",
                    style: TextStyle(color: Colors.grey[600])),
                Text(totalOut.toStringAsFixed(2),
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            /*const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("สรุปยอด", style: TextStyle(color: Colors.grey[600])),
                Text(balance.toStringAsFixed(2),
                    style: TextStyle(
                        color: balanceColor, fontWeight: FontWeight.bold)),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
