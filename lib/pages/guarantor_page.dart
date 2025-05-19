import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class GuarantorPage extends StatelessWidget {
  final String title;

  GuarantorPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'applicanttype': FormControl<String>(validators: [Validators.required]),
    'title': FormControl<String>(validators: [Validators.required]),
    'firstname': FormControl<String>(validators: [Validators.required]),
    'lastname': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(validators: [Validators.required]),
    'networth': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Additional Borrowers"),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Dropdown(
                controlName: 'applicanttype',
                label: 'Applicant Type',
                items: ['Co-Applicant', 'Guarantor'],
              ),
              SearchableDropdown(
                controlName: 'title',
                label: 'Title',
                items: ['COLONEL', 'DR', 'LT.COL', 'M/S', 'MAJOR', 'MASTER(MINOR)',
                'MESSERS', 'MIGRATION DEFAULT', 'MISS', 'MOHAMMAD', 'MR', 'MRS', 
                'MX', 'SHEIKH', 'SIR'],
              ),
              IntegerTextField('firstname', 'First Name'),
              IntegerTextField('lastname', 'Last Name'),
              IntegerTextField('mobilenumber', 'Mobile Number'), 
              IntegerTextField('networth', 'Networth of the Applicant(₹)'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}