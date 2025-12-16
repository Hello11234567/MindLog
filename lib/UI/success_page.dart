//분석완료!가 나오게 하는 화면
import 'package:flutter/material.dart';
import '../UI/result_page.dart';

class AnalysisSuccessPage extends StatefulWidget {
    final String result;
    const AnalysisSuccessPage({super.key, required this.result});

    @override
    State<AnalysisSuccessPage> createState() => _AnalysisSuccessPageState();
}

class _AnalysisSuccessPageState extends State<AnalysisSuccessPage> {
    @override
    void initState() {
        super.initState();
        Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(
                context, '/result', arguments: {
                    'mode': 'new',
                    'resultText': widget.result
                },
            );
        });
    }
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Icon(Icons.smart_toy, size: 100),
                        const SizedBox(height: 20),
                        
                        Text("분석 완료!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        
                        Text("결과를 정리하고 있어요 😊")
                    ],
                ),
            ),
        );
    }
}