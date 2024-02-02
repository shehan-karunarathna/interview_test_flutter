// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteByEmpNo;

  const EmployeeCard({
    Key? key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteByEmpNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final empNo = item['empNo'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['empName']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['empAddressLine1']),
            Text(item['empAddressLine2']),
            Text(item['empAddressLine3']),
            Text(item['departmentCode']),
            Text(item['dateOfJoin']),
            Text(item['dateOfBirth']),
            Text('${item['basicSalary']}'),
            Text('${item['isActive']}')
          ],
        ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              navigateEdit(item);
            } else if (value == 'delete') {
              deleteByEmpNo(empNo);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('Edit'),
              value: 'edit',
            ),
            PopupMenuItem(
              child: Text('Delete'),
              value: 'delete',
            ),
          ],
        ),
      ),
    );
  }
}
