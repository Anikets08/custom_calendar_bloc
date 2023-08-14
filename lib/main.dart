import 'package:employee_management_bloc/bloc/employee_cubit.dart';
import 'package:employee_management_bloc/common/constants.dart';
import 'package:employee_management_bloc/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(hiveBoxName);
  runApp(
    const MyApp(),
  );
}

final hiveBox = Hive.box(hiveBoxName);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeCubit>(
          create: (context) => EmployeeCubit(),
        ),
        BlocProvider<HistoryCubit>(
          create: (context) => HistoryCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
