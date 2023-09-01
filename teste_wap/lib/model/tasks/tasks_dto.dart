import 'package:teste_wap/model/fields/fields_dto.dart';
import 'package:teste_wap/model/tasks/tasks_entity.dart';

class TasksDto extends TasksEntity {
  TasksDto(
      {required super.id,
      required super.task_name,
      required super.description,
      required super.fields});
  factory TasksDto.empty() {
    return TasksDto(id: 0, task_name: '', description: '', fields: []);
  }
  factory TasksDto.fromJson(Map<String, dynamic> json) {
    return TasksDto(
        id: json['id'],
        task_name: json['task_name'],
        description: json['description'],
        fields: json['fields'] == null
            ? []
            : (json['fields'] as List<dynamic>)
                .map<FieldsDto>((fields) => FieldsDto.fromJson(fields))
                .toList());
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'taskName': task_name,
      "description": description
    };
  }
}
