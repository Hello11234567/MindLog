//메인 화면
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../UI/setting_page.dart';
import '../UI/emotion_score_page.dart';
import '../UI/result_page.dart';
import '../UI/statistics_page.dart';
import '../UI/past_statistics_page.dart';
import '../function/home_function.dart';
import '../function/past_statistics_function.dart';

class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    DateTime _focusedDay = DateTime.now();
    DateTime _selectedDay = DateTime.now();

    @override
    void initState() {
        super.initState();

        //로그인 시 한 번에 다 불러와서 바로 표시
        Future.microtask(() async {
            await loadEmotionData();
            await loadAiAnalysisEmoji();
            if(mounted) setState(() {});
        });

        savePastStatistics(isWeekly: true);
        savePastStatistics(isWeekly: false);
    }

    //다른 화면 갔다왔을 때 다시 로딩
    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        loadEmotionData();
        loadAiAnalysisEmoji();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: const Color(0xFFF5D97B),
            //사이드 메뉴
            drawer: Drawer(
                backgroundColor: Colors.white,
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                        const DrawerHeader(
                            decoration: BoxDecoration(color: Color(0xFFF5D97B)),
                            child: Text(
                                '메뉴',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                        ),
                        
                        ListTile(
                            leading: const Icon(Icons.home),
                            title: const Text('홈'),
                            onTap: () {
                                Navigator.pop(context);
                            },
                        ),

                        ListTile(
                            leading: const Icon(Icons.bar_chart),
                            title: const Text(' 현재 통계 보기'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => StatisticsPage()),
                                );
                            },
                        ),

                        ListTile(
                            leading: const Icon(Icons.bar_chart),
                            title: const Text('지난 통계 보기'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PastStatisticsPage()),
                                );
                            },
                        ),

                        ListTile(
                            leading: const Icon(Icons.smart_toy),
                            title: const Text('AI 분석하러 가기'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EmotionPage()),
                                );
                            },
                        ),

                        ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('설정'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SettingsPage()),
                                );
                            },
                        ),
                    ],
                ),
            ),
            appBar: AppBar(
                backgroundColor: const Color(0xFFF5D97B),
                elevation: 0,
                leading: Builder(
                    builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black87),
                        onPressed: () {
                            Scaffold.of(context).openDrawer();
                        },
                    ),
                ),

                title: Text(
                    DateFormat('yyyy년 M월').format(_focusedDay),
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                    ),
                ),
                centerTitle: true,
            ),
            body: Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                        setState(() {
                                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                                        });
                                    },
                                ),

                                IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    onPressed: () {
                                        setState(() {
                                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                                        });
                                    },
                                ),
                            ],
                        ),
                    ),

                    AspectRatio(
                        aspectRatio: 0.7,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                            color: const Color(0xFFFFF6D6),
                            borderRadius: BorderRadius.circular(16),
                            ),
                            child: TableCalendar(
                                locale: 'ko_KR',
                                firstDay: DateTime.utc(2020, 1, 1),
                                lastDay: DateTime.utc(2030, 12, 31),
                                focusedDay: _focusedDay,
                                headerVisible: false,

                                rowHeight: 85,
                                daysOfWeekHeight: 60,

                                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                                        _selectedDay = selectedDay;
                                         _focusedDay = focusedDay;
                                    });
                                    showEmotionModal(context, selectedDay, () async {
                                        await loadEmotionData();
                                        await loadAiAnalysisEmoji();
                                        if(mounted) setState(() {});
                                    });
                                },

                                onDayLongPressed: (selectedDay, foucsedDay) {
                                    final dateKey = selectedDay.toIso8601String().split("T")[0];

                                    Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                            builder: (_) => const ResultPage(), 
                                            settings: RouteSettings(arguments: {
                                                'mode': 'view',
                                                'dateKey': dateKey,
                                            }),
                                        ),
                                    );
                                },
                                

                                calendarStyle: CalendarStyle(
                                    todayDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                    ),
                                    weekendTextStyle: const TextStyle(color: Colors.blue),
                                    holidayTextStyle: const TextStyle(color: Colors.red),
                                ),
                                calendarBuilders: buildCalendarBuilders(), // 감정 아이콘 표시
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}