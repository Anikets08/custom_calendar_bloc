import 'package:employee_management_bloc/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          noDataImage,
          semanticsLabel: 'No Data Image',
        ),
        Text(
          'No employee records found',
          style: CustomTextTheme.headingMedium.copyWith(
            color: CustomColor.customBlack,
          ),
        ),
      ],
    );
  }
}
