//설정 기능
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// 알림 시간 저장
Future<void> saveNotificationTime(TimeOfDay time) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await docRef.set({
    'notificationTime': {
      'hour': time.hour,
      'minute': time.minute,
    }
  }, SetOptions(merge: true));
}

// 알림 상태 저장
Future<void> saveNotificationEnabled(bool enabled) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await docRef.set({
    'notificationsEnabled': enabled,
  }, SetOptions(merge: true));
}

// Firestore에서 시간 불러오기
Future<TimeOfDay?> loadNotificationTime() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final doc = await docRef.get();

  if (doc.exists && doc.data()?['notificationTime'] != null) {
    final data = doc.data()!['notificationTime'];
    return TimeOfDay(hour: data['hour'], minute: data['minute']);
  }

  return null;
}

// Firestore에서 알림 상태 불러오기
Future<bool> loadNotificationEnabled() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return true; // 기본 true

  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final doc = await docRef.get();

  if (doc.exists && doc.data()?['notificationsEnabled'] != null) {
    return doc.data()!['notificationsEnabled'];
  }
  return true;
}
