import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoanDetailsPage extends StatelessWidget {
  final String title;

  LoanDetailsPage(String s, {super.key, required this.title});

  final form = FormGroup({
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
    'loanproduct': FormControl<String>(validators: [Validators.required]),
    'loanamount': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loan Details"),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchableDropdown(
                controlName: 'maincategory',
                label: 'Main Category',
                items: ['Car Loan', 'Cash Loan', 'Combo Car Loan', 'Corporate Car Loan',
                'Corporate Home Loan', 'Educational Loan', 'Gold Loan', 'Gold Loan Staff Retail',
                'Housing Loan', 'Loan Against Deposit for Individuals', 'Loan Against Deposit for Non Individuals',
                'MSME PM VISHWAKARMA', 'PMSVANIDHI WC', 'pensioner Loan', 'Property Loan', 'Rent Loan',
                'Security Loan', 'Shopper Loan', 'Simplified Gold Loan', 'Simplified Gold Loan MSME',
                'Staff Housing Loan', 'Staff Overdraft New','Staff Vehicle Loan','Term Loan UCO','Term Loan UCO Bank',
                'Topup Housing Loan', 'Two Wheeler Loan','UCO Electric Vehicle Combo Car Loan','UCO Electric Vehicle EV Loan',
                'UCO Elite Two Wheeler Loan','UCO GTRE Loan', 'UCO Suryodhaya Loan Scheme',
                'West Bengal Bhabishyat Credit crad WBBCC Scheme', 'Working Capital UCO Bank'],
              ),
              Dropdown(
                controlName: 'subcategory',
                label: 'Sub Category',
                items: ['', ''],
              ),
              Dropdown(
                controlName: 'loanproduct',
                label: 'Loan Product',
                items: ['', ''],
              ),
              IntegerTextField('loanamount', 'Loan Amount Requested(₹)'),
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
