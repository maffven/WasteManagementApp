class FieldValidator {
  static String validateEmail(String val) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(val)) {
      return "Enter a valid email";
    }
    return "Valid Email";
  }

  static String validatePhone(int val) {
    if (val == 0) {
      return "Enter a valid phone number";
    } else if (val <= 10) {
      return "Enter a valid phone number";
    }
    return "Valid phone number";
  }
}
