import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

/* 
  @author      :  karthick.d  05/06/2025
  @desc         :
      Function Logic Implementation step 1: 
      init data for typeofloan must be set at first
      setup bloc , LoanDetailsBloc<LoanDetailsEvent,LoanDetailsState>
      LoanDetailsState - should have states that serves as datasource for dropdowns
                         class LoanDetailsState 
                                List<ProductScheme> productSchemeList
                                ProductScheme selectedProductScheme 
                                List<MainCategory> mainCategoryList
                                MainCategory selectedMainCategory
                                List<SubCategory> subCategoryList
                                SubCategory selectedSubCategoryList
                                List<ProductMaster> productmasterList
                                ProductMaster selectedProduct
                                
      LoanDetailsEvent 
            -init             - this event will set initial data for typeofproduct dropdown
            -loading
            -onDropdownChange - this event will be triggered for any dropdownchange
                                optiontype - scheme - change of typeofloan dropdown
                                
                                LoanProductOptionChange({optionType:'scheme'})
                                context.read<LoanDetailsBloc>().add(LoanProductOptionChange)

                                emit(LoanProductState.copyWith())
            -onLoading        - this event handle loading progress
            

  below the json we need to set for leaddetails submission request
        "chooseProduct": {
            "mainCategory": "1",
            "subCategory": "426",
            "producrId": "10"
    },

  step 2:

  step 3:



 */
class Loan extends StatelessWidget {
  final String title;

  Loan(String s, {super.key, required this.title});

  final form = FormGroup({
    'typeofloan': FormControl<String>(validators: [Validators.required]),
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              LoanproductBloc()..add(
                LoanproductInit(loanproductState: LoanproductState.init()),
              ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Loan Details"),
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<LoanproductBloc, LoanproductState>(
          listener: (context, state) {
            print(
              'LoanProductBlocListener:: log => ${state.productSchemeList}',
            );
          },
          child: BlocBuilder<LoanproductBloc, LoanproductState>(
            builder: (context, state) {
              return ReactiveForm(
                formGroup: form,

                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SearchableDropdown<ProductSchema>(
                          controlName: 'typeofloan',
                          label: 'Type Of Loan',
                          items: state.productSchemeList,
                          onChangeListener:
                              (ProductSchema val) => context
                                  .read<LoanproductBloc>()
                                  .add(LoanProductDropdownChange()),
                        ),
                        SearchableDropdown(
                          controlName: 'maincategory',
                          label: 'Main Category',
                          items: ['Kisan Credit Card'],
                        ),
                        SearchableDropdown(
                          controlName: 'subcategory',
                          label: 'Sub Category',
                          items: ['Kisan Credit Card'],
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 3, 9, 110),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (form.valid) {
                                final tabController = DefaultTabController.of(
                                  context,
                                );
                                if (tabController.index <
                                    tabController.length - 1) {
                                  tabController.animateTo(
                                    tabController.index + 1,
                                  );
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
              );
            },
          ),
        ),
      ),
    );
  }
}
