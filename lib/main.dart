// import 'package:flutter/material.dart';
// import 'package:test/view/home/home_screen.dart';
// import 'package:timezone/timezone.dart' as tz;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/controller/alarm_controller.dart';
import 'package:test/controller/weather_controller.dart';
import 'package:test/view/splash/splash_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AlarmModel()),
        ChangeNotifierProvider(create: (context) => WeatherService()),
      ],
      child: MaterialApp(
        title: 'Alarm App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
            bodyMedium: TextStyle(color: Colors.white, fontSize: 25),
            titleMedium: TextStyle(color: Colors.white, fontSize: 30),
            titleLarge: TextStyle(color: Colors.white, fontSize: 35),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
