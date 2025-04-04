class JsonCreative {
  final String title;
  final String subTitle;
  final List<String> bullets;
  final String buttonText;

  JsonCreative(
      {required this.title,
      required this.subTitle,
      required this.bullets,
      required this.buttonText});

  factory JsonCreative.fromJson(Map<String, dynamic> json) {
    return JsonCreative(
        title: json['title'] as String,
        subTitle: json['subTitle'] as String,
        bullets: List<String>.from(json['bullets'] as List),
        buttonText: json['buttonText']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subTitile': subTitle,
      'bullets': bullets,
      'buttonText': buttonText
    };
  }
}
