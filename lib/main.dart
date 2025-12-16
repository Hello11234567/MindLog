import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import '../UI/login_page.dart';
import '../UI/signup_page.dart';
import '../UI/home_page.dart';
import '../UI/loading_page.dart';
import '../UI/result_page.dart';
import '../UI/success_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //타임존 초기화 (알림 예약에 필요)
  tz.initializeTimeZones();

  //로컬 알림 초기화
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 한국어 로케일 초기화
  await initializeDateFormatting('ko_KR', null);

  //Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindlog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F6F2),
        textTheme: GoogleFonts.gowunDodumTextTheme().apply(
          bodyColor: const Color(0xFF3D3A35),
          displayColor: const Color(0xFF3D3A35),
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8AA6A3),
          primary: const Color(0xFF7FA0A1),
          secondary: const Color(0xFFBFD8D5),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F6F2),
          elevation: 0,
          foregroundColor: Color(0xFF3D3A35),
        ),
      ),

      home: const LoginPage(), //바로 로그인 화면으로 전환
      
      routes: {
        '/signup': (context) => const SignUpPage(), 
        '/home': (context) => const HomePage(),
        '/loading': (context) {final args = ModalRoute.of(context)!.settings.arguments as String; return LoadingPage(emotionText: args); },
        '/result': (context) => ResultPage(),
        '/success': (context) {final args = ModalRoute.of(context)!.settings.arguments as String; return AnalysisSuccessPage(result: args); },
      }
    );
  }
}