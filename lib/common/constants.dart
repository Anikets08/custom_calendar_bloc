import 'package:flutter/material.dart';

class CustomColor {
  static Color bgColorHomeScreen = const Color(0xffF2F2F2);
  static Color lightBlueColor = const Color(0xFFEDF8FF);
  static Color customGreyColor = const Color(0xff949C9E);
  static Color lightGreyColor = const Color(0xffE5E5E5);
  static Color lightBorderColor = const Color(0xffF2F2F2);
  static Color customBlack = const Color(0xff323238);
}

class CustomTextTheme {
  static TextStyle headingMedium = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyLarge = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyMediumLarge = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyMediumBold = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bodySmall = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}

String hiveBoxName = "employeeBox";
String noDataImage = "assets/images/no_employee_image.svg";
RoundedRectangleBorder roundedRecFAB = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(8),
  ),
);

List<String> positions = [
  "Product Designer",
  "Flutter Developer",
  "QA Tester",
  "Product Owner",
];
List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
