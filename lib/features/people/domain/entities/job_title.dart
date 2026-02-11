class JobTitle {
  final String id;
  final String name;

  const JobTitle({required this.id, required this.name});

  factory JobTitle.fromJson(Map<String, dynamic> json) => JobTitle(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}
