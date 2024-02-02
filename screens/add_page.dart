// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_declarations, prefer_const_constructors, depend_on_referenced_packages, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:interview_test/services/employee_service.dart';
import 'package:interview_test/util/snackbar_helper.dart';

class AddEmployeePage extends StatefulWidget {
  final Map<dynamic, dynamic>? employee;

  const AddEmployeePage({Key? key, this.employee}) : super(key: key);

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  TextEditingController empNoController = TextEditingController();
  TextEditingController empNameController = TextEditingController();
  TextEditingController empAddressLine1Controller = TextEditingController();
  TextEditingController empAddressLine2Controller = TextEditingController();
  TextEditingController empAddressLine3Controller = TextEditingController();
  TextEditingController departmentCodeController = TextEditingController();
  TextEditingController dateOfJoinController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController basicSalaryController = TextEditingController();
  TextEditingController isActiveController = TextEditingController();

  bool isEdit = false;
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    if (employee != null) {
      isEdit = true;
      empNoController.text = employee['empNo'] ?? '';
      empNameController.text = employee['empName'] ?? '';
      empAddressLine1Controller.text = employee['empAddressLine1'] ?? '';
      empAddressLine2Controller.text = employee['empAddressLine2'] ?? '';
      empAddressLine3Controller.text = employee['empAddressLine3'] ?? '';
      departmentCodeController.text = employee['departmentCode'] ?? '';
      dateOfJoinController.text = employee['dateOfJoin'] ?? '';
      dateOfBirthController.text = employee['dateOfBirth'] ?? '';
      basicSalaryController.text = (employee['basicSalary'] ?? '').toString();
      isActiveController.text = (employee['isActive'] ?? '').toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Employee' : 'Add Employee'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          _buildTextField('Employee No', empNoController),
          _buildTextField('Employee Name', empNameController),
          _buildTextField('Address Line 1', empAddressLine1Controller),
          _buildTextField('Address Line 2', empAddressLine2Controller),
          _buildTextField('Address Line 3', empAddressLine3Controller),
          _buildTextField('Department Code', departmentCodeController),
          _buildTextField('Date of Join', dateOfJoinController),
          _buildTextField('Date of Birth', dateOfBirthController),
          _buildTextField('Basic Salary', basicSalaryController),
          _buildTextField('Is Active', isActiveController),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    if (label == 'Is Active') {
      return DropdownButtonFormField<bool>(
        value: controller.text.toLowerCase() == 'true',
        onChanged: (newValue) {
          setState(() {
            controller.text = newValue.toString();
          });
        },
        items: [
          DropdownMenuItem<bool>(
            value: true,
            child: Text('True'),
          ),
          DropdownMenuItem<bool>(
            value: false,
            child: Text('False'),
          ),
        ],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      );
    } else if (label == 'Date of Join' || label == 'Date of Birth') {
      return TextFormField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? pickedDateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2101),
              );
              if (pickedDateTime != null) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  final DateTime selectedDateTime = DateTime(
                    pickedDateTime.year,
                    pickedDateTime.month,
                    pickedDateTime.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  controller.text = selectedDateTime.toString();
                }
              }
            },
          ),
        ),
      );
    } else if (label == 'Basic Salary') {
      return TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      );
    } else {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      );
    }
  }

  Future<void> updateData() async {
    final employee = widget.employee;
    if (employee == null) {
      print('Cannot update without employee data');
      return;
    }

    final empNo = employee['empNo'];
    if (empNo == null) {
      print('Employee number is missing');
      return;
    }

    final isSuccess = await EmployeeService.updateEmployee(empNo, body);
    if (isSuccess) {
      _clearControllers();
      showSuccessMessage(context, message: 'Update Success');
    } else {
      showErrorMessage(context, message: 'Update Failed');
    }
  }

  Future<void> submitData() async {
    final url = 'http://examination.24x7retail.com/api/v1.0/Employee';
    final headers = {
      'accept': '*/*',
      'apiToken': '?D(G+KbPeSgVkYp3s6v9y\$B&E)H@McQf',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        _clearControllers();
        showSuccessMessage(context, message: 'Creation Success');
      } else {
        showErrorMessage(context, message: 'Creation Failed');
      }
    } catch (e) {
      print('Error: $e');
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Map<String, dynamic> get body {
    return {
      "empNo": empNoController.text,
      "empName": empNameController.text,
      "empAddressLine1": empAddressLine1Controller.text,
      "empAddressLine2": empAddressLine2Controller.text,
      "empAddressLine3": empAddressLine3Controller.text,
      "departmentCode": departmentCodeController.text,
      "dateOfJoin": dateOfJoinController.text,
      "dateOfBirth": dateOfBirthController.text,
      "basicSalary": double.tryParse(basicSalaryController.text) ?? 0.0,
      "isActive": isActiveController.text.toLowerCase() == 'true',
    };
  }

  void _clearControllers() {
    empNoController.clear();
    empNameController.clear();
    empAddressLine1Controller.clear();
    empAddressLine2Controller.clear();
    empAddressLine3Controller.clear();
    departmentCodeController.clear();
    dateOfJoinController.clear();
    dateOfBirthController.clear();
    basicSalaryController.clear();
    isActiveController.clear();
  }
}
