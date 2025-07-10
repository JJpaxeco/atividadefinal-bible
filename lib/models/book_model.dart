class Book {
  final String name;
  final String ref;

  Book({required this.name, required this.ref});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['name'],
      ref: json['ref'],
    );
  }
}
