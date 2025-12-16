//통계 로직
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

DateTime startOfWeek(DateTime date) {
    final diff = date.weekday % 7; //일요일 = 0
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: diff));
}

DateTime endOfWeek(DateTime date) {
    return startOfWeek(date).add(const Duration(days: 6));
}

DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
}

DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
}

Future<Map<String, double>> loadEmotionAverage({
    required bool isWeekly,
}) async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return <String, double>{};

    final now = DateTime.now();
    final start = isWeekly ? startOfWeek(now) : startOfMonth(now);
    final end = isWeekly ? endOfWeek(now) : endOfMonth(now);
    
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('emotions')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
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

    return {
        "joy": joy / count,
        "anger": anger / count,
        "anxiety": anxiety / count,
        "comfort": comfort / count,
        "sadness": sadness / count,
    };
}