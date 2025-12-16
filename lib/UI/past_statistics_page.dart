//지난 주간/월간 통계 화면
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastStatisticsPage extends StatefulWidget {
    const PastStatisticsPage({super.key});

    @override
    State<PastStatisticsPage> createState() => _PastStatisticsPageState();
}

class _PastStatisticsPageState extends State<PastStatisticsPage> {
    bool isWeekly = true;

    //불러온 지난 통계 목록
    List<QueryDocumentSnapshot> statisticsList = [];

    //현재 보고 있는 통계 인덱스
    int currentIndex = 0;

    @override
    void initState() {
        super.initState();
        _loadPastStatistics();
    }

    //지난 통계 불러오기
    Future<void> _loadPastStatistics() async {
        final user = FirebaseAuth.instance.currentUser;
        if(user == null) return;

        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('statistics') 
            .where('type', isEqualTo: isWeekly ? 'weekly' : 'monthly')
            .orderBy('startDate', descending: true)
            .get();

        setState(() {
            statisticsList = snapshot.docs;
            currentIndex = 0;
        });
    }

    //이전 통계로 이동
    void _movePrev() {
        if(currentIndex < statisticsList.length - 1) {
            setState(() {
                currentIndex++;
            });
        }
    }

    //다음 통계로 이동
    void _moveNext() {
        if(currentIndex > 0) {
            setState(() {
                currentIndex--;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        //통계 데이터 없음 처리
        if(statisticsList.isEmpty) {
            return Scaffold(
                appBar: AppBar(
                    title: Text("지난 감정 통계", style: GoogleFonts.doHyeon(fontSize: 20)),
                    centerTitle: true,
                ),
                body: const Center(child: Text("저장된 통계가 없습니다.")),
            );
        }

        final data = statisticsList[currentIndex].data() as Map<String, dynamic>;

        return Scaffold(
            appBar: AppBar(
                title: Text("지난 감정 통계", style: GoogleFonts.doHyeon(fontSize: 20)),
                centerTitle: true,
            ),
            body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                _buildToggleButton("주간", true),
                                const SizedBox(width: 12),
                                _buildToggleButton("월간", false),
                            ],
                        ),
                        const SizedBox(height: 24),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                IconButton(
                                    onPressed: _movePrev,
                                    icon: const Icon(Icons.chevron_left),
                                ),
                                Text(
                                    data['label'] ?? "",
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                IconButton(
                                    onPressed: _moveNext,
                                    icon: const Icon(Icons.chevron_right),
                                ),
                            ],
                        ),
                        const SizedBox(height: 16),

                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF6F8F7),
                                borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        "🤖 AI 요약", style: GoogleFonts.jua(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(data['aiSummary'] ?? "", style: const TextStyle(fontSize: 14),),
                                ],
                            ),
                        ),

                        Container(
                            height: 220,
                            width: double.infinity,
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
                            child: const Center(
                                child: Text("📈 감정 평균 그래프"),
                            ),
                        ),
                        const SizedBox(height: 24),

                        Text("📋 감정 평균 요약", style: GoogleFonts.jua(fontSize: 16),),
                        const SizedBox(height: 12),

                        Expanded(
                            child: ListView(children: _buildEmotionTiles(data['averages']),),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildToggleButton(String text, bool weekly) {
        final bool selected = isWeekly == weekly;

        return GestureDetector(
            onTap: () {
                setState(() {
                    isWeekly = weekly;
                });
                _loadPastStatistics();
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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

    //평균 데이터 -> 타일 생성
    List<Widget> _buildEmotionTiles(Map<String, dynamic> averages) {
        return averages.entries.map((e) {
            return _EmotionAverageTile(
                _emojiForKey(e.key),
                _labelForKey(e.key),
                (e.value as num).toDouble(),
            );
        }).toList();
    }

    // key -> 이모지
    String _emojiForKey(String key) {
        switch (key) {
            case 'joy': return '😊';
            case 'anger': return '😡';
            case 'anxiety': return '😟';
            case 'comfort': return '😌';
            case 'sadness': return '😢';
            default: return '';
        }
    }

    //key -> 한글 라벨
    String _labelForKey(String key) {
        switch (key) {
            case 'joy': return '기쁨';
            case 'anger': return '분노';
            case 'anxiety': return '불안';
            case 'comfort': return '편안';
            case 'sadness': return '슬픔';
            default: return '';
        }
    }
}

class _EmotionAverageTile extends StatelessWidget {
    final String emoji;
    final String label;
    final double value;

    const _EmotionAverageTile(this.emoji, this.label, this.value);

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                    ),
                ],
            ),
            child: Row(
                children: [
                    Text(emoji, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            label,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                    ),
                    Text(
                        "${value.toStringAsFixed(1)}점",
                        style: const TextStyle(color: Colors.black54),
                    ),
                ],
            ),
        );
    }
}