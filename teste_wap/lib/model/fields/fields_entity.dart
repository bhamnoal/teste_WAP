class FieldsEntity {
  int id;
  String label;
  bool required;
  String field_type;
  FieldsEntity(
      {required this.id,
      required this.label,
      required this.required,
      required this.field_type});
}
