import 'package:formz/formz.dart';

/// Validation errors for the [Email] [FormzInput]
enum EmailValidationError {
  /// Generic invalid error
  invalid;

  String text() {
    if (this == EmailValidationError.invalid) return 'Email is invalid';
    return '';
  }
}

/// {@template email}
/// Form input for an email input
/// {@endtemplate}
class Email extends FormzInput<String, EmailValidationError> {
  /// {@macro email}
  const Email.pure() : super.pure('');

  /// {@macro email}
  const Email.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}
