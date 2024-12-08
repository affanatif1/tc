import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'prayerClass.dart';
import 'calendarDisplay.dart';
import 'package:intl/intl.dart';
import 'Qibla.dart';
import 'package:collection/collection.dart';
import 'listView.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'prayer_times_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'event_class.dart';
import 'list_view_events.dart';
import 'contact_names.dart';
import 'listPrograms.dart';
import 'datepicker.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'animationClass.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'colorPicker.dart';
import 'settingsPage.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'actionbuttons.dart';
import 'aboutUs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'boardMemberClass.dart';
import 'listBoardMembers.dart';
import 'localMarketing.dart';
import 'listMarketing.dart';
import 'dart:io';
import 'starsBackground.dart';
import 'splashscreen.dart';
import 'snapBack.dart';
import 'buttonClass.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'notificationService.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform; // For detecting the platform
import 'settingsPageNew.dart';
import 'package:flutter/foundation.dart';
import 'package:upgrader/upgrader.dart';

import 'mainWidgets/prayerTimes.dart';
import 'mainWidgets/datePicker.dart';
import 'mainWidgets/quoteWidget.dart';
import 'mainWidgets/timesTable.dart';

import 'featuredPrograms.dart';

import 'dart:ui'; // This ensures TextDirection is available

import 'iosWidget/widgetClass.dart';
bool isDayTimeValueDrawer = false;

const platform = MethodChannel('com.example.tawheedApp/userDefaults'); // Ensure this is at the top of your Dart file

//import 'package:device_preview/device_preview.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//
//   runApp(
//     DevicePreview(
//       builder: (context) => ChangeNotifierProvider(
//         create: (context) => PrayerTimeProvider(),
//         child: MyAppPrepare(),
//       ),
//     ),
//   );
// }
//

 final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
 FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  //var notifService = NotificationService();
  // notifService.initNotification();

  //NotificationService().initNotification();
  tz.initializeTimeZones();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setInt('counter', 10);

  var didUserEnableNotif = prefs.getBool('didUserEnableNotif') ?? false;
  var notifSettingTemp = prefs.getBool('notifSetting') ?? true;  // Retrieve the value as is, could be null

  print("here is the initial values at start $didUserEnableNotif and $notifSettingTemp");


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);


  // AwesomeNotifications().initialize(
  //   '/Users/affan/AndroidStudioProjects/tawheed_app/android/app/src/main/res/drawable/tc_icon.png', // null or your app icon
  //   [
  //     NotificationChannel(
  //       channelKey: 'scheduled_channel',
  //       channelName: 'Scheduled Notifications',
  //       channelDescription: 'Channel for scheduled notifications',
  //       importance: NotificationImportance.High,
  //       channelShowBadge: true,
  //     ),
  //   ],
  // );

  runApp(

    ChangeNotifierProvider(
      create: (context) => PrayerTimeProvider(),
      child: MyAppPrepare(),
    ),
  );
}

class MyAppPrepare extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenOverlay(),
    // Show splash screen overlay initially
    );
  }
}

class SplashScreenOverlay extends StatefulWidget {
  @override
  _SplashScreenOverlayState createState() => _SplashScreenOverlayState();
}

class _SplashScreenOverlayState extends State<SplashScreenOverlay> {
  late Timer _timer;
  bool _isMainAppLoaded = false;

  @override
  void initState() {
    super.initState();
    _startLoadingMainApp();
  }

  void _startLoadingMainApp() {
    // Start loading main app
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isMainAppLoaded = true; // Set the flag to indicate that the main app is loaded
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_isMainAppLoaded) LoadingScreen(), // Show loading screen if main app is not loaded
        AnimatedOpacity(
          duration: Duration(seconds: 0), // Duration for the opacity animation
          opacity: _isMainAppLoaded ? 1.0 : 0.0, // Set opacity based on the flag
          child: MyApp(), // Show main app (hidden initially)
        ),
      ],
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You can customize the loading screen UI here
      //backgroundColor: Color.fromRGBO(210, 186, 161, 1.0), // Make Scaffold background transparent
      //backgroundColor: Color.fromRGBO(152, 75, 75, 1.0),
      backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgroundLayer09.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.050),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/tawheedLogo.png',
                    height: MediaQuery.of(context).size.width * 0.15,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8), // Add spacing between image and text
                  Text(
                    "TAWHEED CENTER",
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: MediaQuery.of(context).size.width * 0.055,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16), // Add spacing between image/text and loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              )
              // Or any other widget you want to display
            ],
          ),
        ),
      ),
    );
  }
}








class MyApp extends StatefulWidget {



  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer? _timer;

  LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Colors.white], // Default gradient
  );

  DateTime? selectedDate; // Variable to store the selected date
  String? daytime;
  late StreamController<List<PrayerTime>> _prayerTimesController;
  late StreamController<List<PrayerTime>> _calendarController;
  late StreamController<List<ProgramContact>> _contactController;
  late StreamController<List<Event>> _eventController;
  late StreamController<List<LocalMarketing>> _marketingController;
  late StreamController<double> _spacingController;
  late StreamController<List<PrayerTime>> _colorController;
  StreamSubscription<bool>? _notifSubscription;


  late StreamController<List<ButtonClass>> _buttonController;
  bool userSelectedDate = false;

  Color color1 = Color.fromRGBO(196, 215, 245, 1.0);
  Color color2 = Color.fromRGBO(221, 221, 221, 1.0);

  Color textColor = Colors.black;
  Color dashedColor = Color.fromRGBO(56, 56, 56, 1.0);

  String backgroundImage = "assets/backgroundLayer06.png";

  Color arabicColor = Colors.black;
  Color borderColor = Colors.black26;

  Future<List<PrayerTime>>? futurePrayerTimes;

  bool isDayTimeValue = false;

  ui.Image? loadedImage;
  ui.Image? moonImage;
  int a = 2;

  var notifService = NotificationService();


  PrayerNotificationScheduler scheduler = PrayerNotificationScheduler();

  late SharedPreferences prefs;
  late int _notiflock;

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _notiflock = prefs.getInt('notif_lock') ?? 0;

  }

  void handlePermissionChange(bool granted) {
    print("notifSetting was updated! updating now to $granted");

    setupNotifications();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setUpTimedRefresh();
    modifyTraffic("homepage");
     WidgetsFlutterBinding.ensureInitialized();
    // NotificationService().initNotification();
    notifService.initNotification();

    notifService.requestPermissions(notifSettingChangedCallback: handlePermissionChange);


    //NotificationService().requestPermissions(notifSettingChangedCallback: handlePermissionChange);

    //
    // tz.initializeTimeZones();

    //_initializeNotifications(); // Call the method to initialize notifications
    //Noti.initialize(flutterLocalNotificationsPlugin);


    selectedDate = DateTime.now(); // Initialize selectedDate with current date


    // futurePrayerTimes = fetchPrayerTimes(selectedDate: selectedDate);
    // futurePrayerTimes?.then((prayerTimes) {
    //   backgroundColor = getColorsForTime(prayerTimes);
    //   backgroundColor?.then((colors) {
    //     if (colors.isNotEmpty) {
    //       // Do something with colors
    //       print("here is color");
    //       print(colors[0]);
    //     }
    //   });
    // });

    fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());



    _prayerTimesController = StreamController.broadcast();
    _calendarController = StreamController.broadcast();
    _contactController = StreamController.broadcast();
    _eventController = StreamController.broadcast();
    _marketingController = StreamController.broadcast();
    _spacingController = StreamController.broadcast();
    _colorController = StreamController.broadcast();
    _buttonController = StreamController.broadcast();

    //scheduleUpdateAtMidnight(updateDateAndFetchPrayerTimes);


    var currentDate = DateTime.now();

    // Loop for 7 days
    // for (int i = 0; i < 7; i++) {
    //   // Call your setupNotifications function with the current date
    //setupNotifications();
    //   print("current date schedule, $currentDate");
    //   // Move to the next day
    //   currentDate = currentDate.add(Duration(days: 1));
    // }


    _setUpTimedRefresh();
    _fetchAndEmitPrayerTimes();
    _fetchCalendar();
    _fetchContact();
    _fetchEvent();
    _fetchMarketing();
    _fetchSpacing();
    _fetchColor();
    _fetchButton();

    loadImage('assets/sun_new.png').then((img) {
      setState(() {
        loadedImage = img;
      });
    });

    loadImage('assets/new_moon.png').then((img) {
      setState(() {
        moonImage = img;
      });
    });

    double paddingTest = 0.0;

    // String deviceModel = '';
    // DeviceInfoPlugin().iosInfo.then((info) {
    //   deviceModel = info.model;
    //   // After getting the device model, calculate screen dimensions
    //   if (deviceModel == 'iPhone13,1') {
    //     // Adjust width and height for iPhone 13 mini
    //     paddingTest = 8;
    //
    //   }
    // });

  }



  String formatDateOnly(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  Future<void> fetchPrayerTimesAndUpdateBackground({DateTime? selectedDate}) async {


    try {
      print("Starting the new fetch $selectedDate");

      // Determine the selected date, ensuring it's non-null
      selectedDate = await determineSelectedDate() ?? DateTime.now();

      // Initialize a list to hold the prayer times for each of the 7 days
      List<DayPrayerTimes> weeklyPrayerTimes = [];

      // Loop to fetch prayer times for 7 days
      for (int i = 0; i < 7; i++) {
        DateTime dateForDay = selectedDate.add(Duration(days: i));
        List<PrayerTime> prayerTimesForDay = await fetchPrayerTimes(selectedDate: dateForDay);

        // Assuming fetchPrayerTimes returns only one day's prayer times as a list
        if (prayerTimesForDay.isNotEmpty) {
          PrayerTime times = prayerTimesForDay.first;

          // Create DayPrayerTimes for this specific day with the formatted date
          weeklyPrayerTimes.add(DayPrayerTimes(
            date: formatDateOnly(dateForDay), // Format the date as yyyy-MM-dd
            fajrAzan: times.fajrAzan,
            fajrIqama: times.fajrIqama,
            sunrise: times.sunrise,
            dhuhrAzan: times.dhuhrAzan,
            dhuhrIqama: times.dhuhrIqama,
            asrAzan: times.asrAzan,
            asrIqama: times.asrIqama,
            magribAzan: times.magribAzan,
            magribIqama: times.magribIqama,
            ishaAzan: times.ishaAzan,
            ishaIqama: times.ishaIqama,
          ));
        }
      }

      // Set 'today' to selectedDate, which is now non-null
      DateTime today = selectedDate;

      // Fetch today's prayer times as List<PrayerTime> for the background and sink update
      List<PrayerTime> todayPrayerTimes = await fetchPrayerTimes(selectedDate: today);

      // Determine the background gradient based on today's prayer times
      LinearGradient newBackgroundGradient = determineBackgroundGradient(todayPrayerTimes);

      // Update the state to apply the new background gradient
      _prayerTimesController.sink.add(todayPrayerTimes);
      setState(() {
        backgroundGradient = newBackgroundGradient;
      });

      print("Sending to widget! Here are the prayer times for the week:");
      for (var day in weeklyPrayerTimes) {
        print("Date: ${day.date}");
        print("Fajr: Azan ${day.fajrAzan}, Iqama ${day.fajrIqama}");
        print("Sunrise: ${day.sunrise}");
        print("Dhuhr: Azan ${day.dhuhrAzan}, Iqama ${day.dhuhrIqama}");
        print("Asr: Azan ${day.asrAzan}, Iqama ${day.asrIqama}");
        print("Maghrib: Azan ${day.magribAzan}, Iqama ${day.magribIqama}");
        print("Isha: Azan ${day.ishaAzan}, Iqama ${day.ishaIqama}");
      }

      // Create WidgetData instance and encode it to JSON format
      WidgetData widgetData = WidgetData(weeklyPrayerTimes);
      String jsonData = jsonEncode(widgetData.toJson());

      // Save to WidgetKit using the specified App Group
      WidgetKit.setItem(
        'widgetData',
        jsonData,
        'group.tawheedwidget',  // App Group identifier for sharing with the widget
      );
      print("Data saved to WidgetKit for widget.");

      // Reload widget timelines to reflect the updated data
      WidgetKit.reloadAllTimelines();
      print("WidgetKit timelines reloaded.");

    } catch (e) {
      print("Error fetching prayer times: $e");
    }
  }




  void savePrayerTimesData(WidgetData widgetData) {
    final jsonData = jsonEncode(widgetData.toJson());

    // Save to WidgetKit using the specified App Group
    WidgetKit.setItem(
      'widgetData',
      jsonData,
      'group.tawheedwidget',  // App Group identifier for sharing with the widget
    );
    print("Data saved to WidgetKit for widget.");

    // Reload widget timelines to reflect the updated data
    WidgetKit.reloadAllTimelines();
    print("WidgetKit timelines reloaded.");
  }


  Future<WidgetData?> readPrayerTimesData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('widgetData');

    // Check if data exists
    if (jsonData == null) {
      print("No prayer times data found in SharedPreferences.");
      return null;
    }

    // Decode JSON data into WidgetData
    final Map<String, dynamic> dataMap = jsonDecode(jsonData);
    final widgetData = WidgetData.fromJson(dataMap);

    print("Prayer times data loaded from SharedPreferences:\n${widgetData.toString()}");
    return widgetData;
  }



  Future<void> setupNotifications() async {



    try {
      List<PrayerTime> prayerTimes = await fetchPrayerTimes_Notification();
      print("Fetched prayer times for notifications successfully.");

      print("fetched times2 $prayerTimes");
      // Convert PrayerTime objects to Map<String, String>
      List<Map<String, String>> prayerTimesMap = prayerTimes.map((prayerTime) {
        return {
          'DateText': prayerTime.dateText,
          'FajrAzan': prayerTime.fajrAzan,
          'FajrIqama': prayerTime.fajrIqama,
          'Sunrise': prayerTime.sunrise,
          'DhuhrAzan': prayerTime.dhuhrAzan,
          'DhuhrIqama': prayerTime.dhuhrIqama,
          'AsrAzan': prayerTime.asrAzan,
          'AsrIqama': prayerTime.asrIqama,
          'MagribAzan': prayerTime.magribAzan,
          'MagribIqama': prayerTime.magribIqama,
          'IshaAzan': prayerTime.ishaAzan,
          'IshaIqama': prayerTime.ishaIqama,
          'Hijri': prayerTime.hijri,
          'jumma_1': prayerTime.jumma_1,
          'jumma_2': prayerTime.jumma_2,

        };
      }).toList();

      print("here is list2: $prayerTimesMap");

      // Schedule notifications
      await scheduler.schedulePrayerNotifications(prayerTimesMap, notifService);


    } catch (e) {
      // Handle errors appropriately
      print("Error fetching prayer times2: $e");
    }
  }




  // Future<void> setupNotifications({DateTime? selectedDate}) async {
  //   try {
  //     tzdata.initializeTimeZones();
  //     tz.setLocalLocation(tz.getLocation('America/New_York')); // Set the time zone to EST
  //
  //     List<PrayerTime> prayerTimes = await fetchPrayerTimes(selectedDate: selectedDate);
  //
  //     DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd h:mm a");
  //     DateTime date = selectedDate ?? DateTime.now();
  //     String dateString = DateFormat("yyyy-MM-dd").format(date);
  //
  //     for (var prayer in prayerTimes) {
  //       List<Map<String, String>> times= [
  //         {'title': 'Fajr', 'time': prayer.fajrAzan, 'iqama': prayer.fajrIqama},
  //         {'title': 'Sunrise', 'time': prayer.sunrise, 'iqama': prayer.fajrIqama},
  //         {'title': 'Dhuhr', 'time': prayer.dhuhrAzan, 'iqama': prayer.dhuhrIqama},
  //         {'title': 'Asr', 'time': prayer.asrAzan, 'iqama': prayer.asrIqama},
  //         {'title': 'Maghrib', 'time': prayer.magribAzan, 'iqama': prayer.magribIqama},
  //         {'title': 'Isha', 'time': prayer.ishaAzan, 'iqama': prayer.ishaIqama},
  //       ];
  //
  //       for (var prayerTime in times) {
  //         // Ensure the AM/PM indicator is in lowercase for consistency with the format
  //         String timeString = "${prayerTime['time']!.toUpperCase()}";
  //         // Combine the date and time, adjusting the AM/PM part to lowercase
  //         String dateTimeString = "$dateString $timeString";
  //
  //         try {
  //           DateTime scheduleDateTime = tz.TZDateTime.from(dateTimeFormat.parse(dateTimeString), tz.local); // Parse with EST time zone
  //           int notificationId = UniqueKey().hashCode;
  //
  //           await AwesomeNotifications().createNotification(
  //             content: NotificationContent(
  //               id: notificationId,
  //               channelKey: 'scheduled_channel',
  //               title: "${prayerTime['title']} Prayer Time",
  //               body: "It's time for ${prayerTime['title']} prayer.",
  //             ),
  //
  //
  //             schedule: NotificationCalendar.fromDate(date: scheduleDateTime),
  //           );
  //
  //           print("this is the date it is scheduling");
  //           print(scheduleDateTime);
  //
  //          // print("Scheduled ${prayerTime['title']} Notification for $scheduleDateTime");
  //         } catch (e) {
  //           print("Error parsing prayer time '${prayerTime['time']}': $e");
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print("Error setting up notifications: $e");
  //   }
  // }






  // Future<void> setupInitialNotifications({DateTime? selectedDate}) async {
  //   try {
  //
  //     List<PrayerTime> prayerTimes = await fetchPrayerTimes(selectedDate: selectedDate);
  //     // Determine the background gradient based on current time and fetched prayer times
  //
  //
  //     for (PrayerTime prayerTime in prayerTimes) {
  //       await scheduler.schedulePrayerNotifications(prayerTime, selectedDate);
  //     }
  //
  //
  //   } catch (e) {
  //     // Handle errors appropriately
  //     print("Error fetching prayer times: $e");
  //   }
  // }



  // Future<void> _schedulePrayerNotifications(PrayerTime prayer, DateTime? selectedDate) async {
  //   NotificationService notificationService = NotificationService();
  //
  //   // First, cancel all previously scheduled notifications
  //   await notificationService.notificationsPlugin.cancelAll();
  //
  //   DateTime date = selectedDate ?? DateTime.now();
  //
  //   // Define a list of all prayer times you want to schedule notifications for
  //   List<Map<String, String>> prayerTimes = [
  //     {'title': 'Fajr', 'time': prayer.fajrAzan},
  //     {'title': 'Sunrise', 'time': prayer.sunrise},
  //     {'title': 'Dhuhr', 'time': prayer.dhuhrAzan},
  //     {'title': 'Asr', 'time': prayer.asrAzan},
  //     {'title': 'Maghrib', 'time': prayer.magribAzan},
  //     {'title': 'Isha', 'time': prayer.ishaAzan},
  //   ];
  //
  //
  //
  //   // Loop over each prayer time to schedule a notification
  //   for (var prayerTime in prayerTimes) {
  //     // Ensure the DateFormat pattern matches your time string format, adjusting for AM/PM marker case
  //     DateFormat dateFormat = DateFormat("h:mm a");
  //
  //     // Adjust the time string to match the expected case for AM/PM
  //     String adjustedTime = prayerTime['time']!.toUpperCase(); // Convert AM/PM to uppercase
  //
  //     try {
  //       DateTime parsedTime = dateFormat.parse(adjustedTime);
  //       DateTime scheduleDateTime = DateTime(date.year, date.month, date.day, parsedTime.hour, parsedTime.minute);
  //
  //       // Schedule the notification
  //       int notificationId = UniqueKey().hashCode;
  //       await notificationService.scheduleNotification(
  //         id: notificationId,
  //         title: "${prayerTime['title']} Time",
  //         body: "It's time for ${prayerTime['title']} prayer",
  //         scheduledNotificationDateTime: scheduleDateTime,
  //       );
  //
  //       // Log for debugging
  //       print("Scheduled Notification - ID: $notificationId, Title: ${prayerTime['title']} Time, Body: It's time for ${prayerTime['title']} prayer, Scheduled for: $scheduleDateTime");
  //
  //     } catch (e) {
  //       // If parsing fails, log the error
  //       print("Error parsing prayer time '${prayerTime['time']}': $e");
  //     }
  //   }
  //
  // }



  LinearGradient determineBackgroundGradient(List<PrayerTime> prayerTimes) {
    // Assuming prayerTimes is not empty and has at least one PrayerTime object for the current day

    print("starting to calculate the new background gradient");
    PrayerTime todayPrayerTimes = prayerTimes.first;

    // Parse the current date
    DateTime now = DateTime.now();

    // Helper function to parse time strings into DateTime objects
    DateTime parsePrayerTime(String time) {
      // Splitting the time string by space to separate the time and am/pm part
      final parts = time.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Adjusting hours based on am/pm
      if (parts[1].toLowerCase() == 'pm' && hour != 12) {
        hour += 12; // Convert pm times to 24-hour format, except for 12 pm (noon)
      } else if (parts[1].toLowerCase() == 'am' && hour == 12) {
        hour = 0; // Convert 12 am to 00 hours
      }

      DateTime now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    }

    print("sunrise time maghrib time");

    // Parse the prayer times for sunrise and sunset
    DateTime sunriseTime = parsePrayerTime(todayPrayerTimes.sunrise);
    DateTime maghribTime = parsePrayerTime(todayPrayerTimes.magribAzan);
    Color color1 = Color.fromRGBO(135, 206, 235, 1.0);
    Color color2 = Color.fromRGBO(250, 250, 250, 1.0);
    print(sunriseTime);
    print(maghribTime);

    //Color.fromRGBO(165, 225, 250, 1.0);

    // Determine the gradient based on current time
    if (now.isAfter(sunriseTime) && now.isBefore(maghribTime)) {
      // Gradient for post-sunrise and pre-sunset
      print("linear gradient 1");

      //textColor = Color.fromRGBO(26, 26, 26, 1.0);
      textColor = Color.fromRGBO(50, 50, 50, 1.0);
      dashedColor = Color.fromRGBO(56, 56, 56, 1.0);
      arabicColor = Color.fromRGBO(140, 116, 29, 1.0);
      //arabicColor = Color.fromRGBO(0, 110, 14, 1.0);
      borderColor = Color.fromRGBO(100, 100, 100, 1.0);
      backgroundImage = "assets/backgroundLayerDay03.png";
      isDayTimeValue = true;
      isDayTimeValueDrawer = true;

      setStatusBarTextColor(true);


      //Color.fromRGBO(138, 170, 243, 1.0)
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        //colors: [Color.fromRGBO(196, 215, 245, 1.0), Color.fromRGBO(221, 221, 221, 1.0)], // Example colors
        //colors: [Color.fromRGBO(157, 183, 243, 1.0), Color.fromRGBO(221, 221, 221, 1.0)],
        //colors: [Color.fromRGBO(138, 170, 243, 1.0), Color.fromRGBO(221, 221, 221, 1.0)],
        colors: [Color(0xFFACBFE1), Color.fromRGBO(250, 250, 250, 1.0)],
        //colors: [Color.fromRGBO(107, 164, 235, 1.0),Color.fromRGBO(197, 227, 255, 1.0),  Color.fromRGBO(182, 226, 253, 1.0)],
       // colors: [Color.fromRGBO(107, 164, 235, 1.0),Color.fromRGBO(197, 227, 255, 1.0),  Color.fromRGBO(230, 230, 230, 1.0)],

      );
    } else {
      print("linear gradient 2");
      textColor = Colors.white.withOpacity(0.90);
      dashedColor = Colors.white.withOpacity(0.90);
      arabicColor = Color.fromRGBO(194, 161, 43, 1.0);
      borderColor = Colors.black26;
      backgroundImage = "assets/backgroundLayer15.png";
      isDayTimeValue = false;
      isDayTimeValueDrawer = false;

      setStatusBarTextColor(false);


      // Gradient for post-sunset and pre-sunrise
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        //colors: [Color.fromRGBO(123, 140, 171, 1.0), Color.fromRGBO(221, 221, 221, 1.0)], // Example colors
        //colors: [Color.fromRGBO(0, 60, 132, 1.0), Color.fromRGBO(4, 143, 209, 1.0)], // Example colors
        //colors: [Color.fromRGBO(1, 58, 115, 1.0), Color.fromRGBO(1, 78, 130, 1.0)],
        // colors: [Color.fromRGBO(3, 38, 54, 1.0), Color.fromRGBO(36, 80, 99, 1.0)],
        //colors: [Color.fromRGBO(17, 25, 64, 1.0), Color.fromRGBO(47, 58, 110, 1.0)],
        colors: [Color.fromRGBO(16, 20, 41, 1.0), Color.fromRGBO(45, 82, 128, 1.0)],
      );
    }
  }

  // Future<void> _initializeNotifications() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await NotificationService().initNotification(); // Initialize notifications
  //
  //   DateTime scheduleTime = DateTime(2024, 3, 16, 16, 29); // Year, Month, Day, Hour, Minute
  //   //debugPrint('Notification Scheduled for $scheduleTime');
  //   await NotificationService().scheduleNotification(
  //     title: 'Scheduled Notification',
  //     body: '$scheduleTime',
  //     scheduledNotificationDateTime: scheduleTime,
  //   );
  // }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel(); // Cancel the timer when the widget is disposed


    _prayerTimesController.close();
    _calendarController.close();
    _contactController.close();
    _eventController.close();
    _marketingController.close();
    _spacingController.close();
    _colorController.close();
    _buttonController.close();


    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App is resumed, trigger a rebuild to update the sun's position
      setState(() {});
      print("trigger reactivated!");

      fetchEvents().then((data) {
          _eventController.add(data);
        });
      datePickerKey.currentState?.resetSelectedDate();


      _fetchAndEmitPrayerTimesResumed();

      modifyTraffic("homepage");

      var currentDate = DateTime.now();

      // //Loop for 7 days
      // for (int i = 0; i < 7; i++) {
      //   // Ensure setupNotifications completes before continuing
      //   try {
      //     await setupNotifications(selectedDate: currentDate);
      //     print("Completed scheduling for date: $currentDate");
      //   } catch (e) {
      //     print("An error occurred2: $e");
      //   }
      //
      //   currentDate = currentDate.add(Duration(days: 1));
      //
      // }




    }
  }

  void _refreshParent() {
    setState(() {
      // This code will rebuild Class 1
    });
  }

  Future<ui.Image> loadImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List(); // Correctly returns Uint8List
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }


  Future<DateTime?> determineSelectedDate() async {


    var currentDate = DateTime.now();
    if (userSelectedDate == true){
      //selectedDate = newDate;
    } else {
      selectedDate = currentDate;
    }


    print("returning the selected date $selectedDate");
    return selectedDate;
  }

  Future<void> _fetchAndEmitPrayerTimes() async {

    print("starting another round1! $selectedDate");

    var currentDate = DateTime.now();

    selectedDate = await determineSelectedDate();
    print("starting another round2! $selectedDate");

    fetchPrayerTimesAndUpdateBackground(selectedDate: selectedDate);

    final prayerTimes = await fetchPrayerTimes(selectedDate: selectedDate);

    setupNotifications();
    //determineBackgroundGradient(prayerTimes);

    //backgroundColors = getColorsForTime(prayerTimes);
    _prayerTimesController.sink.add(prayerTimes);

  }


  Future<void> _fetchAndEmitPrayerTimesResumed() async {

    print("starting another round!");
    var currentDate = DateTime.now();

    selectedDate = currentDate;


    fetchPrayerTimesAndUpdateBackground(selectedDate: selectedDate);

    final prayerTimes = await fetchPrayerTimes(selectedDate: selectedDate);

    //determineBackgroundGradient(prayerTimes);

    //backgroundColors = getColorsForTime(prayerTimes);
    setupNotifications();
    _prayerTimesController.sink.add(prayerTimes);

  }

  Future<void> _fetchCalendar() async {
    final prayerTimes = await fetchPrayerTimes2();
    _calendarController.sink.add(prayerTimes);
  }

  Future<void> _fetchContact() async {
    final prayerTimes = await fetchProgramNames();
    _contactController.sink.add(prayerTimes);
  }

  Future<void> _fetchEvent() async {
    final prayerTimes = await fetchEvents();
    _eventController.sink.add(prayerTimes);
  }

  Future<void> _fetchMarketing() async {
    final prayerTimes = await fetchLocalMarketing();
    _marketingController.sink.add(prayerTimes);
  }

  // Future<void> _fetchSpacing() async {
  //   final prayerTimes = await _checkDevice();
  //   _spacingController.sink.add(prayerTimes);
  // }

  Future<void> _fetchSpacing() async {
    final prayerTimes = await getMaxScreenHeight();
    _spacingController.sink.add(prayerTimes);
  }

  Future<void> _fetchColor() async {
    final prayerTimes = await fetchButtonData();
    _buttonController.sink.add(prayerTimes);
  }


  Future<void> _fetchButton() async {
    final prayerTimes = await fetchPrayerTimes(selectedDate: selectedDate);
    _colorController.sink.add(prayerTimes);
  }

  // void _setUpTimedRefresh() {
  //   // Immediately fetch and emit prayer times at the start
  //   _fetchAndEmitPrayerTimes();
  //
  //   // Calculate the delay until the start of the next minute
  //   final now = DateTime.now();
  //   final initialDelaySeconds = 60 - now.second;
  //   final initialDelay = Duration(seconds: initialDelaySeconds);
  //
  //   // Schedule the first refresh to happen at the start of the next minute
  //   Timer(initialDelay, () {
  //     _fetchAndEmitPrayerTimes();
  //     fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());
  //
  //     // Set up a periodic timer that triggers every minute thereafter
  //     Timer.periodic(Duration(minutes: 1), (Timer t) {
  //       // Fetch and emit prayer times
  //       _fetchAndEmitPrayerTimes();
  //       fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());
  //     });
  //   });
  // }
  // void _setUpTimedRefresh() {
  //   // Immediately fetch and emit prayer times at the start
  //   _fetchAndEmitPrayerTimes2();
  //   fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());
  //
  //   // Function to calculate delay until the start of the next minute
  //   Duration _calculateDelayUntilNextMinute() {
  //     final now = DateTime.now();
  //     final secondsToWait = 60 - now.second;
  //
  //     // If the current second is 0, we're already at the start of the minute,
  //     // so we should wait for the next minute boundary.
  //     if (now.second == 0) {
  //       return Duration.zero; // Trigger immediately
  //     } else {
  //       // Otherwise, calculate the delay until the next minute starts
  //       return Duration(seconds: secondsToWait);
  //     }
  //   }
  //
  //
  //
  //   // Calculate the initial delay
  //   final initialDelay = _calculateDelayUntilNextMinute();
  //
  //   // Schedule the first refresh to happen at the start of the next minute
  //   Future.delayed(initialDelay, () {
  //     // Fetch and emit prayer times at the start of the next minute
  //     _fetchAndEmitPrayerTimes();
  //     fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());
  //
  //     // Set up a periodic timer that triggers every minute thereafter
  //     Timer.periodic(Duration(minutes: 1), (Timer t) {
  //       // Fetch and emit prayer times
  //       _fetchAndEmitPrayerTimes();
  //       fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());
  //     });
  //   });
  // }

  void _setUpTimedRefresh() {
    // Method to fetch and emit prayer times
    void _fetchAndEmitPrayerTimes() {
      // Your existing code to fetch and emit prayer times
      fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());

    }

    // Function to calculate delay until the start of the next minute
    Duration _calculateDelayUntilNextMinute() {
      final now = DateTime.now();
      final secondsToWait = 60 - now.second;
      return Duration(seconds: (now.second == 0) ? 60 : secondsToWait);
    }

    // Function to setup a timer that executes at the start of the next minute
    void _setupNextExecution() {
      final now = DateTime.now();
      final delay = _calculateDelayUntilNextMinute();
      final nextExecutionTime = now.add(delay);

      // Log the next execution time
      print('Next execution will be at: $nextExecutionTime with this date $DateTime.now()');

      Future.delayed(delay, () {
        _fetchAndEmitPrayerTimes(); // Execute your task
        fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());

        _setupNextExecution(); // Recursively setup the next execution
      });
    }

    // Initial call to fetch and emit prayer times immediately (if needed) and setup the first execution
    _fetchAndEmitPrayerTimes(); // Optional: remove if you don't need an immediate execution
    _setupNextExecution(); // Setup the first delayed execution
  }




  void _fetchAndEmitPrayerTimes2() {
    // Your code to fetch and emit prayer times
    fetchPrayerTimesAndUpdateBackground(selectedDate: DateTime.now());
  }

  void onDrawerClose() {
    setState(() {
      // Your state update logic here
      print("Drawer closed - state updated!");
      _fetchAndEmitPrayerTimesResumed();
      datePickerKey.currentState?.resetSelectedDate();

      fetchEvents().then((data) {
        _eventController.add(data);
      });
      fetchPrayerTimes2().then((data) {
        _calendarController.add(data);
      });

      datePickerKey.currentState?.resetSelectedDate();


    });
  }




  // void _setUpTimedRefresh() {
  //   // Calculate the current time and the start of the next minute
  //   DateTime now = DateTime.now();
  //   DateTime nextMinute = DateTime(now.year, now.month, now.day, now.hour, now.minute).add(Duration(minutes: 1));
  //
  //   // Calculate the duration until the start of the next minute
  //   Duration initialDelay = nextMinute.difference(now);
  //
  //   // First timer: wait until the start of the next minute
  //   Timer(initialDelay, () {
  //     // Fetch and emit prayer times immediately at the start of the next minute
  //     _fetchAndEmitPrayerTimes();
  //
  //     // Then, start a periodic timer that triggers every minute
  //     Timer.periodic(Duration(minutes: 1), (Timer t) {
  //       _fetchAndEmitPrayerTimes();
  //       //_fetchCalendar();
  //     });
  //   });
  // }

  // void _setUpTimedRefresh2() {
  //   final now = DateTime.now();
  //   final nextMinute = DateTime(now.year, now.month, now.day, now.hour, now.minute).add(Duration(minutes: 1));
  //   final secondsUntilNextMinute = nextMinute.difference(now).inSeconds;
  //
  //   Future.delayed(Duration(seconds: secondsUntilNextMinute), () {
  //     // This is the first trigger at the top of the next minute.
  //     if (mounted) {
  //       setState(() {});
  //     }

  // void _setUpTimedRefresh() {
  //   final now = DateTime.now();
  //   final nextMinute = DateTime(now.year, now.month, now.day, now.hour, now.minute).add(Duration(minutes: 1));
  //   final secondsUntilNextMinute = nextMinute.difference(now).inSeconds;
  //
  //   Future.delayed(Duration(seconds: secondsUntilNextMinute), () {
  //     // This is the first trigger at the top of the next minute.
  //     if (mounted) {
  //       setState(() {});
  //     }
  //
  //     // Now set up a periodic timer to trigger every minute.
  //     _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     });
  //   });
  // }


  void updateDateAndFetchPrayerTimes(DateTime newDate) {


    setState(() {


    });
    _fetchAndEmitPrayerTimes(); // Fetch and emit updated prayer times
  }

  void scheduleUpdateAtMidnight(void Function(DateTime) updateFunction) {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1);

    Duration durationUntilMidnight = nextMidnight.difference(now);

    Timer(Duration(milliseconds: durationUntilMidnight.inMilliseconds), () {
      DateTime newDate = DateTime.now(); // Or any new date you want to pass
      updateFunction(newDate);
    });
  }



  Future<List<PrayerTime>> _onDateSelected(DateTime newDate) async {
    print('Attempting to select new date: $newDate');
    if (selectedDate == null || !newDate.isAtSameMomentAs(selectedDate!)) {
      print('Updating date to $newDate from $selectedDate');
      setState(() {
        selectedDate = newDate;
      });

      print('Fetching prayer times for $newDate');
      return fetchPrayerTimes(selectedDate: newDate);
    } else {
      print('Selected date $newDate is the same as existing date $selectedDate. Skipping fetch.');
    }
    return Future.value([]); // Adjust based on your needs
  }


  void openDrawerAndListen(BuildContext context) {
    _scaffoldKey.currentState?.openEndDrawer(); // Open the drawer

    // Listen for the drawer being closed
    var previousRoutes = ModalRoute.of(context)?.isCurrent ?? false;
    ModalRoute.of(context)?.navigator?.userGestureInProgressNotifier.addListener(() {
      bool isPopped = previousRoutes && !(ModalRoute.of(context)?.isCurrent ?? true);
      if (isPopped) {
        print("drawer was closed!");
        // Drawer was closed
        // Run your setState() or any other logic here
        setState(() {
          // Your state update logic here
        });

        // Remove the listener if it's not needed anymore
        ModalRoute.of(context)?.navigator?.userGestureInProgressNotifier.removeListener(() {});
      }
    });
  }
  void updateAndFetchPrayerTimes(DateTime newDate) {



    setState(() {
      selectedDate = newDate;
    });
    // Now, fetch the prayer times with the updated date.
    // This ensures the fetch uses the latest selected date.
    fetchPrayerTimes(selectedDate: selectedDate).then((prayerTimes) {
      // Handle the fetched prayer times here.
      // This could involve another setState to update the UI,
      // or other logic to process the prayer times.
      //backgroundColors = getColorsForTime(prayerTimes);

      // backgroundColors[0] = getColorsForTime(prayerTimes)[0];
      // backgroundColors[1] = getColorsForTime(prayerTimes)[1];


    }).catchError((error) {
      // Handle any errors that occur during fetch.
      print("Error fetching prayer times: $error");
    });
  }


  void setStatusBarTextColor(bool isDayTime) {

    print("changing status bar color!");
    SystemChrome.setSystemUIOverlayStyle(
      isDayTime
          ? SystemUiOverlayStyle.dark // Set light text color for day
          : SystemUiOverlayStyle.light, // Set dark text color for night
    );
  }


  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceModel = '';

  bool isDayTime(DateTime currentTime) {
    int currentHour = currentTime.hour;

    // Assuming daytime is from 6 AM to 6 PM
    return currentHour >= 6 && currentHour < 18;
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<DatePickerWidgetState> datePickerKey = GlobalKey<DatePickerWidgetState>();




  @override
  Widget build(BuildContext context) {
    bool _isCurrentPrayerTime(String prayerTime) {
      final now = DateTime.now();
      final format = DateFormat.jm(); // Adjust format if necessary
      final currentTime = format.parse(format.format(now));
      final prayerDateTime = format.parse(prayerTime);

      // Example condition, adjust according to how you want to handle "current" prayer time
      return currentTime.isAfter(
          prayerDateTime.subtract(Duration(minutes: 30))) &&
          currentTime.isBefore(prayerDateTime.add(Duration(minutes: 30)));
    }

    String currentPrayerName = "";

    double screenHeight = MediaQuery.of(context).size.height;
    double spaceHeight = screenHeight / 18;

    setStatusBarTextColor(isDayTimeValue);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },


      theme: ThemeData(
        useMaterial3: false,  // Disable Material 3 here

        //scaffoldBackgroundColor: Color(0xFFC9AD85),
        //scaffoldBackgroundColor: Color(0xFF3B6C47),
        //scaffoldBackgroundColor: Color(0xFF89A489),
        // scaffoldBackgroundColor: Color(0xFF7FB47F),
        //scaffoldBackgroundColor: Color(0xFF95B295),
        //scaffoldBackgroundColor: Color(0xFFCFDACF),

        // scaffoldBackgroundColor: Color(0xFFACBFE1),
        //scaffoldBackgroundColor: Color(0xFF485A7C),
        //scaffoldBackgroundColor: Color(0xFF6F8ABE),
        // scaffoldBackgroundColor: Color(0xA91F53D7),
        //scaffoldBackgroundColor: Colors.black,

        textTheme: TextTheme(

          bodyText1: TextStyle(fontFamily: 'AvenirNextCondensedDemiBold'),
          bodyText2: TextStyle(fontFamily: 'AvenirNextCondensedDemiBold'),
          // Define other TextStyle objects as needed
        ),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        // Step 2: Assign the GlobalKey to your Scaffold
        endDrawer: CustomDrawer(
          onDrawerClose: onDrawerClose,
        ),       // appBar: AppBar(
        //   title: Text('Side menu'),
        // ),
    body: Scrollbar(
      thumbVisibility: true,
      thickness: 5,
      radius: Radius.circular(12),


      child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),

        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomCenter,
            //   colors: [Color(0xFFACBFE1), Color.fromRGBO(250, 250, 250, 1.0)], // specify your gradient colors
            // ),
            gradient: backgroundGradient,
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              // Replace with your image asset path
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.mode(
              //   Colors.black.withOpacity(0.050),
              //   // Change the opacity here
              //   BlendMode
              //       .dstATop, // This blend mode applies the color filter on top of the image
              // ), // This will fill the background of the Scaffold
            ),
          ),

          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: spaceHeight * 0.8),

                  PrayerTimesWidget(
                    prayerTimesStream: _prayerTimesController.stream,
                  ),



                  FeaturedPrograms(
                    isDayTimeValue: isDayTimeValue,
                  ),



                        Container(
                          width: MediaQuery.of(context).size.width,
                          // No need to set height to 0; we conditionally render the child
                          child: // Use SizedBox.shrink() to ensure no space is taken
                          StreamBuilder<List<PrayerTime>>(
                            stream: _prayerTimesController.stream,
                            builder: (BuildContext context, AsyncSnapshot<List<PrayerTime>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (snapshot.hasData) {
                                final todayPrayerTimes = snapshot.data![0];


                                return Padding(
                                  padding: EdgeInsets.only(top: 0, bottom: 15),
                                  child: CustomPaint(
                                    painter: SineGraphPainter(
                                      dashedColor: dashedColor,
                                      amplitude: 0,
                                      prayerTimes: [
                                        timeToDecimal(todayPrayerTimes.fajrAzan) ?? 0.0,
                                        timeToDecimal(todayPrayerTimes.sunrise) ?? 0.0,
                                        timeToDecimal(todayPrayerTimes.dhuhrAzan) ?? 0.0,
                                        timeToDecimal(todayPrayerTimes.asrAzan) ?? 0.0,
                                        timeToDecimal(todayPrayerTimes.magribAzan) ?? 0.0,
                                        timeToDecimal(todayPrayerTimes.ishaAzan) ?? 0.0,
                                      ],
                                      sunImage: loadedImage!,
                                      moonImage: moonImage!,
                                    ),
                                    size: Size(MediaQuery.of(context).size.width, 30), // Conditionally set size
                                  ),
                                );
                              } else {
                                return Text("No data available");
                              }
                            },
                          ),
                        ),



                        SpacingAndQuoteWidget(
                          spacingStream: _spacingController.stream,
                          arabicColor: arabicColor, // Replace with actual color
                          textColor: textColor,  // Replace with actual color
                          borderColor: borderColor,
                        ),








                  //SizedBox(height: 5), // Add vertical spacing here

                  // Container(
                  //   width: MediaQuery
                  //       .of(context)
                  //       .size
                  //       .width * 0.8,
                  //   height: 0.75,
                  //   color: Colors.black,
                  // ),
                  // Boxes row

                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.010),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            double screenWidth = MediaQuery
                                .of(context)
                                .size
                                .width * 0.9;
                            double buttonWidth = screenWidth / 3.5;

                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.15),
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.black26, width: 2),
                                  ),
                                ),
                                onPressed: () async {
                                  Vibrate.feedback(FeedbackType.light);
                                  const url = 'https://us.mohid.co/mi/detroit/tawheedcenter/masjid/online/donation';
                                  if (await canLaunch(url)) {
                                    await launch(
                                      url,
                                      forceSafariVC: false,
                                      forceWebView: false,
                                      enableJavaScript: true,
                                    );
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    double iconSize = constraints.maxHeight * 0.5;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        FittedBox(
                                          child: Icon(
                                            Icons.monetization_on_outlined,
                                            color: textColor,
                                            size: iconSize,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Flexible(
                                          child: FittedBox(
                                            child: Text(
                                              'Donate',
                                              style: TextStyle(
                                                color: textColor,
                                                fontFamily: 'AvenirNextMedium',
                                                //fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );

                          },
                        ),
                        // StreamBuilder<List<Event>>(
                        //   stream: _eventController.stream,
                        //   builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
                        //     double screenWidth = MediaQuery.of(context).size.width;
                        //     double buttonWidth = screenWidth / 3.5;
                        //
                        //     if (snapshot.connectionState == ConnectionState.waiting) {
                        //       return CircularProgressIndicator(); // Show loading indicator while waiting for data
                        //     } else if (snapshot.hasError) {
                        //       return Text("Error: ${snapshot.error}"); // Show error if something went wrong
                        //     } else if (snapshot.hasData) {
                        //       // Assuming 'Event' is a defined class and snapshot.data is a list of Event objects
                        //
                        //       return LayoutBuilder(
                        //         builder: (context, constraints) {
                        //           // Calculate icon size as a fraction of button width or height, whichever is smaller
                        //           double iconSize = constraints.maxHeight < buttonWidth ? constraints.maxHeight * 0.175 : buttonWidth * 0.175;
                        //
                        //           return SizedBox(
                        //             width: MediaQuery.of(context).size.width * 0.20,
                        //             height: MediaQuery.of(context).size.width * 0.15,
                        //             child: TextButton(
                        //               style: TextButton.styleFrom(
                        //                 backgroundColor: Colors.white.withOpacity(0.1),
                        //                 primary: Colors.white,
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(8),
                        //                   side: BorderSide(color: Colors.black26, width: 2),
                        //                 ),
                        //               ),
                        //               onPressed: () {
                        //                 if (snapshot.hasData) {
                        //                   // Pass the entire list of prayer times to the PrayerTimesTable
                        //                   Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                       builder: (context) => MyApp3(),
                        //                     ),
                        //                   );
                        //                 } else {
                        //                   // Handle the case where there is no data
                        //                   print("No prayer times data available");
                        //                 }
                        //               },
                        //               child: IconTheme(
                        //                 data: IconThemeData(
                        //                   size: iconSize,
                        //                   color: Colors.black,
                        //                 ),
                        //                 child: Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: <Widget>[
                        //                     Icon(Icons.chair_outlined, color: Colors.black),
                        //                     SizedBox(height: 4),
                        //                     Flexible(
                        //                       child:
                        //                       FittedBox(
                        //                         child: Text(
                        //                           'Qibla',
                        //                           style: TextStyle(color: Colors.black),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //       );
                        //     } else {
                        //       return Text("No data available"); // Show this message if there's no data
                        //     }
                        //   },
                        // ),


                        Builder(
                          builder: (BuildContext context) {
                            double screenWidth = MediaQuery
                                .of(context)
                                .size
                                .width * 0.9;
                            double buttonWidth = screenWidth / 3.5;

                            return SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.20,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.15,
                              // Set the width of the SizedBox
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white
                                      .withOpacity(0.15),
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8),
                                    side: BorderSide(
                                        color: Colors.black26,
                                        width: 2), // Gray outline// Corner radius
                                  ),
                                ),
                                onPressed: () async {
                                  Vibrate.feedback(FeedbackType.light);
                                  const url = 'https://us.mohid.co/mi/detroit/tawheedcenter/masjid/online/registration/index';
                                  if (await canLaunch(url)) {
                                    await launch(
                                      url,
                                      forceSafariVC: false,
                                      // Don't force an in-app Safari
                                      forceWebView: false,
                                      // Don't force a WebView
                                      enableJavaScript: true, // Enable JavaScript if required by the URL
                                    );
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },

                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    double iconSize = constraints
                                        .maxHeight *
                                        0.5; // Adjust the factor as needed
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.edit_note_sharp,
                                            color: textColor,
                                            size: iconSize),
                                        SizedBox(height: 4),
                                        Flexible(
                                          child:
                                          FittedBox(
                                            child: Text(
                                              'Register',
                                              style: TextStyle(
                                                  color: textColor,
                                                  //fontWeight: FontWeight.bold,
                                                  fontFamily: 'AvenirNextMedium'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),

//                     Builder(
//                       builder: (BuildContext context) {
//
//                         double screenWidth = MediaQuery.of(context).size.width;
//                         double buttonWidth = screenWidth / 3.5;
//
//
//                         return SizedBox(
//                           width: buttonWidth,
//                           height: 50,// Set the width of the SizedBox
//                           child: TextButton(
//                             style: TextButton.styleFrom(
//                               //backgroundColor: Colors.blue,
//                               backgroundColor: Color(0xFF146214),
//
//                               primary: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
// // Corner radius
//                               ),
//                             ),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => MyApp4()),
//                               );
//                             },
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
//                               children: <Widget>[
//                                 Icon(Icons.mail, color: Colors.white), // Dollar icon
//                                 SizedBox(width: 4), // Spacing between icon and text
//                                 Text('Contact'),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                       StreamBuilder<List<ProgramContact>>(
//                         //future: fetchProgramNames(),
//                         stream: _contactController.stream,
//                         builder: (BuildContext context,
//                             AsyncSnapshot<List<ProgramContact>> snapshot) {
//
//                           double screenWidth = MediaQuery.of(context).size.width;
//                           double buttonWidth = screenWidth / 3.5;
//
//
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return CircularProgressIndicator(); // Show loading indicator while waiting for data
//                           } else if (snapshot.hasError) {
//                             return Text("Error: ${snapshot
//                                 .error}"); // Show error if something went wrong
//                           } else if (snapshot.hasData) {
//                             // Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format
//
//                             print("list of events");
//                             // snapshot.data!.forEach((event) {
//                             //   print('Event Name: ${event.eventName}, Start: ${event.eventStart}, End: ${event.eventEnd}, Type: ${event.eventType}');
//                             // });
//
//
//                             return SizedBox(
//                               height: MediaQuery.of(context).size.width * 0.110,
//                               width: buttonWidth, // Button width
//                               child: TextButton(
//                                 style: TextButton.styleFrom(
//                                   backgroundColor: Colors.white.withOpacity(0.1),                                  primary: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   // Your onPressed code for Calendar
//                                   if (snapshot.hasData) {
//                                     // Pass the entire list of prayer times to the PrayerTimesTable
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => MyApp6(programNames: snapshot.data!),
//                                       ),
//                                     );
//                                   } else {
//                                     // Handle the case where there is no data
//                                     print("No prayer times data available");
//                                   }
//                                 },
//                                 child: LayoutBuilder(
//                                   builder: (BuildContext context, BoxConstraints constraints) {
//                                     double iconSize = constraints.maxHeight * 0.6; // Adjust the factor as needed
//                                     return Row(
//                                       mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
//                                       children: <Widget>[
//                                         Icon(Icons.info_outline, color: Colors.black, size: iconSize), // Dollar icon
//                                         SizedBox(width: 4), // Spacing between icon and text
//                                         Flexible( // Use Flexible to wrap the Text widget
//                                           child: FittedBox( // Use FittedBox to scale down the text
//                                             fit: BoxFit.scaleDown,
//                                             child: Text(
//                                               'Contact',
//                                               overflow: TextOverflow.ellipsis, // Handle text overflow
//                                               style: TextStyle(
//                                                 color: Colors.black, // Custom hexadecimal color
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                             );
//
//
//                           } else {
//                             return Text(
//                                 "No data available"); // Show this message if there's no data
//                           }
//                         },
//                       ),
                        StreamBuilder<List<Event>>(
                          stream: _eventController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Event>> snapshot) {
                            double screenWidth = MediaQuery
                                .of(context)
                                .size
                                .width;
                            double buttonWidth = screenWidth / 3.5;

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  // Calculate icon size as a fraction of button width or height, whichever is smaller
                                  double iconSize = constraints
                                      .maxHeight < buttonWidth
                                      ? constraints.maxHeight * 0.175
                                      : buttonWidth * 0.175;
                                  //double iconSize = constraints.maxHeight * 0.5; // Adjust the factor as needed

                                  return SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.20,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.15,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.15),
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .circular(8),
                                          side: BorderSide(
                                              color: Colors.black26,
                                              width: 2),
                                        ),
                                      ),
                                      onPressed: () {

                                      },
                                      child: IconTheme(
                                        data: IconThemeData(
                                          size: iconSize,
                                          color: Colors.black,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(Icons.chair_outlined,
                                                color: textColor,
                                                size: iconSize),
                                            SizedBox(height: 4),
                                            Flexible(
                                              child:
                                              FittedBox(
                                                child: Text(
                                                  'Events',
                                                  style: TextStyle(
                                                      //fontWeight: FontWeight.bold,
                                                      color: textColor,
                                                      //color: Color.fromRGBO(
                                                      //    59, 59, 59, 1.0),
                                                      fontFamily: 'AvenirNextMedium'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ),
                                    ),
                                  );
                                },
                              ); // Show loading indicator while waiting for data
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot
                                  .error}"); // Show error if something went wrong
                            } else if (snapshot.hasData) {
                              // Assuming 'Event' is a defined class and snapshot.data is a list of Event objects

                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  // Calculate icon size as a fraction of button width or height, whichever is smaller
                                  double iconSize = constraints
                                      .maxHeight < buttonWidth
                                      ? constraints.maxHeight * 0.175
                                      : buttonWidth * 0.175;
                                  //double iconSize = constraints.maxHeight * 0.5; // Adjust the factor as needed

                                  return SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.20,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.15,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.15),
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .circular(8),
                                          side: BorderSide(
                                              color: Colors.black26,
                                              width: 2),
                                        ),
                                      ),
                                      // onPressed: () {
                                      //       color1: color1;
                                      //       color2: color2;
                                      //       // Your onPressed code for Calendar
                                      //       if (snapshot.hasData) {
                                      //         // Pass the entire list of prayer times to the PrayerTimesTable
                                      //         Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) => ColorPickerDemo(
                                      //               initialColor1: color1, // Provide initialColor1
                                      //               initialColor2: color2, // Provide initialColor2
                                      //               // Receive selected colors from ColorPickerDemo page
                                      //               onColorsSelected: (color1_new, color2_new) {
                                      //                 // Use the selected colors to update gradient colors
                                      //                 // In this example, we just print them to the console
                                      //                 print('Selected Color 1: $color1_new');
                                      //                 print('Selected Color 2: $color2_new');
                                      //                 setState(() {
                                      //                   color1 = color1_new;
                                      //                   color2 = color2_new;
                                      //                 });
                                      //               },
                                      //             ),
                                      //
                                      //           ),
                                      //         );
                                      //       } else {
                                      //         // Handle the case where there is no data
                                      //         print("No prayer times data available");
                                      //       }
                                      //     },
                                      onPressed: () {
                                        if (snapshot.hasData) {
                                          Vibrate.feedback(FeedbackType.light);

                                          modifyTraffic("events");
                                          // Pass the entire list of prayer times to the PrayerTimesTable
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyApp5(),
                                            ),
                                          ).whenComplete(() => Future.delayed(Duration(milliseconds: 100)).then((_) => setStatusBarTextColor(isDayTimeValue)));
                                        } else {
                                          // Handle the case where there is no data
                                          print(
                                              "No prayer times data available");
                                        }
                                      },
                                      child: IconTheme(
                                        data: IconThemeData(
                                          size: iconSize,
                                          color: Colors.black,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(Icons.chair_outlined,
                                                color: textColor,
                                                size: iconSize),
                                            SizedBox(height: 4),
                                            Flexible(
                                              child:
                                              FittedBox(
                                                child: Text(
                                                  'Events',
                                                  style: TextStyle(
                                                     // fontWeight: FontWeight.bold,
                                                      color: textColor,
                                                      //color: Color.fromRGBO(
                                                      //    59, 59, 59, 1.0),
                                                      fontFamily: 'AvenirNextMedium'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Text(
                                  "No data available"); // Show this message if there's no data
                            }
                          },
                        ),
                        // StreamBuilder<List<LocalMarketing>>(
                        //   stream: _marketingController.stream,
                        //   builder: (BuildContext context, AsyncSnapshot<List<LocalMarketing>> snapshot) {
                        //     double screenWidth = MediaQuery.of(context).size.width;
                        //     double buttonWidth = screenWidth / 3.5;
                        //
                        //     if (snapshot.connectionState == ConnectionState.waiting) {
                        //       return CircularProgressIndicator(); // Show loading indicator while waiting for data
                        //     } else if (snapshot.hasError) {
                        //       return Text("Error: ${snapshot.error}"); // Show error if something went wrong
                        //     } else if (snapshot.hasData) {
                        //       // Assuming 'Event' is a defined class and snapshot.data is a list of Event objects
                        //
                        //       return LayoutBuilder(
                        //         builder: (context, constraints) {
                        //           // Calculate icon size as a fraction of button width or height, whichever is smaller
                        //           double iconSize = constraints.maxHeight < buttonWidth ? constraints.maxHeight * 0.175 : buttonWidth * 0.175;
                        //
                        //           return SizedBox(
                        //             width: MediaQuery.of(context).size.width * 0.20,
                        //             height: MediaQuery.of(context).size.width * 0.15,
                        //             child: TextButton(
                        //               style: TextButton.styleFrom(
                        //                 backgroundColor: Colors.white.withOpacity(0.1),
                        //                 primary: Colors.white,
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(8),
                        //                   side: BorderSide(color: Colors.black26, width: 2),
                        //                 ),
                        //               ),
                        //               onPressed: () {
                        //                 if (snapshot.hasData) {
                        //                   // Pass the entire list of prayer times to the PrayerTimesTable
                        //                   Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                       builder: (context) => MyApp10(localMarketing: snapshot.data!),
                        //                     ),
                        //                   );
                        //                 } else {
                        //                   // Handle the case where there is no data
                        //                   print("No prayer times data available");
                        //                 }
                        //               },
                        //               child: IconTheme(
                        //                 data: IconThemeData(
                        //                   size: iconSize,
                        //                   color: Colors.black,
                        //                 ),
                        //                 child: Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: <Widget>[
                        //                     Icon(Icons.chair_outlined, color: Colors.black),
                        //                     SizedBox(height: 4),
                        //                     Flexible(
                        //                       child:
                        //                       FittedBox(
                        //                         child: Text(
                        //                           'Marketing',
                        //                           style: TextStyle(color: Colors.black),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //       );
                        //     } else {
                        //       return Text("No data available"); // Show this message if there's no data
                        //     }
                        //   },
                        // ),

                        Builder(
                          builder: (BuildContext context) {
                            //double screenWidth = MediaQuery.of(context).size.width * 0.9;
                            //double buttonWidth = screenWidth / 3.5;

                            // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                            // String deviceModel = '';
                            // deviceInfo.iosInfo.then((info) {
                            //   deviceModel = info.model;
                            // });

                            double screenWidth = 0.0;
                            double screenHeight = 0.0;
                            // if (deviceModel == 'iPhone13,1') {
                            //   // Adjust width and height for iPhone 13 mini
                            //   screenWidth = MediaQuery
                            //       .of(context)
                            //       .size
                            //       .width * 0.20;
                            //   screenHeight = MediaQuery
                            //       .of(context)
                            //       .size
                            //       .width * 0.15;
                            // }

                            screenWidth = MediaQuery
                                .of(context)
                                .size
                                .width * 0.20;
                            screenHeight = MediaQuery
                                .of(context)
                                .size
                                .width * 0.15;

                            return SizedBox(
                              width: screenWidth,
                              height: screenHeight,
                              // Set the width of the SizedBox
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white
                                      .withOpacity(0.15),
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8),
                                    side: BorderSide(
                                        color: Colors.black26,
                                        width: 2), // Gray outline// Corner radius
                                  ),
                                ),
                                onPressed: () async {
                                  Vibrate.feedback(FeedbackType.light);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyApp3(),
                                    ),
                                  ).whenComplete(() => Future.delayed(Duration(milliseconds: 100)).then((_) => setStatusBarTextColor(isDayTimeValue)));
                                },
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    double iconSize = constraints
                                        .maxHeight *
                                        0.5; // Adjust the factor as needed
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        //Icon(Icons.edit_note_sharp, color: Colors.black),
                                        Image.asset('assets/icons8-qibla-direction-96.png',
                                            width: iconSize,
                                            height: iconSize),

                                        // Icon(Icons.compass_calibration,
                                        //     color: Color.fromRGBO(
                                        //         59, 59, 59, 1.0),
                                        //     size: iconSize),

                                        SizedBox(height: 4),
                                        Flexible(
                                          child:
                                          FittedBox(
                                            child: Text(
                                              'Qibla',
                                              style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  fontFamily: 'AvenirNextMedium'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                      ],
                    ),
                  ),


                  // StreamBuilder<List<ProgramContact>>(
                  //   //future: fetchProgramNames(),
                  //   stream: _contactController.stream,
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<List<ProgramContact>> snapshot) {
                  //
                  //     double screenWidth = MediaQuery.of(context).size.width;
                  //     double buttonWidth = screenWidth / 3.5;
                  //
                  //
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator(); // Show loading indicator while waiting for data
                  //     } else if (snapshot.hasError) {
                  //       return Text("Error: ${snapshot
                  //           .error}"); // Show error if something went wrong
                  //     } else if (snapshot.hasData) {
                  //       // Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format
                  //
                  //       print("list of events");
                  //       // snapshot.data!.forEach((event) {
                  //       //   print('Event Name: ${event.eventName}, Start: ${event.eventStart}, End: ${event.eventEnd}, Type: ${event.eventType}');
                  //       // });
                  //
                  //
                  //       return SizedBox(
                  //         height: MediaQuery.of(context).size.width * 0.110,
                  //         width: buttonWidth * 0.9, // Button width
                  //         child: TextButton(
                  //           style: TextButton.styleFrom(
                  //             backgroundColor: Color(0xFF356A88),
                  //             primary: Colors.white,
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(8),
                  //               side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
                  //             ),
                  //           ),
                  //           onPressed: () {
                  //             color1: color1;
                  //             color2: color2;
                  //             // Your onPressed code for Calendar
                  //             if (snapshot.hasData) {
                  //               // Pass the entire list of prayer times to the PrayerTimesTable
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => ColorPickerDemo(
                  //                     initialColor1: color1, // Provide initialColor1
                  //                     initialColor2: color2, // Provide initialColor2
                  //                     // Receive selected colors from ColorPickerDemo page
                  //                     onColorsSelected: (color1_new, color2_new) {
                  //                       // Use the selected colors to update gradient colors
                  //                       // In this example, we just print them to the console
                  //                       print('Selected Color 1: $color1_new');
                  //                       print('Selected Color 2: $color2_new');
                  //                       setState(() {
                  //                         color1 = color1_new;
                  //                         color2 = color2_new;
                  //                       });
                  //                     },
                  //                   ),
                  //
                  //                 ),
                  //               );
                  //             } else {
                  //               // Handle the case where there is no data
                  //               print("No prayer times data available");
                  //             }
                  //           },
                  //           child: LayoutBuilder(
                  //             builder: (BuildContext context, BoxConstraints constraints) {
                  //               double iconSize = constraints.maxHeight * 0.6; // Adjust the factor as needed
                  //               return Row(
                  //                 mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
                  //                 children: <Widget>[
                  //                   Icon(Icons.info_outline, color: Colors.white, size: iconSize), // Dollar icon
                  //                   SizedBox(width: 4), // Spacing between icon and text
                  //                   Flexible( // Use Flexible to wrap the Text widget
                  //                     child: FittedBox( // Use FittedBox to scale down the text
                  //                       fit: BoxFit.scaleDown,
                  //                       child: Text(
                  //                         'Colors',
                  //                         overflow: TextOverflow.ellipsis, // Handle text overflow
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       );
                  //
                  //
                  //     } else {
                  //       return Text(
                  //           "No data available"); // Show this message if there's no data
                  //     }
                  //   },
                  // ),


                  // Container(
                  //   width: MediaQuery
                  //       .of(context)
                  //       .size
                  //       .width * 0.8,
                  //   height: 2.0,
                  //   color: Colors.black,
                  // ),
                  //SizedBox(height: 32.0),

                  // DatePickerWidget(
                  //   onDateSelected: (DateTime selectedDate) {
                  //     print('Selected Date: $selectedDate');
                  //     // Do something with the selected date
                  //   },
                  // ),

                  // DatePickerWidget(
                  //   onDateSelected: (DateTime date){
                  //     setState((){
                  //       selectedDate = date;
                  //     });
                  // }
                  // ),
                  // Inside your Widget build method where you use DatePickerWidget
                  // DatePickerWidget(
                  //   onDateSelected: (DateTime date) {
                  //     setState(() {
                  //       selectedDate = date; // Update the selected date
                  //     });
                  //     // No need to call fetchPrayerTimes here directly if you're using a FutureBuilder to display prayer times
                  //   },
                  // ),

                  // DatePickerWidget(
                  //   onDateSelected: (DateTime date) {
                  //     updatePrayerTimes(date);
                  //   },
                  // ),

                  // DatePickerWidget(
                  //   onDateSelected: (DateTime date) {
                  //     setState(() {
                  //       selectedDate = date; // Update the selected date
                  //     });
                  //     fetchPrayerTimesData(); // Trigger data fetching for the new date
                  //   },
                  // ),

                  Padding(

                    //padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.015),
                    padding: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.010),
                    child: StreamBuilder<List<PrayerTime>>(
                      //future: futurePrayerTimes = fetchPrayerTimes(selectedDate: selectedDate),
                      stream: _prayerTimesController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PrayerTime>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show loading indicator while waiting for data
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot
                              .error}"); // Show error if something went wrong
                        } else if (snapshot.hasData) {
                          // Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format
                          final today = DateFormat('MM/dd/yyyy').format(
                              DateTime.now());
                          final todayString = DateFormat('yMMMd').format(
                              selectedDate ?? DateTime.now());
                          // final todayPrayerTimes = snapshot.data!.firstWhere(
                          //       (pt) => pt.dateText == today,
                          //   orElse: () => PrayerTime.empty(),
                          // );
                        //calendaricon
                          final todayPrayerTimes = snapshot.data![0];

                          print("new date");
                          print(selectedDate);

                          double paddingValue = 0.0;

                          // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                          // String deviceModel = '';
                          // deviceInfo.iosInfo.then((info) {
                          //   deviceModel = info.model;
                          // });


                          paddingValue = 8;
                          print("devide info");
                          //print(deviceModel);

                          // if (deviceModel == 'iPhone13,1') {
                          //   // Adjust width and height for iPhone 13 mini
                          //   paddingValue = 8;
                          // }


                          if (todayPrayerTimes != null) {
                            // Now we build the UI for just today's prayer times

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Adjust alignment as needed
                              children: [
                                DatePickerWidget(
                                  key: datePickerKey,
                                  onDateSelected: (DateTime date) {

                                    DateTime now = DateTime.now();

                                    DateTime selectedDateOnly = DateTime(date.year, date.month, date.day);
                                    DateTime currentDateOnly = DateTime(now.year, now.month, now.day);

                                    print("User selected date: $selectedDateOnly");
                                    print("Current date: $currentDateOnly");


                                    if (selectedDateOnly == currentDateOnly){
                                      userSelectedDate = false;
                                      print("true");
                                    } else {
                                      userSelectedDate = true;
                                      print("false");
                                    }

                                    setState(() {
                                      selectedDate =
                                          date; // Set the selectedDate state
                                    });
                                    // Now that selectedDate is updated, call updateDateAndFetchPrayerTimes with the new date
                                    // Directly use the 'date' parameter since it's guaranteed to be non-null here
                                    updateDateAndFetchPrayerTimes(date);
                                  },

                                )
                                ,
                                // Optionally, you can wrap the Text widget with a Flexible widget if you want it to take the remaining space.
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: paddingValue,
                                        bottom: paddingValue / 2),
                                    // Adjust or remove padding as needed
                                    child: Text(
                                      todayString + "  ·  " +
                                          todayPrayerTimes.hijri,
                                      style: TextStyle(
                                        fontSize: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.040,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'AvenirNextDemi',
                                        color: textColor,

                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,

                                    ),
                                  ),
                                ),
                              ],
                            )
                            ;
                          } else {
                            // Handle the case where today's prayer times are not found
                            return Text("No prayer times for today.");
                          }
                        } else {
                          return Text(
                              "No data available"); // Show this message if there's no data
                        }
                      },
                    ),
                  ),
                  // Large box with prayer times
                  Container(

                    padding: EdgeInsets.only(
                        left: 8.0, right: 8.0, top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.015, bottom: MediaQuery
                        .of(context)
                        .size
                        .height * 0.010),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    // Adjust the decoration to ensure the border is visible around all sides
                    decoration: BoxDecoration(
                      //color: Colors.grey[200],
                      color: Color.fromRGBO(
                          255, 255, 255, 0.15),
                      //backgroundColor: Color(0xFF8C5112),
// grey[200] with 0.075 opacity                  // Background color inside the container
                      borderRadius: BorderRadius.circular(20),
                      // Rounded corners
                      border: Border.all(
                        color: Colors.black26, // Gray outline color
                        width: 1.0, // Width of the outline
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ensure there's adequate spacing between the last element and the container's border
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Prayer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.040,
                                      fontFamily: 'AvenirNextDemi',
                                      color: textColor),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Adhan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.040,
                                    fontFamily: 'AvenirNextDemi',
                                    color: textColor,),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Iqama',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.040,
                                      fontFamily: 'AvenirNextDemi'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0), // Adjust for effective height
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1, // Adjust for line thickness
                          ),
                        ),
                        Column(
                          children: [
                            StreamBuilder<List<PrayerTime>>(
                              stream: _prayerTimesController.stream,
                              //key: ValueKey(selectedDate),
                              // Use a key that changes when selectedDate changes
                              //future: futurePrayerTimes = fetchPrayerTimes(selectedDate: selectedDate), // Use selectedDate as parameter // Use the state variable,
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                      List<PrayerTime>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Show loading indicator while waiting for data
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot
                                      .error}"); // Show error if something went wrong
                                } else if (snapshot.hasData) {
                                  //Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format
                                  final today = DateFormat('MM/dd/yyyy')
                                      .format(
                                      DateTime.now());


                                  var todayPrayerTimes = snapshot
                                      .data![0];
                                  //     .firstWhere(
                                  //       (pt) => pt.dateText == today,
                                  //   orElse: () => PrayerTime.empty(),
                                  // );


                                  if (todayPrayerTimes != null) {
                                    // Now we build the UI for just today's prayer times

                                    double convertTimeToDecimal(
                                        String time) {
                                      // Remove spaces and convert to lowercase for easier handling
                                      time = time.replaceAll(' ', '')
                                          .toLowerCase();

                                      // Split the time into components
                                      var parts = time.split(':');
                                      if (parts.length !=
                                          2) throw FormatException(
                                          "Invalid time format");

                                      // Extract hours and minutes
                                      int hours = int.parse(parts[0]);
                                      int minutes = int.parse(
                                          parts[1].replaceAll(
                                              RegExp(r'[^0-9]'),
                                              '')); // Remove non-numeric characters from minutes part

                                      // Check for "am/pm" and adjust hours if necessary
                                      if (time.contains('pm') &&
                                          hours < 12) {
                                        hours += 12;
                                      } else if (time.contains('am') &&
                                          hours == 12) {
                                        hours =
                                        0; // Midnight is represented as 0 in 24-hour time
                                      }

                                      // Convert to decimal
                                      return hours + minutes / 60.0;
                                    }


                                    List<String> prayerTimesString = [
                                      todayPrayerTimes.fajrAzan,
                                      todayPrayerTimes.sunrise,
                                      todayPrayerTimes.dhuhrAzan,
                                      todayPrayerTimes.asrAzan,
                                      todayPrayerTimes.magribAzan,
                                      // Make sure to include Maghrib if you want to track it
                                      todayPrayerTimes.ishaAzan
                                    ];

                                    List<
                                        double> prayerTimesInDecimal = prayerTimesString
                                        .map((time) =>
                                    timeToDecimal(time) ?? 0.0).toList();

                                    DateTime now = DateTime.now();
                                    double currentTime = now.hour +
                                        now.minute / 60.0;

// Find the index of the first prayer time that is after the current time
                                    int currentPrayerIndex = prayerTimesInDecimal
                                        .indexWhere((pt) =>
                                    pt > currentTime);

                                    if (currentPrayerIndex == 0 && currentTime < prayerTimesInDecimal[0]) {
                                      currentPrayerIndex = -1;
                                    } else if (currentPrayerIndex == -1) {
                                      // If current time is after all prayers, it means the current prayer should be Isha
                                      // Therefore, set the currentPrayerIndex to the index of Isha
                                      currentPrayerIndex = prayerTimesInDecimal.length - 1;
                                    } else if (currentPrayerIndex > 0) {
                                      // If there is a prayer time after the current time and it's not the first prayer of the day,
                                      // adjust the index to highlight the previous (current) prayer
                                      currentPrayerIndex -= 1;
                                    }


                                    print("prayer index");
                                    print(currentPrayerIndex);
                                    print(selectedDate);
                                    snapshot.data!.forEach((prayerTime) {
                                      print("Prayer Name: ${prayerTime
                                          .fajrAzan}, Time: ${prayerTime
                                          .fajrIqama}");
                                      print("Prayer Name: ${prayerTime
                                          .dhuhrAzan}, Time: ${prayerTime
                                          .dhuhrIqama}");
                                      print("Prayer Name: ${prayerTime
                                          .asrAzan}, Time: ${prayerTime
                                          .asrIqama}");
                                      print("Prayer Name: ${prayerTime
                                          .magribAzan}, Time: ${prayerTime
                                          .magribIqama}");
                                      print("Prayer Name: ${prayerTime
                                          .ishaAzan}, Time: ${prayerTime
                                          .ishaIqama}");
                                      // Adjust the above line based on the actual properties of your PrayerTime class
                                    });


                                    print("Fajr adhan");
                                    print(todayPrayerTimes.fajrAzan);
                                    print("maghrib adhan");
                                    print(todayPrayerTimes.magribAzan);
                                    print("sunrise");
                                    print(todayPrayerTimes.sunrise);
                                    final selectedDateString = DateFormat(
                                        'yyyy-MM-dd').format(
                                        selectedDate!);

                                    // Attempt to find the prayer times for the selected date.
                                    final selectedDayPrayerTimes = snapshot
                                        .data!.firstWhereOrNull(
                                          (pt) =>
                                      pt.dateText == selectedDateString,
                                    );

                                    int convertTimeToHour(String time) {
                                      List<String> parts = time.split(':');
                                      return int.parse(parts[0]);
                                    }

// Extract sunrise and sunset times from today's prayer times
                                    String sunriseTime = todayPrayerTimes.sunrise;
                                    String sunsetTime = todayPrayerTimes.magribAzan; // Assuming magrib time is the sunset time

                                    // Get the current time
                                    DateTime now2 = DateTime.now();
                                    int currentHour = now2.hour;

                                    // Determine if it's daytime or nighttime based on the current hour and sunrise/sunset times
                                    bool isDaytime = currentHour >= convertTimeToHour(sunriseTime) && currentHour < convertTimeToHour(sunsetTime);

                                    // Return UI based on whether it's daytime or nighttime
                                    print("is it daytime: ${isDayTime(DateTime.now())}");

                                    // if (isDayTime(DateTime.now())){
                                    //
                                    //
                                    //
                                    //   setState(() {
                                    //
                                    //     updateBackgroundColor(daytime)
                                    //
                                    //   });
                                    // }

                                    return Column(

                                      children: [
                                        _buildPrayerTimeRow(
                                          context,
                                          'Fajr',
                                          todayPrayerTimes.fajrAzan,
                                          todayPrayerTimes.fajrIqama,
                                          0 == currentPrayerIndex,
                                        ),


                                        _buildPrayerTimeRow(
                                          context,
                                          'Sunrise',
                                          todayPrayerTimes.sunrise,
                                          '-',
                                          1 == currentPrayerIndex,
                                        ),
                                        _buildPrayerTimeRow(
                                          context,
                                          'Dhuhr',
                                          todayPrayerTimes.dhuhrAzan,
                                          todayPrayerTimes.dhuhrIqama,
                                          2 == currentPrayerIndex,
                                        ),
                                        _buildPrayerTimeRow(
                                          context,
                                          'Asr',
                                          todayPrayerTimes.asrAzan,
                                          todayPrayerTimes.asrIqama,
                                          3 == currentPrayerIndex,
                                        ),
                                        _buildPrayerTimeRow(
                                          context,
                                          'Maghrib',
                                          todayPrayerTimes.magribAzan,
                                          todayPrayerTimes.magribIqama,
                                          4 == currentPrayerIndex,
                                        ),
                                        _buildPrayerTimeRow(
                                          context,
                                          'Isha',
                                          todayPrayerTimes.ishaAzan,
                                          todayPrayerTimes.ishaIqama,
                                          5 == currentPrayerIndex,
                                        ),

                                        // Add or adjust for additional prayers as needed
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          // Adjust the horizontal padding as needed
                                          child: Divider(
                                            color: Colors.grey,
                                          ),
                                        ),


                                        //SizedBox(height: 5), // Add vertical spacing here


                                        _buildPrayerTimeRow(
                                            context, "1st Jumu'ah",
                                            "-",
                                            todayPrayerTimes.jumma_1,
                                            6 == currentPrayerIndex),

                                        _buildPrayerTimeRow(
                                            context, "2nd Jumu'ah",
                                            "-",
                                            todayPrayerTimes.jumma_2,
                                            6 == currentPrayerIndex),


                                      ],
                                    );
                                  } else {
                                    // Handle the case where today's prayer times are not found
                                    return Text(
                                        "No prayer times for today.");
                                  }
                                } else {
                                  return Text(
                                      "No data available"); // Show this message if there's no data
                                }
                              },
                            ),
                          ],


                        )

                      ],
                    ),
                  ),

// Existing Container for the large prayer box

                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.020),
                  // Add some space between the prayer box and the buttons
                  //   Scrollbar(
                  //     thickness: 3.0,
                  //     radius: Radius.circular(3.0),
                  //     child:
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
                  //   child:

                 Padding(
                 padding: EdgeInsets.only(bottom: MediaQuery
                     .of(context)
                     .size
                     .height * 0.020),
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>
                    [
                      Builder(
                        builder: (BuildContext context) {
                          double screenWidth = MediaQuery
                              .of(context)
                              .size
                              .width;
                          double buttonWidth = screenWidth / 3.5;

                          return SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * 0.15,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.20,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(
                                    0.15),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: Colors.black26, width: 2),
                                ),
                              ),
                              onPressed: () async {
                                Vibrate.feedback(FeedbackType.light);

                                const url = 'https://m.youtube.com/@TawheedCenter';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset('assets/youtube.png', width: buttonWidth * 0.20, height: buttonWidth * 0.20),
                                  SizedBox(height: 4),
                                  Flexible(
                                    child:
                                    FittedBox(
                                      child: Text(
                                        'YouTube',
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: textColor,
                                            fontFamily: 'AvenirNextMedium'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // StreamBuilder<List<PrayerTime>>(
                      //   stream: _calendarController.stream,
                      //   builder: (BuildContext context, AsyncSnapshot<
                      //       List<PrayerTime>> snapshot) {
                      //     double screenWidth = MediaQuery
                      //         .of(context)
                      //         .size
                      //         .width;
                      //     double buttonWidth = screenWidth / 3.5;
                      //
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return CircularProgressIndicator();
                      //     } else if (snapshot.hasError) {
                      //       return Text("Error: ${snapshot.error}");
                      //     } else if (snapshot.hasData) {
                      //       final today = DateFormat('MM/dd/yyyy').format(
                      //           DateTime.now());
                      //       final todayPrayerTimes = snapshot.data!
                      //           .firstWhere(
                      //             (pt) => pt.dateText == today,
                      //         orElse: () => PrayerTime.empty(),
                      //       );
                      //
                      //       if (todayPrayerTimes != null) {
                      //         return SizedBox(
                      //           width: MediaQuery
                      //               .of(context)
                      //               .size
                      //               .width * 0.20,
                      //           height: MediaQuery
                      //               .of(context)
                      //               .size
                      //               .width * 0.15, // Adjusted height
                      //           child: TextButton(
                      //             style: TextButton.styleFrom(
                      //               backgroundColor: Colors.white
                      //                   .withOpacity(0.15),
                      //               primary: Colors.white,
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(
                      //                     8),
                      //                 side: BorderSide(
                      //                     color: Colors.black26,
                      //                     width: 2),
                      //               ),
                      //             ),
                      //             onPressed: () {
                      //               if (snapshot.hasData) {
                      //                 Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) => MyApp2(
                      //                         prayerTimes: snapshot
                      //                             .data!),
                      //                   ),
                      //                 );
                      //               } else {
                      //                 print(
                      //                     "No prayer times data available");
                      //               }
                      //             },
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: <Widget>[
                      //                 Icon(Icons.calendar_month,
                      //                     color: textColor,
                      //                     size: buttonWidth * 0.20),
                      //                 SizedBox(height: 4),
                      //                 Flexible(
                      //                   child:
                      //                   FittedBox(
                      //                     child: Text(
                      //                       'Prayers',
                      //                       style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                           color: textColor,
                      //                           fontFamily: 'AvenirNextMedium'),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       } else {
                      //         return Text("No prayer times for today.");
                      //       }
                      //     } else {
                      //       return Text("No data available");
                      //     }
                      //   },
                      // ),


                      //SizedBox(width: 200),
                      Builder(
                        builder: (BuildContext context) {
                          double screenWidth = MediaQuery
                              .of(context)
                              .size
                              .width;
                          double buttonWidth = screenWidth / 3.5;

                          return SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * 0.15,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.20,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(
                                    0.15),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: Colors.black26, width: 2),
                                ),
                              ),
                              onPressed: () async {
                                Vibrate.feedback(FeedbackType.light);

                                const url = 'https://www.google.com/maps/place/Tawheed+Center/@42.4699321,-83.3433284,17z/data=!3m1!4b1!4m6!3m5!1s0x8824b12c0efa825b:0x20421df086748831!8m2!3d42.4699282!4d-83.3407535!16s%2Fg%2F1tctg6zr?entry=ttu';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.location_on,
                                      color: textColor,
                                      size: buttonWidth * 0.20),
                                  SizedBox(height: 4),
                                  Flexible(
                                    child:
                                    FittedBox(
                                      child: Text(
                                        'Location',
                                        style: TextStyle(
                                           // fontWeight: FontWeight.bold,
                                            color: textColor,
                                            fontFamily: 'AvenirNextMedium'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // StreamBuilder<List<ProgramContact>>(
                      //   //future: fetchProgramNames(),
                      //   stream: _contactController.stream,
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot<List<ProgramContact>> snapshot) {
                      //
                      //     double screenWidth = MediaQuery.of(context).size.width;
                      //     double buttonWidth = screenWidth / 3.5;
                      //
                      //
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return CircularProgressIndicator(); // Show loading indicator while waiting for data
                      //     } else if (snapshot.hasError) {
                      //       return Text("Error: ${snapshot
                      //           .error}"); // Show error if something went wrong
                      //     } else if (snapshot.hasData) {
                      //       // Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format
                      //
                      //       print("list of events");
                      //       // snapshot.data!.forEach((event) {
                      //       //   print('Event Name: ${event.eventName}, Start: ${event.eventStart}, End: ${event.eventEnd}, Type: ${event.eventType}');
                      //       // });
                      //
                      //
                      //       return SizedBox(
                      //         height: MediaQuery.of(context).size.width * 0.110,
                      //         width: MediaQuery.of(context).size.width * 0.15,// Button width
                      //         child: TextButton(
                      //           style: TextButton.styleFrom(
                      //             backgroundColor: Colors.white.withOpacity(0.1),                                  primary: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(8),
                      //               side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
                      //             ),
                      //           ),
                      //           onPressed: () {
                      //             // Your onPressed code for Calendar
                      //             if (snapshot.hasData) {
                      //               // Pass the entire list of prayer times to the PrayerTimesTable
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) => MyApp6(programNames: snapshot.data!),
                      //                 ),
                      //               );
                      //             } else {
                      //               // Handle the case where there is no data
                      //               print("No prayer times data available");
                      //             }
                      //           },
                      //           child: LayoutBuilder(
                      //             builder: (BuildContext context, BoxConstraints constraints) {
                      //               double iconSize = constraints.maxHeight * 0.9; // Adjust the factor as needed
                      //               return Row(
                      //                 mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
                      //                 children: <Widget>[
                      //                   Icon(Icons.info_outline_rounded, color: Colors.black, size: iconSize), // Dollar icon
                      //                   SizedBox(width: 4), // Spacing between icon and text
                      //                   Flexible( // Use Flexible to wrap the Text widget
                      //                     child: FittedBox( // Use FittedBox to scale down the text
                      //                       fit: BoxFit.scaleDown,
                      //
                      //                     ),
                      //                   ),
                      //                 ],
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       );
                      //
                      //
                      //     } else {
                      //       return Text(
                      //           "No data available"); // Show this message if there's no data
                      //     }
                      //   },
                      // )

                      StreamBuilder<List<ProgramContact>>(
                        //future: fetchProgramNames(),
                        stream: _contactController.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<
                                List<ProgramContact>> snapshot) {
                          double screenWidth = MediaQuery
                              .of(context)
                              .size
                              .width;
                          double buttonWidth = screenWidth / 3.5;


                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show loading indicator while waiting for data
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot
                                .error}"); // Show error if something went wrong
                          } else if (snapshot.hasData) {
                            // Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format

                            print("list of events");
                            // snapshot.data!.forEach((event) {
                            //   print('Event Name: ${event.eventName}, Start: ${event.eventStart}, End: ${event.eventEnd}, Type: ${event.eventType}');
                            // });


                            return SizedBox(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.15,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.20, // Button width
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white
                                      .withOpacity(0.15),
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8),
                                    side: BorderSide(
                                        color: Colors.black26,
                                        width: 2), // Gray outline// Corner radius
                                  ),
                                ),
                                onPressed: () {
                                  // Your onPressed code for Calendar
                                  Vibrate.feedback(FeedbackType.light);

                                  if (snapshot.hasData) {
                                    // Pass the entire list of prayer times to the PrayerTimesTable
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyApp6(
                                            programNames: snapshot.data!),
                                      ),
                                    ).whenComplete(() => Future.delayed(Duration(milliseconds: 100)).then((_) => setStatusBarTextColor(isDayTimeValue)));

                                  } else {
                                    // Handle the case where there is no data
                                    print(
                                        "No prayer times data available");
                                  }
                                },
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    double iconSize = constraints
                                        .maxHeight *
                                        0.9; // Adjust the factor as needed
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.info_outline_rounded,
                                            color: textColor,
                                            size: buttonWidth * 0.20),
                                        SizedBox(height: 4),
                                        Flexible(
                                          child:
                                          FittedBox(
                                            child: Text(
                                              'Contact',
                                              style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  fontFamily: 'AvenirNextMedium'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {
                            return Text(
                                "No data available"); // Show this message if there's no data
                          }
                        },
                      ),
                      // StreamBuilder<List<Event>>(
                      //   //future: fetchEvents(),
                      //   stream: _eventController.stream,
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot<List<Event>> snapshot) {
                      //
                      //     double screenWidth = MediaQuery.of(context).size.width;
                      //     double buttonWidth = screenWidth / 3.5;
                      //
                      //
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return CircularProgressIndicator(); // Show loading indicator while waiting for data
                      //     } else if (snapshot.hasError) {
                      //       return Text("Error: ${snapshot
                      //           .error}"); // Show error if something went wrong
                      //     } else if (snapshot.hasData) {
                      //       // Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format
                      //
                      //       print("list of events");
                      //       snapshot.data!.forEach((event) {
                      //         print('Event Name: ${event.eventName}, Start: ${event.eventStart}, End: ${event.eventEnd}, Type: ${event.eventType}');
                      //       });
                      //
                      //
                      //       return SizedBox(
                      //         height: MediaQuery.of(context).size.width * 0.110,
                      //         width: MediaQuery.of(context).size.width * 0.15,  // Button width
                      //         child: TextButton(
                      //           style: TextButton.styleFrom(
                      //             //backgroundColor: Colors.blue,
                      //             backgroundColor: Colors.white.withOpacity(0.1),
                      //
                      //             primary: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(
                      //                   8),
                      //               side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
                      //             ),
                      //           ),
                      //           onPressed: () {
                      //             // Your onPressed code for Calendar
                      //             if (snapshot.hasData) {
                      //               // Pass the entire list of prayer times to the PrayerTimesTable
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) => MyApp5(events: snapshot.data!),
                      //                 ),
                      //               );
                      //             } else {
                      //               // Handle the case where there is no data
                      //               print("No prayer times data available");
                      //             }
                      //           },
                      //           child: Row(
                      //             mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
                      //             children: <Widget>[
                      //               Icon(Icons.chair, color: Colors.black), // Dollar icon
                      //               SizedBox(width: 4), // Spacing between icon and text
                      //               //Text('Events'),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //
                      //     } else {
                      //       return Text(
                      //           "No data available"); // Show this message if there's no data
                      //     }
                      //   },
                      // ),


//                     Builder(
//                       builder: (BuildContext context) {
//
//                         double screenWidth = MediaQuery.of(context).size.width;
//                         double buttonWidth = screenWidth / 3.5;
//
//
//
//                         return SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.15,
//                           height: MediaQuery.of(context).size.width * 0.110, // Set the width of the SizedBox
//                           child: TextButton(
//                             style: TextButton.styleFrom(
//                               //backgroundColor: Colors.blue,
//                               backgroundColor: Colors.white.withOpacity(0.1),
//
//                               primary: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
// // Corner radius
//                               ),
//                             ),
//                             onPressed: () async {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MyApp8(),
//                                 ),
//                               );
//                             },
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
//                               children: <Widget>[
//                                 Image.asset('assets/youtube.png', width: 30, height: 30),
//                                 //Icon(Icons.location_on, color: Colors.white), // Dollar icon
//                                 //SizedBox(width: 4), // Spacing between icon and text
//                                 //Text('Direction'),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//colorpicker here
                      // StreamBuilder<List<ProgramContact>>(
                      //   //future: fetchProgramNames(),
                      //   stream: _contactController.stream,
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot<List<ProgramContact>> snapshot) {
                      //
                      //     double screenWidth = MediaQuery.of(context).size.width;
                      //     double buttonWidth = screenWidth / 3.5;
                      //
                      //
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return CircularProgressIndicator(); // Show loading indicator while waiting for data
                      //     } else if (snapshot.hasError) {
                      //       return Text("Error: ${snapshot
                      //           .error}"); // Show error if something went wrong
                      //     } else if (snapshot.hasData) {
                      //       // Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format
                      //
                      //       print("list of events");
                      //       // snapshot.data!.forEach((event) {
                      //       //   print('Event Name: ${event.eventName}, Start: ${event.eventStart}, End: ${event.eventEnd}, Type: ${event.eventType}');
                      //       // });
                      //
                      //
                      //       return SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.15,
                      //         height: MediaQuery.of(context).size.width * 0.110,  // Button width
                      //         child: TextButton(
                      //           style: TextButton.styleFrom(
                      //             backgroundColor: Colors.white.withOpacity(0.1),
                      //             primary: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(8),
                      //               side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
                      //             ),
                      //           ),
                      //           onPressed: () {
                      //             color1: color1;
                      //             color2: color2;
                      //             // Your onPressed code for Calendar
                      //             if (snapshot.hasData) {
                      //               // Pass the entire list of prayer times to the PrayerTimesTable
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) => ColorPickerDemo(
                      //                     initialColor1: color1, // Provide initialColor1
                      //                     initialColor2: color2, // Provide initialColor2
                      //                     // Receive selected colors from ColorPickerDemo page
                      //                     onColorsSelected: (color1_new, color2_new) {
                      //                       // Use the selected colors to update gradient colors
                      //                       // In this example, we just print them to the console
                      //                       print('Selected Color 1: $color1_new');
                      //                       print('Selected Color 2: $color2_new');
                      //                       setState(() {
                      //                         color1 = color1_new;
                      //                         color2 = color2_new;
                      //                       });
                      //                     },
                      //                   ),
                      //
                      //                 ),
                      //               );
                      //             } else {
                      //               // Handle the case where there is no data
                      //               print("No prayer times data available");
                      //             }
                      //           },
                      //           child: LayoutBuilder(
                      //             builder: (BuildContext context, BoxConstraints constraints) {
                      //               double iconSize = constraints.maxHeight * 0.6; // Adjust the factor as needed
                      //               return Row(
                      //                 mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
                      //                 children: <Widget>[
                      //                   Icon(Icons.info_outline, color: Colors.black, size: iconSize), // Dollar icon
                      //                   SizedBox(width: 4), // Spacing between icon and text
                      //                   Flexible( // Use Flexible to wrap the Text widget
                      //                     child: FittedBox( // Use FittedBox to scale down the text
                      //                       fit: BoxFit.scaleDown,
                      //                       // child: Text(
                      //                       //   'Colors',
                      //                       //   overflow: TextOverflow.ellipsis, // Handle text overflow
                      //                       // ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       );
                      //
                      //
                      //     } else {
                      //       return Text(
                      //           "No data available"); // Show this message if there's no data
                      //     }
                      //   },
                      // ),


//                     Builder(
//                       builder: (BuildContext context) {
//
//                         double screenWidth = MediaQuery.of(context).size.width;
//                         double buttonWidth = screenWidth / 3.5;
//
//
//
//                         return SizedBox(
//                           height: MediaQuery.of(context).size.width * 0.110,
//                           width: MediaQuery.of(context).size.width * 0.15,  // Set the width of the SizedBox
//                           child: TextButton(
//                             style: TextButton.styleFrom(
//                               //backgroundColor: Colors.blue,
//                               backgroundColor: Colors.white.withOpacity(0.1),
//
//                               primary: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
// // Corner radius
//                               ),
//                             ),
//                             onPressed: () async {
//                               const url = 'https://www.youtube.com/@TawheedCenter';
//                               if (await canLaunch(url)) {
//                                 await launch(url);
//                               } else {
//                                 throw 'Could not launch $url';
//                               }
//                             },
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
//                               children: <Widget>[
//                                 Image.asset('assets/youtube.png', width: 30, height: 30),
//                                 //Icon(Icons.location_on, color: Colors.white), // Dollar icon
//                                 //SizedBox(width: 4), // Spacing between icon and text
//                                 //Text('Direction'),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),


                      Builder(
                        builder: (BuildContext context) {
                          double screenWidth = MediaQuery
                              .of(context)
                              .size
                              .width;
                          double buttonWidth = screenWidth / 3.5;


                          return SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.20,
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * 0.15,
                            // Set the width of the SizedBox
                            child: TextButton(
                              style: TextButton.styleFrom(
                                //backgroundColor: Colors.blue,
                                backgroundColor: Colors.white.withOpacity(
                                    0.15),

                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.black26,
                                      width: 2), // Gray outline// Corner radius
// Corner radius
                                ),
                              ),
                              onPressed: () async {
                                Vibrate.feedback(FeedbackType.light);

                                openDrawerAndListen(context);
                                _scaffoldKey.currentState
                                    ?.openEndDrawer();


                                },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.menu, color: textColor,
                                      size: buttonWidth * 0.20),
                                  SizedBox(height: 4),
                                  Flexible(
                                    child:
                                    FittedBox(
                                      child: Text(
                                        'More...',
                                        style: TextStyle(
                                           // fontWeight: FontWeight.bold,
                                            color: textColor,
                                            fontFamily: 'AvenirNextMedium'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),


                      // FutureBuilder<List<PrayerTime>>(
                      //   future: fetchPrayerTimes(),
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot<List<PrayerTime>> snapshot) {
                      //
                      //     double screenWidth = MediaQuery.of(context).size.width;
                      //     double buttonWidth = screenWidth / 3.5;
                      //
                      //
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return CircularProgressIndicator(); // Show loading indicator while waiting for data
                      //     } else if (snapshot.hasError) {
                      //       return Text("Error: ${snapshot
                      //           .error}"); // Show error if something went wrong
                      //     } else if (snapshot.hasData) {
                      //       // Find today's prayer times, assuming `dateText` is in 'MM/dd/yyyy' format
                      //       final today = DateFormat('MM/dd/yyyy').format(DateTime
                      //           .now());
                      //       final todayPrayerTimes = snapshot.data!.firstWhere(
                      //             (pt) => pt.dateText == today,
                      //         orElse: () => PrayerTime.empty(),
                      //       );
                      //
                      //       if (todayPrayerTimes != null) {
                      //         // Now we build the UI for just today's prayer times
                      //
                      //         return SizedBox(
                      //           height: 50,
                      //           width: buttonWidth, // Button width
                      //           child: TextButton(
                      //             style: TextButton.styleFrom(
                      //               //backgroundColor: Colors.blue,
                      //               backgroundColor: Color(0xFF146214),
                      //
                      //               primary: Colors.white,
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(
                      //                     8),
                      //                 side: BorderSide(color: Colors.black26, width: 2), // Gray outline// Corner radius
                      //               ),
                      //             ),
                      //             onPressed: () {
                      //               // Your onPressed code for Calendar
                      //               if (snapshot.hasData) {
                      //                 // Pass the entire list of prayer times to the PrayerTimesTable
                      //                 Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) => MyApp3(),
                      //                   ),
                      //                 );
                      //               } else {
                      //                 // Handle the case where there is no data
                      //                 print("No prayer times data available");
                      //               }
                      //             },
                      //             child: Row(
                      //               mainAxisSize: MainAxisSize.min, // Use min to reduce inner padding
                      //               children: <Widget>[
                      //                 Icon(Icons.location_on, color: Colors.white), // Dollar icon
                      //                 SizedBox(width: 4), // Spacing between icon and text
                      //                 Text('Qibla'),
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       } else {
                      //         // Handle the case where today's prayer times are not found
                      //         return Text("No prayer times for today.");
                      //       }
                      //     } else {
                      //       return Text(
                      //           "No data available"); // Show this message if there's no data
                      //     }
                      //   },
                      // ),


                    ],
                  ),
                 ),



                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: StreamBuilder<List<PrayerTime>>(
                      stream: _calendarController.stream,
                      builder: (BuildContext context, AsyncSnapshot<List<PrayerTime>> snapshot) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double buttonWidth = screenWidth / 3.5;

                        double screenWidth2 = MediaQuery.of(context).size.width;

// Define a variable to hold the font size based on the screen width
                        double fontSize = screenWidth2 * 0.040;

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (snapshot.hasData) {
                          final today = DateFormat('MM/dd/yyyy').format(DateTime.now());
                          final todayPrayerTimes = snapshot.data!.firstWhere(
                                (pt) => pt.dateText == today,
                            orElse: () => PrayerTime.empty(),
                          );

                          if (todayPrayerTimes != null) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: MediaQuery.of(context).size.width * 0.15, // Adjusted height
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.15),
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.black26, width: 2),
                                  ),
                                ),
                                onPressed: () {
                                  if (snapshot.hasData) {
                                    Vibrate.feedback(FeedbackType.light);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyApp2(prayerTimes: snapshot.data!),
                                      ),
                                    ).whenComplete(() => Future.delayed(Duration(milliseconds: 100)).then((_) => setStatusBarTextColor(isDayTimeValue)));
                                  } else {
                                    print("No prayer times data available");
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Icon(Icons.calendar_month, color: textColor, size: buttonWidth * 0.20),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Monthly Prayer Times',
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            //fontWeight: FontWeight.bold,
                                            color: textColor,
                                            fontFamily: 'AvenirNextMedium',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(Icons.arrow_forward, color: textColor),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text("No prayer times for today.");
                          }
                        } else {
                          return Text("No data available");
                        }
                      },
                    ),
                  ),


                  StreamBuilder<List<ButtonClass>>(
                    stream: _buttonController.stream,
                    builder: (BuildContext context, AsyncSnapshot<List<ButtonClass>> snapshot) {
                      double screenWidth = MediaQuery.of(context).size.width;
                      double buttonWidth = screenWidth / 3.5;

                      double screenWidth2 = MediaQuery.of(context).size.width;

// Define a variable to hold the font size based on the screen width
                      double fontSize = screenWidth2 * 0.040;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show loading indicator while waiting for data
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}"); // Show error if something went wrong
                      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final buttonData = snapshot.data!.first;
                        return Padding(
                          padding: EdgeInsets.only(top: 0, bottom: snapshot.hasData ? 5.0 : 0), // Apply bottom padding conditionally
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.black26, width: 2),
                                ),
                              ),
                              onPressed: () async {
                                Vibrate.feedback(FeedbackType.light);

                                if (await canLaunch(buttonData.link)) {
                                  await launch(buttonData.link);
                                } else {
                                  throw 'Could not launch ${buttonData.link}';
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        //child: Icon(FlutterIslamicIcons.solidLantern, color: Colors.green, size: buttonWidth * 0.20),
                                        child: Image.asset(buttonData.icon, width: buttonWidth * 0.20, height: buttonWidth * 0.20),

                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        buttonData.title,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          //fontWeight: FontWeight.bold,
                                          color: textColor,
                                          fontFamily: 'AvenirNextMedium',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(Icons.arrow_forward, color: textColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Handle the case where today's button data is not found or empty
                        return SizedBox.shrink(); // This widget won't take up any space in the layout
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Builder(
                      builder: (BuildContext context) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double buttonWidth = screenWidth / 3.5;

                        double screenWidth2 = MediaQuery.of(context).size.width;

// Define a variable to hold the font size based on the screen width
                        double fontSize = screenWidth2 * 0.040;

                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.15),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.black26, width: 2),
                              ),
                            ),
                            onPressed: () async {
                              Vibrate.feedback(FeedbackType.light);

                              const url = 'https://us.mohid.co/mi/detroit/tawheedcenter/masjid/online/vfr/campaign/ramadan_annual_fundraising_event_8611';
                              if (await canLaunch(url)) {
                                await launch(
                                  url,
                                  forceSafariVC: false,
                                  // Don't force an in-app Safari
                                  forceWebView: false,
                                  // Don't force a WebView
                                  enableJavaScript: true, // Enable JavaScript if required by the URL
                                );
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(Icons.link, color: textColor, size: buttonWidth * 0.20),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Masjid Expansion Project',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        //fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontFamily: 'AvenirNextMedium',
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.arrow_forward, color: textColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Builder(
                      builder: (BuildContext context) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double buttonWidth = screenWidth / 3.5;

                        double screenWidth2 = MediaQuery.of(context).size.width;

// Define a variable to hold the font size based on the screen width
                        double fontSize = screenWidth2 * 0.040;

                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.15),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.black26, width: 2),
                              ),
                            ),
                            onPressed: () async {
                              Vibrate.feedback(FeedbackType.light);

                              const url = 'https://www.tawheedcenter.org';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(Icons.link, color: textColor, size: buttonWidth * 0.20),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Tawheed Center Website',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        //fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontFamily: 'AvenirNextMedium',
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.arrow_forward, color: textColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),











                  Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Builder(
                      builder: (BuildContext context) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double buttonWidth = screenWidth / 3.5;

                        double screenWidth2 = MediaQuery.of(context).size.width;

// Define a variable to hold the font size based on the screen width
                        double fontSize = screenWidth2 * 0.040;

                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.15),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.black26, width: 2),
                              ),
                            ),
                            onPressed: () async {
                              Vibrate.feedback(FeedbackType.light);

                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'afnanatif@gmail.com',
                                query: 'cc=abbasshariff@gmail.com&subject=Tawheed Center App Feedback',
                              );
                              if (await canLaunch(emailLaunchUri.toString())) {
                                await launch(emailLaunchUri.toString());
                              } else {
                                throw 'Could not launch email';
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(Icons.mail, color: textColor, size: buttonWidth * 0.20),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'App Feedback',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        //fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontFamily: 'AvenirNextMedium',
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.arrow_forward, color: textColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Row(
                  //   children: <Widget>[
                  //     Expanded( // Takes up all available horizontal space
                  //       child: Container(), // Empty container to push the text to the right
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.only(right: 50.0, bottom: 20), // Right padding to prevent cutoff
                  //       child: Text(
                  //         '2.3.0',
                  //         style: TextStyle(
                  //           fontSize: 12.0,
                  //           color: Colors.white.withOpacity(0.75),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),



                  // ),
                  //   )
                ],
              )


// Continue with the rest of your UI...


            // Additional widgets can be added here


          ),

          //here
          //floatingActionButton: ExpandableFab(),
        ),
      ),
    ),
      ),

    );
  }

  Widget _buildBox(BuildContext context, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Avenir'
          ),
        ),
      ),
    );
  }



  Widget _buildPrayerTimeRow(BuildContext context, String prayerName,
      String adhanTime, String iqamaTime, bool isCurrentPrayer) {
    // Define a color for the current prayer row. For non-current rows, use transparent or any default color.
    Color rowColor = isCurrentPrayer ? (Colors.green[100] ?? Colors.yellow) : Colors.transparent;
    BorderSide borderSide = isCurrentPrayer ? BorderSide(color: Colors.green, width: 2.0) : BorderSide.none; // Bold green outline for current prayer
    print("prayer name: ");
    print(prayerName);
    print(isCurrentPrayer);

    double screenWidth = MediaQuery.of(context).size.width;

// Define a variable to hold the font size based on the screen width
    double fontSize = screenWidth * 0.040;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: rowColor, // Apply the color to the container background
        border: Border.all(
          color: isCurrentPrayer ? Colors.green : Colors.transparent, // Green border for the current prayer row
          width: 2.0, // Width of the border
        ),
        borderRadius: BorderRadius.circular(4.0), // Optional: if you want rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                prayerName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isCurrentPrayer ? Colors.black : textColor,
                  //fontWeight: isCurrentPrayer ? FontWeight.bold : FontWeight.normal,
                  fontFamily: isCurrentPrayer ? 'AvenirNextDemi' : 'AvenirNextMedium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                adhanTime,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isCurrentPrayer ? Colors.black : textColor,
                  //fontWeight: isCurrentPrayer ? FontWeight.bold : FontWeight.normal,
                  fontFamily: isCurrentPrayer ? 'AvenirNextDemi' : 'AvenirNextMedium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                iqamaTime,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isCurrentPrayer ? Colors.black : textColor,
                  //fontWeight: isCurrentPrayer ? FontWeight.bold : FontWeight.normal,
                  fontFamily: isCurrentPrayer ? 'AvenirNextDemi' : 'AvenirNextMedium',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Color>> getColorsForTime(List<PrayerTime> prayerTimes) async {
  // Get the current time
  DateTime now = DateTime.now();
  // Extract current time as a decimal value
  double currentTime = now.hour + now.minute / 60.0;

  // Iterate over each PrayerTime object in the list
  for (PrayerTime prayerTime in prayerTimes) {
    // Extract sunset and sunrise times for the current PrayerTime object
    double sunsetDecimal = _convertTimeToDecimal(prayerTime.magribAzan);
    double sunriseDecimal = _convertTimeToDecimal(prayerTime.sunrise);

    // Determine if the current time is between sunset and sunrise
    if (currentTime >= sunsetDecimal || currentTime < sunriseDecimal) {
      // Return colors for time between sunset and sunrise
      return [
        Color.fromRGBO(221, 221, 221, 1.0), // Color 2
        Color.fromRGBO(196, 215, 245, 1.0)  // Color 1
      ];
    } else {
      // Return colors for time outside sunset and sunrise
      return [
        Color.fromRGBO(196, 215, 245, 1.0), // Color 1
        Color.fromRGBO(221, 221, 221, 1.0)  // Color 2
      ];
    }
  }

  // Default return if no conditions are met
  return [Colors.white, Colors.white];
}





class SineGraphPainter extends CustomPainter {
  final List<double> prayerTimes;
  final ui.Image sunImage;
  final ui.Image moonImage;
  final double amplitude;
  final Color dashedColor;

  SineGraphPainter({
    required this.prayerTimes,
    required this.sunImage,
    required this.moonImage,
    required this.amplitude,
    required this.dashedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double startX = -pi / 2;
    final double endX = 3 * pi / 2;
    final double range = endX - startX;
    final double verticalOffset = size.height / 2;
    final double dhuhrX = size.width / 2;
    final double outlineOffset = 2.0;

    final Paint outlinePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = -1; i <= 1; i += 2) {
      Path outlinePath = Path();
      for (double screenX = 0; screenX <= size.width; screenX++) {
        double domainX = startX + (screenX / size.width) * range;
        double y = verticalOffset - amplitude * sin(domainX) + (outlineOffset * i);
        if (screenX == 0) {
          outlinePath.moveTo(screenX, y);
        } else {
          outlinePath.lineTo(screenX, y);
        }
      }
      canvas.drawPath(outlinePath, outlinePaint);
    }

    final Paint sineWavePaint = Paint()
      ..color = Colors.white.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    Path path = Path();
    for (double screenX = 0; screenX <= size.width; screenX++) {
      double domainX = startX + (screenX / size.width) * range;
      double y = verticalOffset - amplitude * sin(domainX);
      if (screenX == 0) {
        path.moveTo(screenX, y);
      } else {
        path.lineTo(screenX, y);
      }
    }
    canvas.drawPath(path, sineWavePaint);

    double sunriseTime = prayerTimes[1];
    double sunriseX = mapTimeToX(sunriseTime, size.width, dhuhrX, prayerTimes[2]);
    double sunriseY = verticalOffset - amplitude * sin(startX + (sunriseX / size.width) * range);

    final Paint dashPaint = Paint()
      ..color = dashedColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    drawDashedLine(canvas, dashPaint, Offset(0, sunriseY), Offset(size.width, sunriseY));

    double currentTime = getCurrentTimeDecimal();

    // List of icons for prayer times
    final List<IconData> prayerIcons = [
      Icons.circle,         // Fajr
      Icons.wb_sunny,         // Sunrise
      Icons.sunny,            // Dhuhr
      Icons.sunny_snowing,    // Asr
      Icons.nightlight,       // Maghrib
      Icons.nights_stay,      // Isha
    ];

    // Draw icons for each prayer time
    for (int i = 0; i < prayerTimes.length; i++) {
      double time = prayerTimes[i];
      double x = mapTimeToX(time, size.width, dhuhrX, prayerTimes[2]);
      double y = verticalOffset - amplitude * sin(startX + (x / size.width) * range);

      // Set icon color based on whether the time has passed
      Color iconColor = currentTime >= time ? Colors.green : Colors.white;

      // Draw the icon using TextPainter
      TextPainter iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(prayerIcons[i].codePoint),
          style: TextStyle(
            fontSize: 25.0, // Adjust the size of the icon
            fontFamily: prayerIcons[i].fontFamily,
            color: iconColor,
          ),
        ),
        textDirection: ui.TextDirection.ltr, // Using fully qualified reference
      );

      iconPainter.layout();
      iconPainter.paint(canvas, Offset(x - iconPainter.width / 2, y - iconPainter.height / 2));
    }

    bool isDayTime = currentTime >= sunriseTime && currentTime < prayerTimes[4];
    final Paint glowPaint = Paint()
      ..color = isDayTime ? Colors.yellow.withOpacity(0.5) : Colors.white.withOpacity(0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 24);

    double currentTimeX = mapTimeToX(currentTime, size.width, dhuhrX, prayerTimes[2]);
    double currentTimeY = verticalOffset - amplitude * sin(startX + (currentTimeX / size.width) * range);
    Offset glowCenter = Offset(currentTimeX, currentTimeY);

    canvas.drawCircle(glowCenter, 25, glowPaint);

    ui.Image imageToDraw = isDayTime ? sunImage : moonImage;
    Offset imagePosition = Offset(currentTimeX - 12.5, currentTimeY - 12.5);
    Rect srcRect = Offset.zero & Size(imageToDraw.width.toDouble(), imageToDraw.height.toDouble());
    Rect dstRect = imagePosition & const Size(25, 25);

    canvas.drawImageRect(imageToDraw, srcRect, dstRect, Paint());
  }

  void drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    const int dashWidth = 10;
    const int dashSpace = 5;
    double distance = end.dx - start.dx;
    for (int i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(start.dx + i, start.dy),
        Offset(start.dx + i + dashWidth, start.dy),
        paint,
      );
    }
  }

  double getCurrentTimeDecimal() {
    final now = DateTime.now();
    return now.hour + now.minute / 60.0;
  }

  double mapTimeToX(double time, double width, double dhuhrX, double dhuhrTime) {
    double timeDifference = time - dhuhrTime;
    return dhuhrX + (timeDifference * (width / 24.0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}









// Future<List<PrayerTime>> fetchPrayerTimes({DateTime? selectedDate}) async {
//   DateTime dateToSend = selectedDate ?? DateTime.now(); // Use selectedDate if provided, otherwise use current date
//   final url = Uri.parse('https://www.tawheedcenter.org/SalaTimes_CurrentMonth.php?selectedDate=$dateToSend');
//   final response = await http.get(url);
//
//   if (response.statusCode == 200) {
//     final List<dynamic> prayerTimesJson = json.decode(response.body);
//     print("got the prayer times");
//     print(prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList());
//     return prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load prayer times');
//   }
// }

Future<List<PrayerTime>> fetchPrayerTimes({DateTime? selectedDate}) async {
  DateTime dateToSend = selectedDate ?? DateTime.now(); // Use selectedDate if provided, otherwise use current date

  // Format the dateToSend into 'Y-m-t' format
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateToSend);

  late SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  final int? madhabSelection = prefs.getInt('madhab') ?? 1;

  print("madhab selection main $madhabSelection");

  var madhabValue = "";

  if (madhabSelection == 0){
    madhabValue = "asr_mithl_2";
  } else {
    madhabValue = "asr_mithl_1";
  }


  print("printing new prayer times");
  print(formattedDate);

  // Construct the URL with the formatted date
  final url = Uri.parse('https://www.tawheedcenter.org/retrievePrayerTimes_1.2.0.php?date=$formattedDate&asrTime=$madhabValue');

  print("url fetch for prayer times $url");
  print(url);
  // Send the HTTP request
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // Parse the JSON response
    final List<dynamic> prayerTimesJson = json.decode(response.body);
    print("got the prayer times");
    print(prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList());
    return prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList();
  } else {
    // Handle the case when the request fails
    throw Exception('Failed to load prayer times');
  }
}

// Future<List<PrayerTime>> fetchPrayerTimes({DateTime? selectedDate}) async {
//   DateTime dateToSend = selectedDate ?? DateTime.now(); // Use selectedDate if provided, otherwise use current date
//
//   // Format the dateToSend into 'Y-m-t' format
//   String formattedDate = DateFormat('yyyy-MM-dd').format(dateToSend);
//
//   late SharedPreferences prefs;
//   prefs = await SharedPreferences.getInstance();
//   final int? madhabSelection = prefs.getInt('madhab');
//
//
//
//   print("printing new prayer times");
//   print(formattedDate);
//
//   // Construct the URL with the formatted date
//   final url = Uri.parse('https://www.tawheedcenter.org/datePicker02.php?date=$formattedDate');
//
//   print("url");
//   print(url);
//   // Send the HTTP request
//   final response = await http.get(url);
//
//   if (response.statusCode == 200) {
//     // Parse the JSON response
//     final List<dynamic> prayerTimesJson = json.decode(response.body);
//     print("got the prayer times");
//     print(prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList());
//     return prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList();
//   } else {
//     // Handle the case when the request fails
//     throw Exception('Failed to load prayer times');
//   }
// }


Future<List<PrayerTime>> fetchPrayerTimes2() async {

  late SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  final int? madhabSelection = prefs.getInt('madhab') ?? 1;

  print("madhab selection main $madhabSelection");

  var madhabValue = "";

  if (madhabSelection == 0){
    madhabValue = "asr_mithl_2";
  } else {
    madhabValue = "asr_mithl_1";
  }




  final url = Uri.parse('https://www.tawheedcenter.org/SalaTime_CurrentMonth_1.2.0.php?asrTime=$madhabValue');
  final response = await http.get(url);
  print("url fetch for prayer times $url");
  print(url);

  if (response.statusCode == 200) {
    final List<dynamic> prayerTimesJson = json.decode(response.body);
    print("got the prayer times");
    print(prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList());
    return prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load prayer times');
  }
}

Future<List<PrayerTime>> fetchPrayerTimes_Notification() async {

  late SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  final int? madhabSelection = prefs.getInt('madhab') ?? 1;

  print("madhab selection main $madhabSelection");

  var madhabValue = "";

  if (madhabSelection == 0){
    madhabValue = "asr_mithl_2";
  } else {
    madhabValue = "asr_mithl_1";
  }




  final url = Uri.parse('https://www.tawheedcenter.org/retrieve7Days_1.2.0.php?asrTime=$madhabValue');
  final response = await http.get(url);
  print("url fetch for prayer times $url");
  print(url);

  if (response.statusCode == 200) {
    final List<dynamic> prayerTimesJson = json.decode(response.body);
    print("got the prayer times for the next 7 days");
    print(prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList());
    return prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load prayer times');
  }
}

// Future<List<PrayerTime>> fetchPrayerTimes2() async {
//   final url = Uri.parse('https://www.tawheedcenter.org/SalaTimes_CurrentMonth.php');
//   final response = await http.get(url);
//
//   if (response.statusCode == 200) {
//     final List<dynamic> prayerTimesJson = json.decode(response.body);
//     print("got the prayer times");
//     print(prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList());
//     return prayerTimesJson.map((json) => PrayerTime.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load prayer times');
//   }
// }

// Future<List<Event>> fetchEvents() async {
//   final url = Uri.parse('https://www.tawheedcenter.org/retrieve_events16.php');
//   final response = await http.get(url);
//
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> eventsJson = json.decode(response.body);
//     List<Event> events = [];
//     eventsJson.forEach((date, eventList) {
//       eventList.forEach((eventJson) {
//         events.add(Event.fromJson(eventJson));
//       });
//     });
//     print("got the events");
//     print(events);
//     return events;
//   } else {
//     throw Exception('Failed to load events');
//   }
// }
  Future<List<Event>> fetchEvents() async {
      final url = Uri.parse('https://www.tawheedcenter.org/retrieveEvents20.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Offload JSON parsing to a background isolate
        return compute(parseEvents, response.body);
      } else {
        throw Exception('Failed to load events');
      }
  }

  // Top-level function to parse events
  List<Event> parseEvents(String responseBody) {
      final Map<String, dynamic> eventsJson = json.decode(responseBody);
      List<Event> events = [];
      eventsJson.forEach((date, eventList) {
        eventList.forEach((eventJson) {
          events.add(Event.fromJson(eventJson));
        });
      });
      return events;
  }
// Future<List<Event>> fetchEvents() async {
//   final url = Uri.parse('https://www.tawheedcenter.org/retrieveEvents20.php');
//   final response = await http.get(url);
//
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> eventsJson = json.decode(response.body);
//     List<Event> events = [];
//     eventsJson.forEach((date, eventList) {
//       eventList.forEach((eventJson) {
//         events.add(Event.fromJson(eventJson));
//       });
//     });
//     print("got the events");
//     print(events);
//     return events;
//   } else {
//     throw Exception('Failed to load events');
//   }
//
//
// }

Future<List<ProgramContact>> fetchProgramNames() async {
  final url = Uri.parse('https://www.tawheedcenter.org/retrieve_programs02.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> programsJson = json.decode(response.body);
    List<ProgramContact> programs = programsJson.map((json) => ProgramContact.fromJson(json)).toList();
    print("got the events2");
    print(programs);
    return programs;
  } else {
    throw Exception('Failed to load events');
  }
}

Future<List<BoardMember>> fetchBoardMembers() async {
  final url = Uri.parse('https://www.tawheedcenter.org/retrieveBoardMembers03.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> boardMembersJson = json.decode(response.body);
    List<BoardMember> boardMembers = boardMembersJson.map((json) {
      final member = BoardMember.fromJson(json);
      //print('Board Member: ${member.name}, Position: ${member.position}, ${member.type}');
      return member;
    }).toList();
    return boardMembers;
  } else {
    throw Exception('Failed to load board members');
  }
}


Future<List<LocalMarketing>> fetchLocalMarketing() async {
  final url = Uri.parse('https://www.tawheedcenter.org/retrieveMarketing09.php');
  final response = await http.get(url);

  print("Starting the marketing fetch");

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);

    // Output the full JSON response
    //print('Full JSON Response: $jsonList');

    // Output the count of objects in the returned JSON
    print('Count of objects in the returned JSON: ${jsonList.length}');

    List<LocalMarketing> programs = jsonList.map((json) {
      String flyerBase64 = json['flyer'];
      List<int> flyerBytes = base64.decode(flyerBase64);

      // Create a LocalMarketing object with the flyer image data
      LocalMarketing marketing = LocalMarketing(imageBase64: flyerBase64);

      // Outputting each LocalMarketing object's details
      //print('Image Base64: ${marketing.imageBase64}');

      return marketing;
    }).toList();

    return programs;
  } else {
    throw Exception('Failed to load events');
  }
}

Future<List<ButtonClass>> fetchButtonData() async {
  final url = Uri.parse('https://www.tawheedcenter.org/retrieveButton8.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> buttonDataJson = json.decode(response.body);
    return buttonDataJson.map((json) => ButtonClass.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load button data');
  }
}


Future<void> modifyTraffic(String feature) async {
  // Determine the device type
  String deviceType = getDeviceType();
  String currVersion = "1.3.0";

  // Construct the URL
  String url = 'https://www.tawheedcenter.org/incrementTraffic_1.2.1.php?device=$deviceType&feature=$feature&version=$currVersion';

  try {
    // Make the HTTP request with cache-control header set to no-cache
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Cache-Control': 'no-cache',
      },
    );
    print("traffic url: $url");
    print("response url: $response");
    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON data (assuming the response is JSON)
      var data = json.decode(response.body);
      print("traffic incremented! $data"); // Handle the parsed data as needed
    } else {
      // Handle server errors or invalid responses
      print('Server error: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network errors or unexpected exceptions
    print('Failed to load data: $e');
  }
}







double? timeToDecimal(String time) {
  // Adjusted regular expression to allow optional space between time and AM/PM
  // and to be case-insensitive for AM/PM
  final RegExp timeRegex = RegExp(r"^(\d{1,2}):(\d{2})\s?(AM|PM|am|pm)?$");

  if (!timeRegex.hasMatch(time)) {
    print("Invalid time format: $time");
    return null; // Return null or handle the error as appropriate
  }

  final match = timeRegex.firstMatch(time)!;
  int hours = int.parse(match.group(1)!);
  int minutes = int.parse(match.group(2)!);
  String? period = match.group(3);

  if (period != null) {
    // Convert to upper case for consistency
    period = period.toUpperCase();
    if (period == "PM" && hours < 12) hours += 12;
    if (period == "AM" && hours == 12) hours = 0;
  }

  // Ensure the hours are within the expected range
  if (hours > 23 || minutes > 59) {
    print("Time out of range: $time");
    return null;
  }

  return hours + minutes / 60.0;
}


int getCurrentPrayerIndex(List<PrayerTime> prayerTimes) {
  final now = DateTime.now();
  final format = DateFormat('HH:mm'); // Assuming 24-hour format for simplicity
  final currentTimeStr = format.format(now);
  final currentTime = format.parse(currentTimeStr);

  int lastPrayerIndex = prayerTimes.length - 1; // Assuming prayerTimes contains today's all prayer times in order
  List<DateTime> todayPrayerTimes = [
    format.parse(prayerTimes[lastPrayerIndex].fajrAzan),
    format.parse(prayerTimes[lastPrayerIndex].dhuhrAzan),
    format.parse(prayerTimes[lastPrayerIndex].asrAzan),
    format.parse(prayerTimes[lastPrayerIndex].magribAzan),
    format.parse(prayerTimes[lastPrayerIndex].ishaAzan),
  ];

  for (int i = 0; i < todayPrayerTimes.length; i++) {
    if (currentTime.isBefore(todayPrayerTimes[i])) {
      return i; // Return the index of the next prayer time
    }
  }

  // If current time is after all prayer times, it should highlight the last prayer of the day (Isha)
  return todayPrayerTimes.length - 1;
}



class CustomDrawer extends StatefulWidget {

  final Function onDrawerClose;

  CustomDrawer({required this.onDrawerClose});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late StreamController<List<BoardMember>> _boardController;
  late StreamController<List<LocalMarketing>> _marketingController;


  @override
  void initState() {
    super.initState();
    _boardController = StreamController.broadcast();
    _marketingController = StreamController.broadcast();
    _fetchBoard();
    _fetchMarketing();



  }

  @override
  void dispose() {
    _boardController.close();
    _marketingController.close();
    super.dispose();
  }

  Future<void> _fetchBoard() async {
    final boardMembers = await fetchBoardMembers();
    _boardController.sink.add(boardMembers);
  }
  Future<void> _fetchMarketing() async {
    final boardMembers = await fetchLocalMarketing();
    _marketingController.sink.add(boardMembers);
  }

  void setStatusBarTextColor(bool isDayTime) {

    print("changing status bar color!");
    SystemChrome.setSystemUIOverlayStyle(
      isDayTime
          ? SystemUiOverlayStyle.dark // Set light text color for day
          : SystemUiOverlayStyle.light, // Set dark text color for night
    );
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.70;


    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 75), // Adjust the height as needed
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                "About",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Vibrate.feedback(FeedbackType.light);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                ).whenComplete(() => Future.delayed(Duration(milliseconds: 100)).then((_) => setStatusBarTextColor(isDayTimeValueDrawer)));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.compass_calibration_outlined),
            //   title: Text(
            //     "Qibla Finder",
            //     style: TextStyle(
            //         fontSize: 20,
            //         //fontWeight: FontWeight.bold,
            //         fontFamily: 'Avenir-Regular'
            //     ),
            //   ),
            //   onTap: () async {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MyApp3(),
            //       ),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.video_collection),
            //   title: Text(
            //     "YouTube",
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontFamily: 'AvenirRegular',
            //       color: Colors.black,
            //     ),
            //   ),
            //   onTap: () async {
            //     const url = 'https://m.youtube.com/@TawheedCenter';
            //     if (await canLaunch(url)) {
            //       await launch(
            //         url,
            //         forceSafariVC: false, // Don't force an in-app Safari
            //         forceWebView: false, // Don't force a WebView
            //         enableJavaScript: true, // Enable JavaScript if required by the URL
            //       );
            //     } else {
            //       throw 'Could not launch $url';
            //     }
            //   },
            // ),
            ListTile(
              leading: Icon(FlutterIslamicIcons.solidFamily),
              title: Text(
                "Counseling with Imam",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/counseling/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.question_mark),
              title: Text(
                "Ask Imam",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/ask-mufti-wahaaj/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.handshake),
              title: Text(
                "Meet Imam",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://tidycal.com/muftiwahaaj';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card_outlined),
              title: Text(
                "Membership",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/membership-2/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text(
                "Banquet Hall",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/banquet-hall/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.flag_outlined),
              title: Text(
                "Funeral Services",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/janazah/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text(
                "Marriage Services",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/marriage-2/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.volunteer_activism),
              title: Text(
                "Community Service",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/community-service/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),


            // ListTile(
            //   leading: Icon(Icons.family_restroom),
            //   title: Text(
            //     "Counseling",
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontFamily: 'AvenirRegular',
            //       color: Colors.black,
            //     ),
            //   ),
            //   onTap: () async {
            //     const url = 'https://www.tawheedcenter.org/counseling/';
            //     if (await canLaunch(url)) {
            //       await launch(
            //         url,
            //         forceSafariVC: false, // Don't force an in-app Safari
            //         forceWebView: false, // Don't force a WebView
            //         enableJavaScript: true, // Enable JavaScript if required by the URL
            //       );
            //     } else {
            //       throw 'Could not launch $url';
            //     }
            //   },
            // ),

            ListTile(
              leading: Icon(Ionicons.logo_instagram),
              title: Text(
                "YMTC",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.instagram.com/ymtcyouth/?hl=en';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),


            ListTile(
              leading: Icon(Icons.woman),
              title: Text(
                "Sisters Committee",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/sisters-column/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            StreamBuilder<List<BoardMember>>(
              stream: _boardController.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<BoardMember>> snapshot) {
                // Your StreamBuilder logic...
                double screenWidth = MediaQuery.of(context).size.width;
                double buttonWidth = screenWidth / 3.5;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: Icon(Icons.lightbulb),
                    title: Text(
                      "Board of Directors/Trustees",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'AvenirRegular',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      if (snapshot.hasData) {

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MyApp9(boardNames: snapshot.data!),
                        //   ),
                        // );
                      } else {
                        print("No board members data available");
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return ListTile(
                    leading: Icon(Icons.lightbulb),
                    title: Text(
                      "Board of Directors/Trustees",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'AvenirRegular',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      if (snapshot.hasData) {
                        Vibrate.feedback(FeedbackType.light);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp9(boardNames: snapshot.data!),
                          ),
                        ).whenComplete(() => Future.delayed(Duration(milliseconds: 100)).then((_) => setStatusBarTextColor(isDayTimeValueDrawer)));
                      } else {
                        print("No board members data available");
                      }
                    },
                  );
                } else {
                  return Text("No data available");
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text(
                "Resources",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'AvenirRegular',
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                const url = 'https://www.tawheedcenter.org/islamic-resources/';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false, // Don't force an in-app Safari
                    forceWebView: false, // Don't force a WebView
                    enableJavaScript: true, // Enable JavaScript if required by the URL
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            StreamBuilder<List<LocalMarketing>>(
              stream: _marketingController.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<LocalMarketing>> snapshot) {
                // Your StreamBuilder logic...
                double screenWidth = MediaQuery.of(context).size.width;
                double buttonWidth = screenWidth / 3.5;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: Icon(Icons.event_note),
                    title: Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'AvenirRegular',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      if (snapshot.hasData) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MyApp9(boardNames: snapshot.data!),
                        //   ),
                        // );
                      } else {
                        print("No board members data available");
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return ListTile(
                    leading: Icon(Icons.event_note),
                    title: Text(
                      "Local Ads",
                      style: TextStyle(
                        fontSize: 17,
                        //fontWeight: FontWeight.bold,
                        fontFamily: 'AvenirRegular',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      if (snapshot.hasData) {
                        Vibrate.feedback(FeedbackType.light);

                        modifyTraffic("localads");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp10(localMarketing: snapshot.data!),
                          ),
                        ).whenComplete(() => Future.delayed(Duration(milliseconds: 100)).then((_) => setStatusBarTextColor(isDayTimeValueDrawer)));
                      } else {
                        print("No board members data available");
                      }
                    },
                  );
                } else {
                  return Text("No data available");
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                "Settings",
                style: TextStyle(
                    fontSize: 17,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'AvenirRegular'
                ),
              ),
              onTap: () async {
                Vibrate.feedback(FeedbackType.light);

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPageNew()),
                ).then((_) async { // Mark this callback as async
                  final prefs = await SharedPreferences.getInstance();
                  final madhab = prefs.getInt('madhab') ?? 0;
                  setState(() {
                    print("Rebuilding after settings $madhab");

                    DateTime now = DateTime.now();
                    fetchPrayerTimes(selectedDate: now);
                    //_madhab = madhab;
                    // Use _madhab as needed to refresh data or update the UI
                  });
                 // Navigator.of(context).pop(); // This closes the drawer
                  widget.onDrawerClose();
                });


                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp8(),)).then((result) {
                //   if (result != null) {
                //     var returnedColor1 = result['color1'];
                //     var returnedColor2 = result['color2'];
                //     print("here are final colors, welcome");
                //     print(returnedColor1);
                //     print(returnedColor2);
                //   }
                // });
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

Widget _customDrawer(BuildContext context, Function onDrawerClose) {
  return CustomDrawer(onDrawerClose: onDrawerClose);
}


Future<String> _checkDevice() async {
  late String deviceModel;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // Combine brand and model for a more descriptive name
    deviceModel = "${androidInfo.brand} ${androidInfo.model}";
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    // iosInfo.model provides a generic name, use iosInfo.utsname.machine for the identifier
    String identifier = iosInfo.utsname.machine!;
    // Mapping the identifier to a model name requires an external method or database
    //deviceModel = _mapIosIdentifierToModel(identifier); // You need to implement this method
    deviceModel = identifier;
  } else {
    // Handle other platforms if needed
    deviceModel = 'Unknown'; // Default value for other platforms
  }
  return deviceModel;
}

Future<double> getMaxScreenHeight() async {
  double maxScreenHeight = 0.0;
  try {
    final window = WidgetsBinding.instance!.window;
    final screenSize = window.physicalSize;
    final screenHeight = screenSize.height;
    maxScreenHeight = screenHeight / window.devicePixelRatio;
  } on PlatformException catch (e) {
    print("Error: ${e.message}");
  }
  return maxScreenHeight;
}


double _convertTimeToDecimal(String time) {
  // Split the time into components
  List<String> parts = time.split(':');
  // Extract hours and minutes
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  // Convert to decimal
  return hours + (minutes / 60);
}

String getDeviceType() {
  if (kIsWeb) {
    return 'web';
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return 'ios';
    case TargetPlatform.android:
      return 'android';
    default:
      return 'unknown';
  }
}