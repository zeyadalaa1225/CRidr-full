class Model {
  String model_name;

  Model({required this.model_name});

  factory Model.fromJson(Map<String, dynamic> json) =>
      Model(model_name: json["Model_Name"]);
}
