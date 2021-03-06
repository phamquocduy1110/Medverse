class Validations {
  static String validateName(String value) {
    if (value.isEmpty) return 'Hãy nhập tên người dùng.';
    final RegExp nameExp = new RegExp(r'^[A-za-zğüşöçİĞÜŞÖÇ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Vui lòng chỉ nhập các ký tự chữ cái.';
    return null;
  }

  static String validateEmail(String value, [bool isRequried = true]) {
    if (value.isEmpty && isRequried) return 'Hãy nhập Email.';
    final RegExp nameExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (!nameExp.hasMatch(value) && isRequried) return 'Địa chỉ email không hợp lệ';
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty || value.length < 6)
      return 'Vui lòng nhập mật khẩu hợp lệ.';
    return null;
  }

  static String validateField({String value}) {
    if(value.isEmpty || RegExp(r"\s").hasMatch(value)) {
      return 'Mời bạn nhập mô tả thuốc';
    }
    return null;
  }

  static String validateDescription({String value}) {
    if (value.isEmpty) {
      return 'Trường thông tin này không được bỏ trống';
    }
    return null;
  }

  static List badWord = [
    'cc', 'fuck', 'dm', 'đệt', 'cặc', 'đụ', 'địt', 'chó', 'đẻ', 'ngu', 'mẹ', 'má', 'fa', 'kè', 'tiệt', 'cờ hó', 'dcm', 'dmm'
  ];
}
