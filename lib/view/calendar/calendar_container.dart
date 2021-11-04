import 'package:flutter/material.dart';
import 'package:flutter_calendar/main.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flutter_calendar/database/event.dart';
import 'package:flutter_calendar/util/constant.dart';
import 'package:flutter_calendar/util/util.dart';
import 'package:flutter_calendar/view/calendar/calendar_carousel.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _showEvents = false;

  _showMonthPicker() {
    Picker(
      adapter: DateTimePickerAdapter(
        value: _focusedDay,
        type: PickerDateTimeType.kYM,
        isNumberMonth: true,
        yearSuffix: "年",
        monthSuffix: "月",
        daySuffix: "日",
        hourSuffix: "時",
        minuteSuffix: "分",
        secondSuffix: "秒",
        minValue: Constant.minTime,
        minuteInterval: 15,
      ),
      height: 300,
      textAlign: TextAlign.right,
      selectedTextStyle: const TextStyle(color: Colors.blue),
      cancelText: 'キャンセル',
      confirmText: '完了',
      onConfirm: (Picker picker, List value) {
        // TODO: 何故か最初に設定した日付のママで完了させた場合のみ、最後にzがついている
        final string = picker.adapter.text.replaceAll('Z', '');
        final selectedDateTime =
            Util.getDateTimeFromString(string, 'yyyy-MM-dd HH:mm:ss.SSS');
        setState(() {
          _focusedDay = selectedDateTime;
        });
      },
    ).showModal(context);
  }

  Widget _buildCalendarDay({
    required String day,
    Color? backColor,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backColor,
        shape: BoxShape.circle,
      ),
      width: 50,
      height: 50,
      child: Center(
        child: Text(
          day,
          style: TextStyle(fontSize: 20, color: color ?? Colors.black),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
              child: OutlinedButton(
                child: const Text('今日'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  shape: const StadiumBorder(),
                  side: const BorderSide(),
                ),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime.now();
                    _selectedDay = null;
                  });
                },
              ),
            ),
          ),
          const Spacer(flex: 1),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(fontSize: 20)),
            ),
            onPressed: () => _showMonthPicker(),
            child: Row(
              children: [
                Text(Util.getFormattedDateTimeString(_focusedDay, 'yyyy年MM月')),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Consumer(builder: (context, watch, _) {
      final eventDao = watch(databaseProvider).eventDao;
      return StreamBuilder<List<Event>>(
          stream: eventDao.watchAllEvents(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final events = snapshot.data;

            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TableCalendar(
                  rowHeight: 60,
                  locale: 'ja_JP',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  focusedDay: _focusedDay,
                  firstDay: Constant.minTime,
                  lastDay: Constant.maxTime,
                  daysOfWeekVisible: false,
                  eventLoader: (day) {
                    if (events == null) {
                      return [];
                    }
                    return events
                        .toList()
                        .where(
                          (element) =>
                              // 日をまたぐ場合も考慮
                              isSameDay(element.eventStart, day) ||
                              isSameDay(element.eventEnd, day) ||
                              (day.isAfter(element.eventStart) &&
                                  day.isBefore(element.eventEnd)),
                        )
                        .toList();
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _showEvents = true;
                    });
                  },
                  daysOfWeekHeight: 40,
                  calendarBuilders: CalendarBuilders(
                    headerTitleBuilder: (context, day) {},
                    todayBuilder: (context, day, focusedDay) {
                      return _buildCalendarDay(
                        day: day.day.toString(),
                        color: Colors.white,
                        backColor: Colors.blue,
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      return _buildCalendarDay(
                        day: day.day.toString(),
                        color: day.weekday == 6
                            ? Colors.blue
                            : day.weekday == 7
                                ? Colors.red
                                : Colors.black,
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return _buildCalendarDay(
                        day: day.day.toString(),
                        color: Colors.white,
                        backColor: Colors.pink,
                      );
                    },
                  ),
                ),
              ),
            );
          });
    });
  }

  Widget _buildDaysOfWeek() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: const [
          Expanded(flex: 1, child: Center(child: Text('月'))),
          Expanded(flex: 1, child: Center(child: Text('火'))),
          Expanded(flex: 1, child: Center(child: Text('水'))),
          Expanded(flex: 1, child: Center(child: Text('木'))),
          Expanded(flex: 1, child: Center(child: Text('金'))),
          Expanded(
            flex: 1,
            child:
                Center(child: Text('土', style: TextStyle(color: Colors.blue))),
          ),
          Expanded(
            flex: 1,
            child:
                Center(child: Text('日', style: TextStyle(color: Colors.red))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Constant.backgroundColor,
        ),
        Column(
          children: [
            _buildHeader(),
            _buildDaysOfWeek(),
            _buildCalendar(),
          ],
        ),
        Visibility(
          visible: _showEvents,
          child: CalendarCarousel(
            initialDay: _selectedDay ?? DateTime.now(),
            onBackgroundTap: () {
              setState(() {
                _showEvents = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
