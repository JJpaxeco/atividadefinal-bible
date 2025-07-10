class Book {
  final String name;
  final String ref;
  final int order;
  final int chaptersCount;

  Book({
    required this.name,
    required this.ref,
    required this.order,
    required this.chaptersCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['name'],
      ref: json['ref'],
      order: json['order'],
      chaptersCount: json['chaptersCount'],
    );
  }
}
