import 'package:fullserva/data/repositories/employee_repository.dart';
import 'package:fullserva/domain/entities/employee.dart';
import 'package:fullserva/domain/usecases/employee_usecase.dart';

class EmployeeController implements EmployeeUseCase {
  final EmployeeRepository _employeeRepository;

  EmployeeController(this._employeeRepository);

  @override
  Future<void> addEmployee(Employee employee) {
    return _employeeRepository.addEmployee(employee);
  }

  @override
  Stream<List<Employee>> getEmployee() {
    return _employeeRepository.getEmployee();
  }

  @override
  Future<void> removeEmployee(String employee) {
    return _employeeRepository.removeEmployee(employee);
  }

  @override
  Future<void> updateEmployee(Employee employee) {
    return _employeeRepository.updateEmployee(employee);
  }

}