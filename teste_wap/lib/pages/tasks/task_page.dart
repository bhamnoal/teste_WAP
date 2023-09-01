import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teste_wap/db/databasemanager.dart';

class TaskPage extends StatefulWidget {
  final Map<String, dynamic> taskList;
  final int fieldIndex;
  final String dbManager;
  const TaskPage(
      {Key? key,
      required this.taskList,
      required this.fieldIndex,
      required this.dbManager})
      : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late DatabaseManager individualDb;
  List<TextEditingController> controllers = [];
  List<Map<String, dynamic>> _savedTasks = [];
  @override
  void initState() {
    super.initState();
    for (var field in widget.taskList['fields']) {
      controllers.add(TextEditingController(text: field['label']));
    }
    individualDb = DatabaseManager(widget.dbManager);
    individualDb.initializeDataBase(widget.dbManager).then(
      (value) {
        _initializeAndGetData();
      },
    );
  }

  Future<void> _initializeAndGetData() async {
    await individualDb.getSavedTasks();
    await _loadSavedTasks();
  }

  Future<void> _deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'task_database.db');
    await deleteDatabase(path);
  }

  Future<void> _loadSavedTasks() async {
    _savedTasks = await individualDb.getSavedTasks();
    for (var i = 0; i < _savedTasks.length; i++) {
      controllers[i].text = _savedTasks[i]['label'];
      setState(() {});
      print(controllers[i].text);
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste'),
      ),
      body: Column(
        children: [
          Column(
            children:
                widget.taskList['fields'].asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              Map<String, dynamic> field = entry.value;
              String label = field['label'];
              TextEditingController controller = controllers[index];
              int indexCard = field['id'];
              return Card(
                color: field['required']
                    ? Colors.red.shade300
                    : Colors.green.shade300,
                child: ListTile(
                  title: Text(label),
                  subtitle: Text(controller.text),
                  onTap: () {
                    _openFormDialog(context, field, indexCard);
                  },
                ),
              );
            }).toList(),
          ),
          FloatingActionButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Deseja limpar o banco de dados?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _deleteDatabase();
                          await _loadSavedTasks();
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: const Text('Sim'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  void _openFormDialog(
      BuildContext context, Map<String, dynamic> field, int index) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${field['label']}'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(labelText: field['label']),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  for (int i = 0; i < widget.taskList['fields'].length; i++) {
                    if (widget.taskList['fields'][i]['label'] ==
                        field['label']) {
                      field['required'] = false;
                      controllers[i].text = controller.text;
                      break;
                    }
                  }
                });

                await individualDb.saveToDatabase(controller.text, false);
                print(_savedTasks[index]);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
