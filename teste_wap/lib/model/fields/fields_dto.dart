import 'package:teste_wap/model/fields/fields_entity.dart';

class FieldsDto extends FieldsEntity {
  FieldsDto(
      {required super.id,
      required super.label,
      required super.required,
      required super.field_type});
  factory FieldsDto.empty() {
    return FieldsDto(id: 0, label: '', required: false, field_type: '');
  }
  factory FieldsDto.fromJson(Map<String, dynamic> json) {
    return FieldsDto(
        id: json['id'],
        label: json['label'],
        required: json['required'],
        field_type: json['field_type']);
  }
}
