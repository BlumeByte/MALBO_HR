class Location {
  final String id;
  final String name;

  const Location({required this.id, required this.name});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}
