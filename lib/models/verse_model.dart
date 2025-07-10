class Verse {
  final String text;
  final int verse;

  Verse({required this.text, required this.verse});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      text: json['text'],
      verse: json['verse'],
    );
  }
}
