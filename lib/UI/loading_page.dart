//AI분석 결과로 넘어가기 전 로딩화면
import 'dart:async';
import 'package:flutter/material.dart';
import '../UI/success_page.dart';
import '../function/AI_services_function.dart';

class LoadingPage extends StatefulWidget {
    final String emotionText; //결과 분석 텍스트 전달받기

    const LoadingPage({super.key, required this.emotionText});

    @override
    State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
    String loadingText = "AI가 감정을 분석하고 있어요...";

    @override
    void initState() {
        super.initState();
        _startAnalysis();        
    }

    Future<void> _startAnalysis() async {
        //2초 후 문구 변경
        Future.delayed(const Duration(seconds: 2),() {
            if(mounted) {
                setState(() {
                    loadingText = "오늘 하루를 이해하는 중이에요...";
                });
            }
        });

        final start = DateTime.now();

        //AI 분석 실행
        final aiResult = await AIService.analyzeEmotionText(widget.emotionText);

        final elapsed = DateTime.now().difference(start);
        if(elapsed < const Duration(seconds: 2)) {
            await Future.delayed(const Duration(seconds: 2) - elapsed);
        }

        Navigator.pushReplacementNamed(context, '/success', arguments: aiResult);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20), 
                        Text(loadingText, style: const TextStyle(fontSize: 18)),
                    ],
                ),
            ),
        );
    }
}