import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test/controller/alarm_controller.dart';
import 'package:test/controller/weather_controller.dart';
import 'package:test/view/home/widgets/list_tile_widgets.dart';

class AlarmHomePage extends StatefulWidget {
  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final alarmModel = Provider.of<AlarmModel>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 53, 53, 46),
      appBar: AppBar(
        title: Text(
          'Times Up!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: _time,
            );
            if (picked != null) {
              DateTime now = DateTime.now();
              DateTime alarmTime = DateTime(
                  now.year, now.month, now.day, picked.hour, picked.minute);
              if (alarmTime.isBefore(now)) {
                alarmTime = alarmTime.add(const Duration(days: 1));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Alarm Set For Tommorrow ${DateFormat.jm().format(alarmTime)}'),
                  ),
                );
              }
              alarmModel.addAlarm(alarmTime);
            }
          },
          child: const Icon(Icons.add)),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Current Weather',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  FutureBuilder(
                      future: WeatherService().getCurrentLocationWeather(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading..');
                        } else if (snapshot.hasError) {
                          return const Text('Unavailable');
                        } else {
                          return Text(snapshot.data!,
                              style: Theme.of(context).textTheme.titleMedium);
                        }
                      }),
                ],
              ),
            ],
          ),
          Expanded(
              child: alarmModel.alarms.length != 0
                  ? ListView.builder(
                      itemCount: alarmModel.alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarmModel.alarms[index];
                        final alarmTime = DateTime.parse(alarm['time']);
                        final formattedTime = DateFormat.jm().format(alarmTime);

                        return ListTileWidget(
                            formattedTime: formattedTime,
                            alarmTime: alarmTime,
                            alarmModel: alarmModel,
                            alarm: alarm);
                      },
                    )
                  : const Center(
                      child: Text('No Alarms'),
                    )),
        ],
      ),
    );
  }
}
