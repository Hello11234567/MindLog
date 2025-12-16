//통계 화면
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../function/statistics_function.dart';

class StatisticsPage extends StatefulWidget {
    const StatisticsPage({super.key});

    @override
    State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
    bool isWeekly = true; // true: 일주일, false: 한 달

    final List<Map<String, dynamic>> emotions = [
        {"key": "joy", "label": "기쁨", "emoji": "😊", "value": 0.0},
        {"key": "anger", "label": "화남", "emoji": "😡", "value": 0.0},
        {"key": "anxiety", "label": "불안", "emoji": "😟", "value": 0.0},
        {"key": "comfort", "label": "편안", "emoji": "😌", "value": 0.0},
        {"key": "sadness", "label": "슬픔", "emoji": "😢", "value": 0.0},
    ];


     //통계 데이터 로딩
    Future<void> _loadStatistics() async {
        final averages = await loadEmotionAverage(isWeekly: isWeekly);

        setState(() {
            for(var emotion in emotions) {
                emotion["value"] = averages[emotion["key"]] ?? 0.0;
            }
        });
    }

    @override
    void initState() {
        super.initState();
        _loadStatistics();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("감정 통계", style: GoogleFonts.doHyeon(fontSize: 20, color: const Color(0xFF3D3A35),),),
                centerTitle: true,
            ),
            body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        //기간 토글
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                _buildToggleButton("일주일", true),
                                const SizedBox(width: 12),
                                _buildToggleButton("한 달", false),
                            ],
                        ),
                        const SizedBox(height: 30),

                        //그래프 자리
                        Container(
                            height: 260,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 6,
                                    ),
                                ],
                            ),
                            child: buildEmotionRadarChart(),
                        ),
                        const SizedBox(height: 30),

                        //감정 평균 카드
                        Text(
                            "감정 평균 요약",
                            style: GoogleFonts.jua(fontSize: 18),
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                            child: GridView.builder(
                                itemCount: emotions.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.6,
                                ),
                                itemBuilder: (context, index) {
                                    final emotion = emotions[index];
                                    return _buildEmotionCard(
                                        emotion["emoji"],
                                        emotion["label"],
                                        emotion["value"],
                                    );
                                },
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    //토글 버튼
    Widget _buildToggleButton(String text, bool weekly) {
        final bool selected = isWeekly == weekly;

        return GestureDetector(
            onTap: () {
                setState(() {
                    isWeekly = weekly;
                });
                _loadStatistics();
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: selected ? const Color(0xFF9FCFB3) : const Color(0xFFF2F6F3),
                    borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                    text,
                    style: TextStyle(
                        color: selected ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                    ),
                ),
            ),
        );
    }

    //감정 카드
    Widget _buildEmotionCard(String emoji, String label, double value) {
        return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                    ),
                ],
            ),
            child: Row(
                children: [
                    Text(emoji, style: const TextStyle(fontSize: 28),),
                    const SizedBox(width: 12),
                    
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(
                                label,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                                "평균 ${value.toStringAsFixed(1)}점",
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                ),
                            ),
                        ],
                    ),
                ],
            ),
        );
    }

    //레이더 차트 위젯
    Widget buildEmotionRadarChart() {
        final values = emotions.map((e) => e["value"] as double).toList();
        
        return RadarChart(
            RadarChartData(
                radarShape: RadarShape.polygon,

                tickCount: 5,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                gridBorderData: const BorderSide(color: const Color(0xFFDDEAE2), width: 1),
                radarBorderData: BorderSide.none,

                //감정 축
                titleTextStyle: const TextStyle(
                    color: Color(0xFF6B8F7B),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                ),
                getTitle: (index, angle) {
                    const titles = ['기쁨', '화남', '불안', '편안', '슬픔'];
                    return RadarChartTitle(text: titles[index], positionPercentageOffset: 0.08,);
                },


                dataSets: [
                    RadarDataSet(
                        fillColor: const Color(0xFFE6F4EA).withOpacity(0.35),
                        borderColor: const Color(0xFF9FCFB3),
                        borderWidth: 2,
                        entryRadius: 2.5,
                        dataEntries: values.map((v) => RadarEntry(value: v.clamp(0, 5))).toList(),
                    ),
                ],
            ),
        );
    }
}