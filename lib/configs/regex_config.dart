class RegexConfig {
  static final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com');
  static final RegExp _phoneRegex = RegExp(r'^(\+[0-9]{1,3})?[0-9]{10,}$');
  static bool isEmail(String email){
    return _emailRegex.hasMatch(email);
  }
  static bool isPhone(String phone){
    return _phoneRegex.hasMatch(phone);
  }
}
