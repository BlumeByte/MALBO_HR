import 'package:flutter/material.dart';
import '../../domain/entities/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onOpen,
        title: Text(employee.fullName,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(employee.email ?? 'No email'),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
                icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
            IconButton(
                icon: const Icon(Icons.delete_outline), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
