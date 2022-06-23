class CollectionFieldView{
  static const DEFAULT_VIEW = "DEFAULT";

  String name;
  List<String> fieldShowed;

  CollectionFieldView(this.name, this.fieldShowed);

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'fieldShowed': fieldShowed
    };
  }



  CollectionFieldView.fromJson(Map<String, dynamic> json): this(
      json['name']! ,
      json['fieldShowed'] == null ? [] : (json['fieldShowed'] as List).map((e) => e as String).toList()
  );
}