import 'package:flutter/material.dart';
import 'package:flutter_calendar/database/database_provider.dart';
import 'package:flutter_calendar/view/calendar/calendar_container.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('jp_JP');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final databaseProvider = Provider((ref) {
  return DatabaseProvider();
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('カレンダー'),
        ),
        body: const CalendarView(),
      ),
    );
  }
}
