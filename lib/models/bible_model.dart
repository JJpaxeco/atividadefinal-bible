class Bible {
  final String name;
  final String ref;

  Bible({required this.name, required this.ref});

  factory Bible.fromJson(Map<String, dynamic> json) {
    return Bible(
      name: json['name'],
      ref: json['ref'],
    );
  }
}
