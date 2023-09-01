import 'package:teste_wap/model/tasks/tasks_dto.dart';
import 'package:teste_wap/model/user/user_entity.dart';

class UserDto extends UserEntity {
  UserDto({required super.name, required super.profile, required super.tasks});
  factory UserDto.empty() {
    return UserDto(name: '', profile: '', tasks: []);
  }
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
        name: json['name'] ?? '',
        profile: json['profile'] ?? '',
        tasks: json['tasks'] == null
            ? []
            : (json['tasks'] as List<dynamic>)
                .map<TasksDto>((tasks) => TasksDto.fromJson(tasks))
                .toList());
  }
}
