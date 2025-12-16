//수치화된 감정 저장
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveEmotionToFirestore(int joy, int anger, int anxiety, int comfort, int sadness) async {
    final user = FirebaseAuth.instance.currentUser;

    if(user == null) return; //로그인 안되어 있으면 종료

    final uid = user.uid;
    final today = DateTime.now();
    final formattedDate = DateTime.now().toIso8601String().split("T")[0];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('emotions')
        .doc(formattedDate)
        .set({
            "joy": joy, "anger": anger, "anxiety": anxiety, "comfort": comfort, "sadness": sadness, "createdAt": FieldValue.serverTimestamp(),
        });

        print("감정 데이터 저장 완료");
}