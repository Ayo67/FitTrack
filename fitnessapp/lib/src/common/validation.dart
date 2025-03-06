import 'package:flutter/material.dart';

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter a password.";
  }
  if (value.length < 6) {
    return "Password must be at least 8 characters long.";
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "Password must contain at least one uppercase letter.";
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return "Password must contain at least one lowercase letter.";
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return "Password must contain at least one number.";
  }
 if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return "Password must contain at least one special character.";
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter an email.";
  }
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  if (!emailRegExp.hasMatch(value)) {
    return "Please enter a valid email address.";
  }
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter a name.";
  }
  if (value.length < 2) {
    return "Name must be at least 2 characters long.";
  }
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return "Name can only contain letters and spaces.";
  }
  return null;
}

String? validatePhoneNumber(String phoneNumber) {
  if (phoneNumber.isEmpty) {
    return "Phone number cannot be empty.";
  }
  final RegExp regex = RegExp(r'^\+?[0-9]{10,15}$');
  if (!regex.hasMatch(phoneNumber)) {
    return "Invalid phone number format. Please enter a valid phone number.";
  }
  return null;
}
