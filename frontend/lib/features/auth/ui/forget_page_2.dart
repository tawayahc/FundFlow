import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';


class VerificationPage extends StatelessWidget {
  VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าก่อนหน้า (SettingsPage)
          },
        ),
        centerTitle: true,
        title: const Text(
          'ลืมรหัสผ่าน',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            const Text(
              'ใส่รหัสยืนยันตัวตน 6 หลัก',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A5A5A)),
            ),
            const SizedBox(height: 12),
             Center(
            child: Container(
                width: 328,
                child: Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: TextField(
                          onChanged: (value) => {
                            if(value.length == 1){
                              FocusScope.of(context).nextFocus()
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),// กำหนด corner radius = 10
                            ),
                          ),

                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: TextField(
                          onChanged: (value) => {
                            if(value.length == 1){
                              FocusScope.of(context).nextFocus()
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // กำหนด corner radius = 10
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: TextField(
                          onChanged: (value) => {
                            if(value.length == 1){
                              FocusScope.of(context).nextFocus()
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              // กำหนด corner radius = 10
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: TextField(
                          onChanged: (value) => {
                            if(value.length == 1){
                              FocusScope.of(context).nextFocus()
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // กำหนด corner radius = 10
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: TextField(
                          onChanged: (value) => {
                            if(value.length == 1){
                              FocusScope.of(context).nextFocus()
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // กำหนด corner radius = 10
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: TextField(
                          onChanged: (value) => {
                            if(value.length == 1){
                              FocusScope.of(context).nextFocus()
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // กำหนด corner radius = 10
                            ),
                          ),
                        ),
                      )
                    ],
                  ),)
            ),
        ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forget3');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: const Color(0xFF41486D), // ปุ่มสีน้ำเงินเข้ม
                ),
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
  );
}
}