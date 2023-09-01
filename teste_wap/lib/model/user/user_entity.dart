import 'package:teste_wap/model/tasks/tasks_dto.dart';

class UserEntity {
  String name;
  String profile;
  List<TasksDto> tasks;
  UserEntity({required this.name, required this.profile, required this.tasks});
}
