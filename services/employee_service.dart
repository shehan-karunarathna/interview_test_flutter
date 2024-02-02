// ignore_for_file: prefer_const_constructors, prefer_const_declarations, avoid_print, depend_on_referenced_packages

import 'dart:convert';

import 'package:http/http.dart' as http;

class EmployeeService {
  static const String _apiKey = '?D(G+KbPeSgVkYp3s6v9y\$B&E)H@McQf';

  static Future<bool> deleteByEmpNo(String empNo) async {
    try {
      final url = 'http://examination.24x7retail.com/api/v1.0/Employee/$empNo';
      final uri = Uri.parse(url);
      final response = await http.delete(
        uri,
        headers: {'apiToken': _apiKey},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting employee by empNo: $e');
      return false;
    }
  }

  static Future<List?> fetchEmployees() async {
    try {
      final url = 'http://examination.24x7retail.com/api/v1.0/Employees';
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {'apiToken': _apiKey},
      );
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          return jsonData;
        } else if (jsonData is Map) {
          final result = jsonData['items'] as List?;
          return result;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching Employees: $e');
      return null;
    }
  }

  static Future<bool> updateEmployee(
      String empNo, Map<String, dynamic> body) async {
    try {
      final url = 'http://examination.24x7retail.com/api/v1.0/Employees/$empNo';
      final uri = Uri.parse(url);
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'apiToken': _apiKey,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating Employees: $e');
      return false;
    }
  }

  static Future<bool> addEmployee(Map body) async {
    try {
      final url = 'http://examination.24x7retail.com/api/v1.0/Employee';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'apiToken': _apiKey,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error adding employees: $e');
      return false;
    }
  }
}
