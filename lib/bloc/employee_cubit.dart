import 'package:bloc/bloc.dart';
import 'package:employee_management_bloc/main.dart';
import 'package:employee_management_bloc/model/employee_model.dart';

class EmployeeCubit extends Cubit<List<EmployeeModel>> {
  EmployeeCubit() : super([]);

  void addAllEmployee(List<EmployeeModel> employee) {
    emit(employee);
  }

  void addEmployee(EmployeeModel employee) {
    List<EmployeeModel> newState = List.from(state);
    newState.add(employee);
    hiveBox.put("employee", newState.map((e) => e.toJson()).toList());
    emit(newState);
  }

  void updateEmployee(EmployeeModel employee) {
    List<EmployeeModel> newState = List.from(state);
    newState[newState.indexWhere((element) => element.id == employee.id)] =
        employee;
    hiveBox.put("employee", newState.map((e) => e.toJson()).toList());
    emit(newState);
  }

  void deleteEmployee(EmployeeModel employee) {
    List<EmployeeModel> newState = List.from(state);
    newState.removeWhere((element) => element.id == employee.id);
    hiveBox.put("employee", newState.map((e) => e.toJson()).toList());
    emit(newState);
  }

  List<EmployeeModel> getCurrentEmployee() {
    List<EmployeeModel> currentEmployee =
        state.where((element) => element.resignedDate == null).toList();
    return currentEmployee;
  }

  List<EmployeeModel> getPreviousEmployee() {
    List<EmployeeModel> previousEmployee =
        state.where((element) => element.resignedDate != null).toList();
    return previousEmployee;
  }
}

class HistoryCubit extends Cubit<List<EmployeeModel>> {
  HistoryCubit() : super([]);

  void addHistory(EmployeeModel employee) {
    List<EmployeeModel> newState = List.from(state);
    newState.add(employee);
    emit(newState);
  }

  void clearHistory() {
    emit([]);
  }
}
