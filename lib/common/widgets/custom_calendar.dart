import 'package:employee_management_bloc/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) updateDate;
  final DateTime? ignoreDate;
  const CustomCalendar(
      {Key? key,
      required this.selectedDate,
      required this.updateDate,
      this.ignoreDate})
      : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  int monthIndex = 0;
  int yearIndex = 0;
  int buttonIndex = -1;
  int totalDaysInMonth = 0;
  int startingIndex = 0;
  DateTime? selectedDate;
  DateTime currentDate = DateTime.now();
  bool isNoDate = false;

  void getNumberOfDayInMonth() {
    setState(() {
      totalDaysInMonth =
          DateTime(selectedDate!.year, selectedDate!.month + 1, 0).day;
    });
  }

  void getStartingDayOfMonth() {
    int res = DateTime(selectedDate!.year, selectedDate!.month, 0).weekday;
    setState(() {
      startingIndex = res + 1 >= 7 ? 1 : res + 1;
    });
  }

  int ignoreMonth = -1;
  int ignoreYear = -1;
  int ignoreDate = -1;

  @override
  void initState() {
    super.initState();
    if (widget.ignoreDate != null) {
      ignoreMonth = widget.ignoreDate!.month;
      ignoreYear = widget.ignoreDate!.year;
      ignoreDate = widget.ignoreDate!.day;
    }

    if (widget.selectedDate == null) {
      setState(() {
        selectedDate = widget.ignoreDate;
        monthIndex = selectedDate!.month;
        yearIndex = selectedDate!.year;
      });
    } else {
      setState(() {
        selectedDate = widget.selectedDate;
        monthIndex = selectedDate!.month;
        yearIndex = selectedDate!.year;
      });
    }
    getNumberOfDayInMonth();
    getStartingDayOfMonth();
  }

  bool isCurrentAndSelectedSame() {
    if (currentDate.month == selectedDate!.month &&
        currentDate.year == selectedDate!.year &&
        currentDate.day == selectedDate!.day) {
      return true;
    } else {
      return false;
    }
  }

  bool isToday(int index) {
    if (currentDate.month == selectedDate!.month &&
        currentDate.year == selectedDate!.year &&
        currentDate.day == index) {
      return true;
    } else {
      return false;
    }
  }

  bool isSelected(int index) {
    if (selectedDate!.day == index &&
        selectedDate!.month == monthIndex &&
        selectedDate!.year == yearIndex) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIfCanChange() {
    if (selectedDate!.year == ignoreYear) {
      if (selectedDate!.month > ignoreMonth) {
        return true;
      } else {
        return false;
      }
    } else if (selectedDate!.year > ignoreYear) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> functionsEnd = [
      {
        "title": "No Date",
        "function": () {
          setState(() {
            isNoDate = true;
          });
        },
      },
      {
        "title": "Today",
        "function": () {
          if (widget.ignoreDate != null) {
            if (ignoreDate > currentDate.day &&
                ignoreMonth == currentDate.month &&
                ignoreYear == currentDate.year) {
              setState(() {
                buttonIndex = -1;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You can't select a date before the start day"),
                ),
              );
            } else {
              setState(() {
                isNoDate = false;
                selectedDate = DateTime.now();
              });

              getNumberOfDayInMonth();
              getStartingDayOfMonth();
            }
          }
        },
      },
    ];
    List<Map<String, dynamic>> functions = [
      {
        "title": "Today",
        "function": () {
          setState(() {
            selectedDate = DateTime.now();
          });

          getNumberOfDayInMonth();
          getStartingDayOfMonth();
        },
      },
      {
        "title": "Next Monday",
        "function": () {
          setState(() {
            var dayOfSelectedDate = DateTime.now().weekday;
            if (dayOfSelectedDate == 1) {
              selectedDate = DateTime.now().add(const Duration(days: 7));
            } else {
              selectedDate =
                  DateTime.now().add(Duration(days: 7 - dayOfSelectedDate + 1));
            }
          });

          getNumberOfDayInMonth();
          getStartingDayOfMonth();
        },
      },
      {
        "title": "Next Tuesday",
        "function": () {
          setState(() {
            var dayOfSelectedDate = DateTime.now().weekday;
            if (dayOfSelectedDate == 2) {
              selectedDate = DateTime.now().add(const Duration(days: 7));
            } else {
              selectedDate =
                  DateTime.now().add(Duration(days: 7 - dayOfSelectedDate + 2));
            }
          });

          getNumberOfDayInMonth();
          getStartingDayOfMonth();
        },
      },
      {
        "title": "After 1 week",
        "function": () {
          setState(() {
            selectedDate = DateTime.now().add(Duration(days: 7));
          });

          getNumberOfDayInMonth();
          getStartingDayOfMonth();
        },
      },
    ];
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      child: Material(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 20,
            bottom: 0,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.ignoreDate == null
                      ? functions.length
                      : functionsEnd.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                  ),
                  itemBuilder: (context, index) {
                    var fn =
                        widget.ignoreDate == null ? functions : functionsEnd;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          buttonIndex = index;
                        });
                        fn[index]["function"]();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: buttonIndex == index
                              ? Colors.blue
                              : CustomColor.lightBlueColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            fn[index]["title"],
                            style: CustomTextTheme.bodyMedium.copyWith(
                              color: buttonIndex == index
                                  ? Colors.white
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (checkIfCanChange()) {
                            setState(() {
                              // previous month
                              selectedDate = DateTime(
                                selectedDate!.year,
                                selectedDate!.month - 1,
                                selectedDate!.day,
                              );
                            });
                            getNumberOfDayInMonth();
                            getStartingDayOfMonth();
                          }
                        },
                        child: Icon(
                          Icons.arrow_left_rounded,
                          size: 40,
                          color: !checkIfCanChange()
                              ? CustomColor.lightGreyColor
                              : Colors.grey,
                        )),
                    Text(
                      '${months[selectedDate!.month - 1]} ${selectedDate!.year}',
                      style: CustomTextTheme.headingMedium,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                            ).add(const Duration(days: 31));
                          });
                          getNumberOfDayInMonth();
                          getStartingDayOfMonth();
                        },
                        child: const Icon(
                          Icons.arrow_right_rounded,
                          size: 40,
                          color: Colors.grey,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: days.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 2.8,
                      ),
                      itemBuilder: (context, index) {
                        return Text(
                          days[index],
                          textAlign: TextAlign.center,
                          style: CustomTextTheme.bodyMediumLarge.copyWith(
                            color: CustomColor.customBlack,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: totalDaysInMonth + startingIndex,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        int currentIndex = index + 1 - startingIndex;
                        return startingIndex > index
                            ? const Text('')
                            : GestureDetector(
                                onTap: () {
                                  if (currentIndex < ignoreDate &&
                                      !checkIfCanChange()) {
                                    return;
                                  }
                                  setState(() {
                                    isNoDate = false;
                                    buttonIndex = -1;
                                    monthIndex = selectedDate!.month;
                                    yearIndex = selectedDate!.year;
                                    selectedDate = DateTime(
                                      selectedDate!.year,
                                      selectedDate!.month,
                                      index + 1 - startingIndex,
                                    );
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isNoDate
                                        ? Colors.white
                                        : isSelected(currentIndex)
                                            ? Colors.blue
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: isToday(currentIndex)
                                          ? Colors.blue
                                          : Colors.white,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1 - startingIndex}',
                                      textAlign: TextAlign.center,
                                      style: CustomTextTheme.bodyMediumLarge
                                          .copyWith(
                                        color: currentIndex < ignoreDate &&
                                                !checkIfCanChange()
                                            ? CustomColor.lightGreyColor
                                            : isNoDate
                                                ? CustomColor.customBlack
                                                : isSelected(currentIndex)
                                                    ? Colors.white
                                                    : isToday(currentIndex)
                                                        ? Colors.blue
                                                        : CustomColor
                                                            .customBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  height: 64,
                  width: MediaQuery.of(context).size.width,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      selectedDate != null
                          ? const Icon(
                              Icons.event_rounded,
                              color: Colors.blue,
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 10,
                      ),
                      selectedDate != null
                          ? Text(
                              isNoDate
                                  ? 'No Date'
                                  : DateFormat('dd MMM yyyy')
                                      .format(selectedDate!),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: CustomColor.customBlack,
                                  ),
                            )
                          : const SizedBox(),
                      const Spacer(),
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
                          isNoDate
                              ? widget.updateDate(null)
                              : widget.updateDate(selectedDate!);
                          Navigator.pop(context, selectedDate);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
