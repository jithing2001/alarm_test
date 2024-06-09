import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/controller/alarm_controller.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.formattedTime,
    required this.alarmTime,
    required this.alarmModel,
    required this.alarm,
  });

  final String formattedTime;
  final DateTime alarmTime;
  final AlarmModel alarmModel;
  final Map<String, dynamic> alarm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(Icons.alarm),
            const SizedBox(
              width: 10,
            ),
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(alarmTime),
                );
                if (picked != null) {
                  DateTime now = DateTime.now();
                  DateTime newTime = DateTime(
                      now.year, now.month, now.day, picked.hour, picked.minute);
                  if (newTime.isBefore(now)) {
                    newTime = newTime.add(const Duration(days: 1));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Alarm Set for tommorrow ${DateFormat.jm().format(newTime)}'),
                      ),
                    );
                  }
                  alarmModel.updateAlarm(alarm['id'], newTime);
                }
              },
              icon: const Icon(Icons.edit),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                alarmModel.deleteAlarm(alarm['id']);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
