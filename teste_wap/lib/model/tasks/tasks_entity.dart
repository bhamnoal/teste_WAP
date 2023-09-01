import 'package:teste_wap/model/fields/fields_dto.dart';

class TasksEntity {
  int id;
  String task_name;
  String description;
  List<FieldsDto> fields;

  TasksEntity(
      {required this.id,
      required this.task_name,
      required this.description,
      required this.fields});
}
