//지난 주간/월간 통계 로직
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore_firestore = FirebaseFirestore.instance;

//지난 주간/월간 통계 저장
Future<void> savePastStatistics({
    required bool isWeekly, // true: 주간, //false: 월간
}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final now = DateTime.now();

    DateTime startDate;
    DateTime endDate;
    String docId;
    String type;

    if(isWeekly) {
        //주간 통계 (일~토 기준)
        final weekday = now.weekday; //월=1, ... 일=7
        startDate = now.subtract(Duration(days: weekday % 7));
        endDate = startDate.add(const Duration(days: 6));

        docId = "week_${startDate.year}_${startDate.month}_${startDate.day}";
        type = "weekly";
    } else {
        //월간 통계
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);

        docId = "month_${now.year}_${now.month}";
        type = "monthly";
    }

    //감정 데이터 조회
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('emotions') // 감정 수치 저장된 컬렉션
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    double joy = 0, anger = 0, anxiety = 0, comfort = 0, sadness = 0;

    for(final doc in snapshot.docs) {
        joy += (doc['joy'] ?? 0).toDouble();
        anger += (doc['anger'] ?? 0).toDouble();
        anxiety += (doc['anxiety'] ?? 0).toDouble();
        comfort += (doc['comfort'] ?? 0).toDouble();
        sadness += (doc['sadness'] ?? 0).toDouble();
    }

    final count = snapshot.docs.isEmpty ? 1 : snapshot.docs.length;

    final averages = {
        "joy": joy / count,
        "anger": anger / count,
        "anxiety": anxiety / count,
        "comfort": comfort / count,
        "sadness": sadness / count,
    };

    //firestore 저장
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('statistics') // 감정 수치 저장된 컬렉션
        .doc(docId)
        .set({
            "type": type,
            "startDate": Timestamp.fromDate(startDate),
            "endDate": Timestamp.fromDate(endDate),
            "averages": averages,
            "createdAt": FieldValue.serverTimestamp(),
        });
}