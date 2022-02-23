import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/providers/daily_tasks_provider.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class DailyTasksScreen extends StatefulWidget {
  static const String routeName = '/dailyTasks';
  const DailyTasksScreen({Key key}) : super(key: key);

  @override
  _DailyTasksScreenState createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  bool isLoading = false;
  bool hasCrashed = false;

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  Future<void> getTasks() async {
    try {
      setState(() {
        isLoading = true;
        hasCrashed = false;
      });
      final tasksData = Provider.of<DailyTasksProvider>(context, listen: false);
      await tasksData.getDailyTasks();
      setState(() {
        isLoading = false;
        hasCrashed = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        hasCrashed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<DailyTasksProvider>(context);
    return Scaffold(
      appBar: GlobalAppBar(
        title: 'المهام اليومية',
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : hasCrashed
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        errorMsg,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextButton(
                        onPressed: getTasks,
                        child: Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : tasksData.dailyTasks.isEmpty
                  ? Center(
                      child: Text('لا يوجد مهام متاحة اليوم'),
                    )
                  : ListView.separated(
                      itemCount: tasksData.dailyTasks.length,
                      itemBuilder: (context, i) {
                        final zekr = tasksData.dailyTasks[i];
                        return ListTile(
                          title: Text(zekr.title),
                          subtitle: Text(zekr.description),
                        );
                      },
                      separatorBuilder: (context, i) {
                        return Divider();
                      },
                    ),
    );
  }
}
