class Make {
  final String make_name;

  Make({required this.make_name});

  factory Make.fromJson(Map<String, dynamic> json) =>
      Make(make_name: json['name']);
}
