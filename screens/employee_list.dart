// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:interview_test/screens/add_page.dart';
import 'package:interview_test/services/employee_service.dart';
import 'package:interview_test/util/snackbar_helper.dart';
import 'package:interview_test/widget/employee_card.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    items = [];
    fetchEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Details List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Text(
                          'No Employee Details',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchEmployee,
                        child: ListView.builder(
                          itemCount: items.length,
                          padding: EdgeInsets.all(12),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final empNo = item['empNo'].toString();
                            return EmployeeCard(
                              key: Key(empNo),
                              index: index,
                              item: item,
                              deleteByEmpNo: deleteByEmpNo,
                              navigateEdit: navigateToEditPage,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text(
          "Add Employees",
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  void onSearchTextChanged(String text) {
    final searchText = text.toLowerCase();

    if (searchText.isNotEmpty) {
      setState(() {
        items = items.where((item) {
          final empNo = item['empNo'].toString().toLowerCase();
          final empName = item['empName'].toString().toLowerCase();

          return empNo.contains(searchText) || empName.contains(searchText);
        }).toList();
      });
    } else {
      fetchEmployee();
    }
  }

  Future<void> navigateToEditPage(Map<dynamic, dynamic> item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddEmployeePage(employee: item),
    );
    await Navigator.push(context, route);
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      fetchEmployee();
    }
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddEmployeePage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
  }

  Future<void> deleteByEmpNo(String empNo) async {
    final isSuccess = await EmployeeService.deleteByEmpNo(empNo);
    if (isSuccess) {
      setState(() {
        items.removeWhere((element) => element['empNo'] == empNo);
      });
    } else {
      showErrorMessage(context, message: 'Delete Failed');
    }
  }

  Future<void> fetchEmployee() async {
    final response = await EmployeeService.fetchEmployees();

    if (response != null) {
      setState(() {
        items = List<Map<String, dynamic>>.from(response);
      });
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }

    setState(() {
      isLoading = false;
    });
  }
}
