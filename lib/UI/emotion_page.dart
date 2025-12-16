//캘린더 기록 화면
import 'package:flutter/material.dart';

class RecordEmotionPage extends StatefulWidget {
  const RecordEmotionPage({super.key});

  @override
  State<RecordEmotionPage> createState() => _RecordEmotionPageState();
}

class _RecordEmotionPageState extends State<RecordEmotionPage> {
  final TextEditingController _controller = TextEditingController();
  String _selectedEmotion = '😊';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 감정 기록')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              '오늘 기분을 선택하세요',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: ['😊','😢','😡','😍','😐'].map((emoji) {
                return ChoiceChip(
                  label: Text(emoji, style: const TextStyle(fontSize: 24)),
                  selected: _selectedEmotion == emoji,
                  onSelected: (selected) {
                    setState(() {
                      _selectedEmotion = emoji;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '오늘의 감정을 간단히 기록해보세요',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 여기에 Firestore 저장 로직 추가
                String text = _controller.text;
                String emotion = _selectedEmotion;
                // 예: saveEmotionToFirestore(emotion, text);

                // 저장 후 이전 화면으로 돌아가기
                Navigator.pop(context);
              },
              child: const Text('기록하기'),
            ),
          ],
        ),
      ),
    );
  }
}
