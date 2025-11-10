/*
 @created on : May 16,2025
 @author : Akshayaa 
 Description : A reusable text input field for accepting only integer values,integrated with the reactive forms package.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsee/pages/rupeeformatter.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IntegerTextField extends StatelessWidget {
  final String controlName;
  final String label;
  final bool mantatory;
  final int? maxlength;
  final int? minlength;
  final bool isRupeeFormat;
  final Key? fieldKey;
  IntegerTextField({
    this.fieldKey,
    required this.controlName,
    required this.label,
    required this.mantatory,
    this.maxlength,
    this.minlength,
    this.isRupeeFormat = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> formatters = [
      FilteringTextInputFormatter.digitsOnly,
      if (isRupeeFormat) Rupeeformatter(),
    ];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ReactiveTextField<String>(
        key: fieldKey,
        autofocus: false,
        formControlName: controlName,
        keyboardType:
            isRupeeFormat == true
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.number,
        maxLength: maxlength,
        inputFormatters: formatters,

        // [
        //   if (isRupeeFormat) Rupeeformatter(),
        //   FilteringTextInputFormatter.digitsOnly,
        // ],
        decoration: InputDecoration(
          // prefixIcon:
          // isRupeeFormat
          //     ? const Padding(
          //       padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 5.0),
          //       child: Text(
          //         '₹',
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black54,
          //         ),
          //       ),
          //     )
          //     : null,
          label: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: mantatory ? ' *' : '',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        validationMessages: {
          ValidationMessage.required: (error) => '$label is required',
          ValidationMessage.pattern: (error) => 'Valid $label is required',
          ValidationMessage.maxLength:
              (error) => 'Maximum $maxlength numbers only allowed',
          ValidationMessage.minLength:
              (error) => 'Minimum $minlength numbers required',
          ValidationMessage.max: (error) => 'Loan Amount not allowed',
        },
      ),
    );
  }
}
