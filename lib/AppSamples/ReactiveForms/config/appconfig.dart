import 'package:newsee/Utils/validators_api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppConfig {
  final loginFormgroup = FormGroup({
    'username': FormControl(
      value: 'AGRI1124',
      validators: [
        Validators.required,
        Validators.delegate(checkForRestrictedSpecialChars),
      ],
    ),
    'password': FormControl(
      value: 'laps',
      validators: [
        Validators.required,
        // Validators.pattern(AppConstants.PATTERN_SPECIALCHAR),
      ],
    ),
  });
}
