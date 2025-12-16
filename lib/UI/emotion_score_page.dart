//감정 분석 기록 화면
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../function/emotion_score_function.dart';
import '../function/loading_function.dart';

class EmotionPage extends StatefulWidget {
    const EmotionPage({super.key});

    @override
    State<EmotionPage> createState() => _EmotionPageState();
}

class _EmotionPageState extends State<EmotionPage> {
    double joy = 3;
    double anger = 3;
    double anxiety =3;
    double comfort = 3;
    double sadness = 3;

    bool isLoading = false;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text("오늘의 감정 기록", style: GoogleFonts.doHyeon(fontSize: 24, color: Color(0xFF3d3A35),),), centerTitle: true, backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black,),
            body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    children: [
                        buildEmotionTile("기쁨", joy, Icons.sentiment_satisfied_outlined, Colors.orange, (v) => setState(() => joy = v)),
                        buildEmotionTile("화남", anger, Icons.sentiment_dissatisfied, Colors.redAccent, (v) => setState(() => anger = v)),
                        buildEmotionTile("불안", anxiety, Icons.sentiment_neutral, Colors.blueGrey, (v) => setState(() => anxiety = v)),
                        buildEmotionTile("편안", comfort, Icons.sentiment_satisfied, Colors.green, (v) => setState(() => comfort = v)),
                        buildEmotionTile("슬픔", sadness, Icons.sentiment_dissatisfied, Colors.blue, (v) => setState(() => sadness = v)),
                        const SizedBox(height: 25),
                        
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: isLoading ? null : () async {
                                setState(() => isLoading = true);

                                await saveEmotionToFirestore(
                                   joy.toInt(),
                                   anger.toInt(),
                                   anxiety.toInt(),
                                   comfort.toInt(),
                                   sadness.toInt(),
                                );

                                final emotionText = makeEmotionText(
                                    joy: joy.toInt(),
                                    anger: anger.toInt(),
                                    anxiety: anxiety.toInt(),
                                    comfort: comfort.toInt(),
                                    sadness: sadness.toInt(),
                                );

                                Navigator.pushNamed(context, '/loading', arguments: emotionText);

                                setState(() => isLoading = false);
                            },
                            child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("AI 분석하기", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget buildEmotionTile(String label, double value, IconData icon, Color color, Function(double) onChanged) {
        return Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
            ),

            child: Row(
                children: [
                    Icon(icon, color: color, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    "$label : ${value.toInt()}",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600
                                    ),
                                ),
                                Slider(
                                    value: value,
                                    min: 0,
                                    max: 5,
                                    divisions: 5,
                                    label: value.toInt().toString(),
                                    activeColor: color,
                                    onChanged: onChanged,
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}