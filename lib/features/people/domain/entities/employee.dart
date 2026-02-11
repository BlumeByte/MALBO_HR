class Employee {
  final String id;
  final String companyId;
  final String? userId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String status;

  final String? employeeNo;
  final String? departmentId;
  final String? jobTitleId;
  final String? locationId;
  final String? managerEmployeeId;

  const Employee({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.status,
    required this.employeeNo,
    required this.departmentId,
    required this.jobTitleId,
    required this.locationId,
    required this.managerEmployeeId,
  });

  String get fullName => '$firstName $lastName';

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'],
        companyId: json['company_id'],
        userId: json['user_id'],
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'],
        phone: json['phone'],
        status: json['status'] ?? 'active',
        employeeNo: json['employee_no'],
        departmentId: json['department_id'],
        jobTitleId: json['job_title_id'],
        locationId: json['location_id'],
        managerEmployeeId: json['manager_employee_id'],
      );

  Map<String, dynamic> toInsert() => {
        'company_id': companyId,
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'status': status,
        'employee_no': employeeNo,
        'department_id': departmentId,
        'job_title_id': jobTitleId,
        'location_id': locationId,
        'manager_employee_id': managerEmployeeId,
      };

  Map<String, dynamic> toUpdate() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'status': status,
        'employee_no': employeeNo,
        'department_id': departmentId,
        'job_title_id': jobTitleId,
        'location_id': locationId,
        'manager_employee_id': managerEmployeeId,
      };
}
