class Validator {
  static String? validateEmail(String value) {
    //const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    //final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return 'enter_an_email';
    }
    // else if (!regExp.hasMatch(value)) {
    //   return 'enter_a_valid_email';
    // }
    else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    // if (value.length < 7) {
    //   return 'password_must_be_at_least_7_characters_long';
    // }
    if(value.isEmpty){
      return 'enter_a_password';
    }
    else {
      return null;
    }
  }

  static String? validateMobile(String value) {
    // String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    // RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    }
    // else if (!regExp.hasMatch(value)) {
    //   return 'Please enter valid mobile number';
    // }
    else if (value.length < 8) {
      return 'Phone number can\'t be greater than 8 digit';
    }
    return null;
  }

  static String? validateTrip(String value) {
    if (value.length < 3) {
      return "Trip name can\'t be null or at least 4 character";
    } else {
      return null;
    }
  }
}
