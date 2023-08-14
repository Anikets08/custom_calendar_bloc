import 'package:employee_management_bloc/bloc/employee_cubit.dart';
import 'package:employee_management_bloc/common/constants.dart';
import 'package:employee_management_bloc/common/widgets/custom_calendar.dart';
import 'package:employee_management_bloc/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum ScreenType {
  add,
  edit,
}

class AddDetailScreen extends StatefulWidget {
  final ScreenType screenType;
  final EmployeeModel? employeeData;
  const AddDetailScreen({Key? key, required this.screenType, this.employeeData})
      : super(key: key);

  @override
  State<AddDetailScreen> createState() => _AddDetailScreenState();
}

class _AddDetailScreenState extends State<AddDetailScreen> {
  TextEditingController nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? endDate;
  String? selectedPosition;

  @override
  void initState() {
    super.initState();
    if (widget.screenType == ScreenType.edit) {
      nameController.text = widget.employeeData!.fullName;
      selectedDate = widget.employeeData!.joinedDate;
      endDate = widget.employeeData!.resignedDate;
      selectedPosition = widget.employeeData!.role;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void updateDate(DateTime? date) {
    setState(() {
      selectedDate = date!;
    });
  }

  void updateEndDate(DateTime? date) {
    setState(() {
      endDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          widget.screenType == ScreenType.edit
              ? IconButton(
                  onPressed: () {
                    context.read<EmployeeCubit>().deleteEmployee(
                          widget.employeeData!,
                        );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete),
                )
              : const SizedBox(),
        ],
        title: Text(
          widget.screenType == ScreenType.add
              ? "Add Employee Details"
              : "Edit Employee Details",
          style: CustomTextTheme.headingMedium.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 23,
                  ),
                  TextFormField(
                    controller: nameController,
                    onTapOutside: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: CustomColor.lightGreyColor),
                      ),
                      prefixIcon:
                          const Icon(Icons.person_outlined, color: Colors.blue),
                      labelText: 'Employee Name',
                      labelStyle: CustomTextTheme.bodyMedium.copyWith(
                        color: nameController.text.isEmpty
                            ? CustomColor.customGreyColor
                            : Colors.blue,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        builder: (BuildContext context) {
                          return Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 300
                                : MediaQuery.of(context).size.height * 1,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: positions.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        dense: true,
                                        onTap: () {
                                          setState(() {
                                            selectedPosition = positions[index];
                                          });
                                          Navigator.pop(context);
                                        },
                                        title: Text(
                                          positions[index],
                                          textAlign: TextAlign.center,
                                          style: CustomTextTheme.bodyLarge
                                              .copyWith(
                                            color: CustomColor.customBlack,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColor.lightGreyColor),
                        ),
                        prefixIcon:
                            const Icon(Icons.work_outline, color: Colors.blue),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.blue,
                          size: 45,
                        ),
                        labelText: selectedPosition ?? 'Select role',
                        labelStyle: CustomTextTheme.bodyMedium.copyWith(
                          color: selectedPosition == null
                              ? CustomColor.customGreyColor
                              : CustomColor.customBlack,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomCalendar(
                                  selectedDate: selectedDate,
                                  updateDate: updateDate,
                                );
                              },
                            );
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColor.lightGreyColor),
                              ),
                              prefixIcon: const Icon(Icons.event_rounded,
                                  color: Colors.blue),
                              labelText: DateFormat('dd MMM yyyy')
                                          .format(selectedDate) ==
                                      DateFormat('dd MMM yyyy')
                                          .format(DateTime.now())
                                  ? 'Today'
                                  : DateFormat('dd MMM yyyy')
                                      .format(selectedDate),
                              labelStyle: CustomTextTheme.bodyMedium.copyWith(
                                color: CustomColor.customBlack,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomCalendar(
                                  selectedDate: endDate,
                                  updateDate: updateEndDate,
                                  ignoreDate: selectedDate,
                                );
                              },
                            );
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColor.lightGreyColor),
                              ),
                              prefixIcon: const Icon(Icons.event_rounded,
                                  color: Colors.blue),
                              labelText: endDate == null
                                  ? 'No Date'
                                  : DateFormat('dd MMM yyyy').format(endDate!),
                              labelStyle: CustomTextTheme.bodyMedium.copyWith(
                                color: endDate == null
                                    ? Colors.grey
                                    : CustomColor.customBlack,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 64,
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.horizontal,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: CustomColor.lightBorderColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: CustomColor.lightBlueColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: CustomTextTheme.bodyMediumBold.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                      ),
                      onPressed: () {
                        Uuid uuid = const Uuid();
                        if (widget.screenType == ScreenType.edit) {
                          context.read<EmployeeCubit>().updateEmployee(
                                EmployeeModel(
                                  id: widget.employeeData!.id,
                                  fullName: nameController.text,
                                  role: selectedPosition!,
                                  joinedDate: selectedDate,
                                  resignedDate: endDate,
                                ),
                              );
                        } else {
                          context.read<EmployeeCubit>().addEmployee(
                                EmployeeModel(
                                  id: uuid.v4(),
                                  fullName: nameController.text,
                                  role: selectedPosition!,
                                  joinedDate: selectedDate,
                                  resignedDate: endDate,
                                ),
                              );
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: CustomTextTheme.bodyMediumBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
