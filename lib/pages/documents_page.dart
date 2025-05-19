import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DocumentsPage extends StatelessWidget {
  final String title;

  DocumentsPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'applicanttype': FormControl<String>(validators: [Validators.required]),
    'document': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Document Details"),
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
                items: [''],
              ),
              Dropdown(
                controlName: 'document',
                label: 'Document Classification',
                items: ['Aadhar Card', 'Driving License', 'PAN Card', 'Voter ID'],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                },
                child: Text("ADD"),
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      final tabController = DefaultTabController.of(context);
                      if (tabController.index < tabController.length - 1) {
                        tabController.animateTo(tabController.index + 1);
                      }
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                  child: Text('Next'),
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