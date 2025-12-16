//메인화면 기능
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

//날짜별 감정 데이터 저장 구조
Map<String, Map<String, String>> emotionData = {};

Map<String, String> aiEmojiData = {};

Future<void> loadEmotionData() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    //유저별 감정 데이터 경로
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('daily_records')
        .get();
    
    emotionData.clear();

    for(var doc in snapshot.docs) {
        emotionData[doc.id] = {
            "emoji": doc["emoji"] ?? "",
            "text": doc["text"] ?? "",
        };
    }
}

Future<void> loadAiAnalysisEmoji() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('ai_analysis')
        .get();
    
    aiEmojiData.clear();

    for(var doc in snapshot.docs) {
        aiEmojiData[doc.id] = doc['representativeEmoji'] ?? '';
    }
}

Future<void> saveEmotion(String dateKey, String emoji, String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('daily_records')
        .doc(dateKey)
        .set({
            'emoji': emoji,
            'text': text,
            'createdAt': FieldValue.serverTimestamp(),
        });

    emotionData[dateKey] = {
            "emoji": emoji,
            "text": text, 
    };
}

//감정 입력 모달
void showEmotionModal(BuildContext context, DateTime day, VoidCallback refreshUI) {
    final String dateKey = day.toIso8601String().split("T")[0];
    String selectedEmoji = emotionData[dateKey]?["emoji"] ?? "";
    TextEditingController textController = TextEditingController(text: emotionData[dateKey]?["text"] ?? "");

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 20, right: 20, top: 20,
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const Text(
                            "감정 이모티콘 (기쁨, 편안함, 걱정, 슬픔, 짜증)",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                _emotionCircle("😀", (emoji) => selectedEmoji = emoji, selectedEmoji),
                                _emotionCircle("😌", (emoji) => selectedEmoji = emoji, selectedEmoji),
                                _emotionCircle("😟", (emoji) => selectedEmoji = emoji, selectedEmoji),
                                _emotionCircle("😢", (emoji) => selectedEmoji = emoji, selectedEmoji),
                                _emotionCircle("😡", (emoji) => selectedEmoji = emoji, selectedEmoji),
                            ],
                        ),
                        const SizedBox(height: 24),

                        TextField(
                            controller: textController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "오늘 기분 한 줄",
                            ),
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton(
                            onPressed: () {
                                saveEmotion(dateKey, selectedEmoji, textController.text);
                                Navigator.pop(context);
                                refreshUI();
                            },
                            child: const Text("저장"),
                        ),
                        const SizedBox(height: 20),
                    ],
                ),
            );
        },
    );
}

//감정 선택 아이콘 위젯
Widget _emotionCircle(String emoji, Function(String) onSelect, String selected) {
    return GestureDetector(
        onTap: () => onSelect(emoji),
        child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                color: selected == emoji ? Colors.redAccent : Colors.pink.shade200,
                shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                ),
            ),
        ),
    );
}

//캘린더 날짜 밑 감정 아이콘 표시
CalendarBuilders buildCalendarBuilders() {
    return CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
            return _buildDayCell(day, focusedDay, isSelected: false);
        },
        
        todayBuilder: (context, day, focusedDay) {
            return _buildDayCell(day, focusedDay, isToday: true);
        },
        selectedBuilder: (context, day, focusedDay) {
            return _buildDayCell(day, focusedDay, isSelected: true);
        },
    );
}

Widget _buildDayCell(
    DateTime day,
    DateTime focusedDay, {
        bool isToday = false,
        bool isSelected = false,
    }) {
        final dateKey = day.toIso8601String().split("T")[0];
        final userEmoji = emotionData[dateKey]?["emoji"];
        final aiEmoji = aiEmojiData[dateKey];

        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(
                    width: 33, height: 33,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.redAccent, width: 2) : null
                    ),
                    child: Text('${day.day}', style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: day.weekday == DateTime.sunday ? Colors.red : day.weekday == DateTime.saturday ? Colors.blue : Colors.black87,
                    ),),
                ),
                const SizedBox(height: 4),

                if(userEmoji != null && userEmoji.isNotEmpty)
                    Text(userEmoji, style: const TextStyle(fontSize: 18)),
                    
                if(aiEmoji != null && aiEmoji.isNotEmpty)
                    Text('🤖 $aiEmoji', style: const TextStyle(fontSize: 12)),
            ],
        );
    }
