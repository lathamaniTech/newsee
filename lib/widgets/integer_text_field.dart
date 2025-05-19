
/*
 @created on : May 16,2025
 @author : Akshayaa 
 Description : A reusable text input field for accepting only integer values,integrated with the reactive forms package.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IntegerTextField extends StatelessWidget {
  final String controlName;
  final String label;

  const IntegerTextField(this.controlName, this.label);

  /* Returns the maximum number of digits allowed. If the field is for 'mobilenumber',
  restricted to 10 digits.*/ 

  int getMaxLength() {
    if (controlName == 'mobilenumber') return 10;
    if (controlName == 'pincode') return 6;
    if (controlName == 'aadharno') return 12;
    return 15;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(getMaxLength()),
        ],
        decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        ),
        validationMessages: {
        ValidationMessage.required: (error) => '$label is required',
        ValidationMessage.pattern: (error) => 'Valid $label is required'
      },
      ),
    );
  }
}
