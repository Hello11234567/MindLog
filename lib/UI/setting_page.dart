//설정 화면
import 'package:flutter/material.dart';
import '../function/setting_function.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0); // 기본 20:00

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final enabled = await loadNotificationEnabled();
    final time = await loadNotificationTime();

    setState(() {
      _notificationsEnabled = enabled;
      if (time != null) _selectedTime = time;
    });
  }

  Future<void> _pickTime(BuildContext context) async {
    if (!_notificationsEnabled) return; // 알림 꺼져있으면 선택 불가

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
      await saveNotificationTime(_selectedTime); // Firestore에 저장
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 알림 설정
          ListTile(
            title: const Text('알림'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('오늘 하루는 어떠셨나요? 알림을 받습니다.'),
                const SizedBox(height: 4),
                Text(
                  '알림 시간: ${_selectedTime.format(context)}',
                  style: TextStyle(
                    color: _notificationsEnabled ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) async {
                setState(() {
                  _notificationsEnabled = value;
                });
                await saveNotificationEnabled(value); // Firestore 저장
              },
            ),
            onTap: () => _pickTime(context),
          ),
          const Divider(),

          // 로그아웃
          ListTile(
            title: const Text('로그아웃'),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          // 회원탈퇴
          ListTile(
            title: const Text('회원탈퇴'),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('회원탈퇴'),
                  content: const Text('정말 계정을 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
