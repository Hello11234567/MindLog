//AI 분석 결과 데이터 저장
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveAIResultToFirestore({
    required String summary,
    required List<Map<String, String>> careList,
    required String representativeEmoji,
}) async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final uid = user.uid;
    final today = DateTime.now();
    final dateKey = DateTime.now().toIso8601String().split("T")[0];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('ai_analysis')
        .doc(dateKey)
        .set({
         "summary": summary,
         "careList": careList,
         "representativeEmoji": representativeEmoji,
         "createdAt": FieldValue.serverTimestamp(),
    });
}