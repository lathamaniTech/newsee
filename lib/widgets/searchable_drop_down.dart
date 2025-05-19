
/*
 @created on : May 16,2025
 @author : Akshayaa 
 Description : A reusable widget that provides a searchable dropdown integrated with the reactive form.
               controlName is the name of the form control tied to this dropdown. label is displayed as the input label.
               items are the list of selectable string options.
*/

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SearchableDropdown extends StatelessWidget {
  final String controlName;
  final String label;
  final List<String> items;

  const SearchableDropdown({
    required this.controlName,
    required this.label,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<String, String>(
      formControlName: controlName,
      validationMessages: {
        ValidationMessage.required: (error) => '$label is required',
      },
      builder: (field) {
        return Padding(
          padding: const EdgeInsets.all(12),
            child: DropdownSearch<String>(
              items: items,
              selectedItem: field.value,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: label,
                  errorText: field.errorText,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: const UnderlineInputBorder(),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              onChanged: (value) => field.didChange(value),
            ),
          );
      },
    );
  }
}
