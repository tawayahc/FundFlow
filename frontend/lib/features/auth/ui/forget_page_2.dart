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
    body: Center( // Wrap the Column with Center to center it
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
        children: [
          const SizedBox(height: 71),
          Container(
            width: 328,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/login'),
                          child: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        Expanded( // This will take up the remaining space and center the text
                          child: Text(
                            'Forget ',
                            textAlign: TextAlign.center, // Center the text inside the Expanded widget
                            style: TextStyle(
                              fontSize: 16, // Adjust the font size if needed
                            ),
                          ),
                        ),
                      ],
                    )
            ),
          ),

          const SizedBox(height: 71),
          Container(
            width: 328, // Sets the container width
            alignment: Alignment.topLeft,
            child: Text(
                    'ใส่รหัสยืนยันตัวตน 6 หลัก',
                    style: TextStyle(
                      color: Color(0xFF41486D),
                      fontSize: 18, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                  ),
                  textAlign: TextAlign.left,
                ),
          ),
          Container(
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
                    ),
                  )
                ],
              ),)
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/forget3');
              }, 
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF41486D),
                fixedSize: const Size(328, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22), 
                  ),
                  ),
                  label: Text(
                    'ยืนยัน',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                      ),)),
        ],
      ),
    ),
  );
}
}