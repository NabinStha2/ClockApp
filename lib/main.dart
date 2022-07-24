import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:clock_app/clock/alarm.dart';
import 'package:clock_app/clock/clock_view.dart';
import 'package:clock_app/clock/models/alarm_model.dart';
import 'package:clock_app/clock/stopwatch_page.dart';
import 'package:clock_app/clock/timer_page.dart';
import 'package:clock_app/clock/widget/DrawerWidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('clock');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => Alarm()),
    // );
  });

  // Directory documentDirectory = await getApplicationDocumentsDirectory();
  // debugPrint(documentDirectory.path);
  // Hive.init(documentDirectory.path);
  // await Hive.openBox("alarm");
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter());
  await Hive.openBox<AlarmModel>("alarm");

  runApp(
    new MaterialApp(
      title: "Community Board",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: AnimatedSplashScreen(
        splash: Container(
          alignment: Alignment.center,
          child: ClipRRect(
            child: Image.asset(
              "assets/images/clock1.png",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        nextScreen: HomePage(),
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.white,
        duration: 1000,
        curve: Curves.bounceOut,
        splashIconSize: 250,
        centered: true,
        splashTransition: SplashTransition.slideTransition,
      ),
    ),
  );
}

_HomePageState? homePageState;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    homePageState = _HomePageState(); // new method
    return homePageState!;
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> screens = [ClockView(), Alarm(), TimerPage(), StopWatchPage()];
  List<String> screenTitle = ["Clock", "Alarm", "Timer", "StopWatch"];
  int index = 0;
  String selectedTile = "Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.001),
        title: Text(
          screenTitle[index],
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.pattaya().fontFamily,
            fontSize: 24.0,
          ),
        ),
        elevation: 0,
      ),
      drawerDragStartBehavior: DragStartBehavior.start,
      drawer: DrawerWidget(),
      drawerEdgeDragWidth: 200,
      drawerEnableOpenDragGesture: true,
      backgroundColor: Colors.white30,
      body: screens[index],
    );
  }
}
