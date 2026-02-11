class Department {
  final String id;
  final String name;

  const Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}
