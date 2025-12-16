//AI 분석 결과 화면
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../function/result_function.dart';
import '../UI/home_page.dart';

class ResultPage extends StatefulWidget {
    const ResultPage({super.key});

    @override
    State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
    late String emotionResult;

    String summaryText = "";
    List<Map<String, String>> careList = [];
    String representativeEmoji = "";
    
    bool isSaved = false; //중복 방지
    bool isViewMode = false;

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();

        final args = ModalRoute.of(context)!.settings.arguments as Map;
        final String mode = args['mode']; 

        if(mode == 'new') {
            //AI 분석 직후 (저장)
            emotionResult = args['resultText'];
            _parseResult(emotionResult);
            _saveOnce();
        }

        if(mode == 'view') {
            //캘린더에서 과거 결과 보기(절대 저장 X)
            isViewMode = true;
            final String dateKey = args['dateKey'];
            _loadResultFromFirestore(dateKey);
        }
    }

    //AI 응답 결과 파싱 함수, text: AI가 생성한 전체 응답 문자열
    void _parseResult(String text) {
        if(text.contains("[🤖 오늘의 대표 감정]")) { //대표 감정 이모지 추출
            final split = text.split("[🤖 오늘의 대표 감정]"); //섹션 기준으로 텍스트 분리
            text = split[0]; //대표 감정 이전 내용만 남김
            representativeEmoji = split[1].trim().split('\n').first.trim(); //대표 감정 이모지 추출 (첫 줄 / 공백 제거)
        }

        if(!text.contains("[✨ 오늘의 감정 케어 추천]")) { //감정 케어 추천 섹션이 없는 경우 처리
            summaryText = text.replaceAll("[🧠 분석 결과 요약]", "").trim(); //분석 요약 태그 제거 후 요약 텍스트로 사용
            return; //더 이상 파싱할 내용이 없으므로 종료
        }

        final parts = text.split("[✨ 오늘의 감정 케어 추천]"); //요약 / 감정 케어 추천 영역 분리

        summaryText = parts[0].replaceAll("[🧠 분석 결과 요약]", "").trim(); //분석 결과 요약 텍스트 추출

        final lines = parts[1].trim().split('\n'); //감정 케어 추천 영역을 줄 단위로 분리

        //감정 케어 리스트 파싱
        careList.clear(); //이전 데이터 제거 (중복 방지)

        String? title; //추천 제목
        String? desc; //추천 설명

        for(final line in lines) {
            final t = line.trim(); //앞뒤 공백 제거

            if(t.startsWith('-')) { // '-'로 시작하면 새로운 추천 항목 제목
                if(title != null && desc != null) { //이전 추천 항목이 완성되어 있으면 리스트에 추가
                    careList.add({
                        "title": title!,
                        "description": desc!,
                    });
                }
                title = t.replaceFirst('-', '').trim(); //새로운 추천 제목 설정
                desc = ""; //설명 초기화
            } else if(t.isNotEmpty && title != null) { //제목이 존재하고 공백이 아닌 줄이면 설명으로 처리
                desc = t;
            }
        }

        if(title != null && desc != null) { //마지막 감정 케어 항목 추가
            careList.add({
                "title": title!,
                "description": desc!,
            });
        }
    }

    Future<void> _loadResultFromFirestore(String dateKey) async {
        final user = FirebaseAuth.instance.currentUser;
        if(user == null) return;

        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('ai_analysis')
            .doc(dateKey)
            .get();

        if(!doc.exists) return;

        setState(() {
            summaryText = doc['summary'];
            representativeEmoji = doc['representativeEmoji'];

            careList = List<Map<String, String>>.from(
                doc['careList'].map((e) => Map<String, String>.from(e)),
            );
        });
    }

    Future<void> _saveOnce() async {
        if(isSaved) return;
        isSaved = true;

        await saveAIResultToFirestore(
            summary: summaryText,
            careList: careList,
            representativeEmoji: representativeEmoji,
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("AI 분석 결과", style: GoogleFonts.doHyeon(fontSize: 20, color: const Color(0xFF3D3A35),),),
                centerTitle: true,
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("🧠 분석 결과 요약", style: GoogleFonts.jua(fontSize: 18)),
                        const SizedBox(height: 10),

                        Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color:Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(summaryText, style: const TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 30),

                        Text("✨ 오늘의 감정 케어 추천", style: GoogleFonts.jua(fontSize: 18)),
                        const SizedBox(height: 15),

                        ...careList.map((care) {
                            return _buildCareCard(
                                care['title']!,
                                care['description']!,
                            );
                        }),
                        const SizedBox(height: 18),

                        Center(
                            child: ElevatedButton(
                                onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (_) => const HomePage()),
                                        (route) => false,
                                    );
                                },
                                child: const Text("홈으로 가기"),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildCareCard(String title, String desc) {
        return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                    BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05))
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(desc, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                ],
            ),
        );
    }
}
