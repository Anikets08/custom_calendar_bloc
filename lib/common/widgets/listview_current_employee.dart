import 'package:employee_management_bloc/bloc/employee_cubit.dart';
import 'package:employee_management_bloc/common/constants.dart';
import 'package:employee_management_bloc/model/employee_model.dart';
import 'package:employee_management_bloc/screen/add_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ListviewCurrentEmployee extends StatelessWidget {
  final List<EmployeeModel> employeeData;
  final Function undo;
  const ListviewCurrentEmployee(
      {Key? key, required this.employeeData, required this.undo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<EmployeeModel> currentEmployee =
        employeeData.where((element) => element.resignedDate == null).toList();
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: currentEmployee.length,
      separatorBuilder: (context, index) => const Divider(
        height: 0,
      ),
      itemBuilder: (context, index) {
        return Dismissible(
          background: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          key: Key(currentEmployee[index].id.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            context.read<HistoryCubit>().addHistory(currentEmployee[index]);
            context
                .read<EmployeeCubit>()
                .deleteEmployee(currentEmployee[index]);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Employee data has been deleted',
                ),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    undo();
                  },
                ),
              ),
            );
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDetailScreen(
                    screenType: ScreenType.edit,
                    employeeData: currentEmployee[index],
                  ),
                ),
              );
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentEmployee[index].fullName,
                      style: CustomTextTheme.bodyLarge.copyWith(
                        color: CustomColor.customBlack,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentEmployee[index].role,
                      style: CustomTextTheme.bodyMedium.copyWith(
                        color: CustomColor.customGreyColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "From ${DateFormat('dd MMM, yyyy').format(currentEmployee[index].joinedDate)}",
                      style: CustomTextTheme.bodySmall.copyWith(
                        color: CustomColor.customGreyColor,
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
