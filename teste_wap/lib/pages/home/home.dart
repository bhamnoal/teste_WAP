import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teste_wap/db/location_db.dart';
import 'package:teste_wap/pages/tasks/task_page.dart';

class Home extends StatefulWidget {
  int idTask;
  String userName;
  String profile;
  List<dynamic> taskList;
  Home(
      {super.key,
      required this.idTask,
      required this.userName,
      required this.profile,
      required this.taskList});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: true,
            enableHeadless: true,
            requiredNetworkType: NetworkType.NONE),
        backgroundLocationTask);
    BackgroundFetch.start().then((int status) {
      print('BACKGROUND LOCALIZAÇÃO ENVIADA: $status');
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationDb locationDb;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: Card(
                    elevation: 10,
                    color: Colors.blue.shade100,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.person_pin,
                            size: 50,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            widget.userName,
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            widget.profile,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(widget.taskList.length == 1
                      ? 'Há 1 tarefa a ser realizada.'
                      : 'Há ${widget.taskList.length} tarefas a serem realizadas:'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Column(
                    children: widget.taskList.asMap().entries.map((indexTask) {
                      int index = indexTask.key;
                      Map<String, dynamic> task = indexTask.value;
                      return GestureDetector(
                        onTap: () => _openTasks(context, task),
                        child: Card(
                          child: ListTile(
                            title: Text(task['task_name']),
                            subtitle: Text(task['description']),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openTasks(BuildContext context, Map<String, dynamic> task) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskPage(
                  taskList: task,
                  fieldIndex: task['id'],
                  dbManager: task['task_name'],
                )));
  }

  void backgroundLocationTask() async {
    _getUserLocation;
    BackgroundFetch.finish;
  }

  void _getUserLocation() async {
    late LocationDb locationDb;
    var status = await Permission.location.status;
    if (status.isGranted) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position);
      locationDb = LocationDb();
      locationDb.initializeDataBase().then((value) {
        locationDb.saveToDatabase(position.toString());
        locationDb.getSavedLocation();
      });
    } else {
      Permission.location.request();
    }
    setState(() {});
  }
}
