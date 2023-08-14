import 'package:employee_management_bloc/bloc/employee_cubit.dart';
import 'package:employee_management_bloc/common/constants.dart';
import 'package:employee_management_bloc/common/widgets/empty_list_widget.dart';
import 'package:employee_management_bloc/common/widgets/listview_current_employee.dart';
import 'package:employee_management_bloc/common/widgets/listview_previous_employee.dart';
import 'package:employee_management_bloc/main.dart';
import 'package:employee_management_bloc/model/employee_model.dart';
import 'package:employee_management_bloc/screen/add_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    var res = hiveBox.get("employee", defaultValue: []);
    List castedRes = [];
    for (var item in res) {
      var val = item.cast<String, dynamic>();
      castedRes.add(val);
    }

    List<EmployeeModel> employeeList = castedRes
        .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
        .toList();

    context.read<EmployeeCubit>().addAllEmployee(employeeList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.bgColorHomeScreen,
      floatingActionButton: FloatingActionButton(
        shape: roundedRecFAB,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDetailScreen(
                screenType: ScreenType.add,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Employee List',
          style: CustomTextTheme.headingMedium.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SizedBox(
        width: double.infinity,
        child: BlocBuilder<EmployeeCubit, List<EmployeeModel>>(
          builder: (context, state) {
            void undo() {
              context.read<EmployeeCubit>().addEmployee(
                    context.read<HistoryCubit>().state.last,
                  );
              context.read<HistoryCubit>().clearHistory();
            }

            return SafeArea(
              child: state.isEmpty
                  ? const EmptyListWidget()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //current employee
                        context
                                .read<EmployeeCubit>()
                                .getCurrentEmployee()
                                .isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Current Employee',
                                    style: CustomTextTheme.bodyLarge.copyWith(
                                      color: Colors.blue,
                                    )),
                              )
                            : const SizedBox(),
                        context
                                .read<EmployeeCubit>()
                                .getCurrentEmployee()
                                .isNotEmpty
                            ? Expanded(
                                child: ListviewCurrentEmployee(
                                  employeeData: state,
                                  undo: undo,
                                ),
                              )
                            : const SizedBox(),
                        //previous employee
                        context
                                .read<EmployeeCubit>()
                                .getPreviousEmployee()
                                .isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Previous employees',
                                    style: CustomTextTheme.bodyLarge.copyWith(
                                      color: Colors.blue,
                                    )),
                              )
                            : const SizedBox(),
                        context
                                .read<EmployeeCubit>()
                                .getPreviousEmployee()
                                .isNotEmpty
                            ? Expanded(
                                child: ListviewPreviousEmployee(
                                  employeeData: state,
                                  undo: undo,
                                ),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            left: 16,
                            bottom: 12,
                          ),
                          child: Text(
                            "Swipe left to delete",
                            style: CustomTextTheme.bodyMediumLarge.copyWith(
                              color: CustomColor.customGreyColor,
                            ),
                          ),
                        )
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
