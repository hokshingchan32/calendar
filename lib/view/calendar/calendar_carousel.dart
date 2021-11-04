import 'package:flutter/material.dart';
import 'package:flutter_calendar/database/event.dart';
import 'package:flutter_calendar/main.dart';
import 'package:flutter_calendar/model/event_detail_mode.dart';
import 'package:flutter_calendar/util/util.dart';
import 'package:flutter_calendar/view/calendar/event_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

enum _Direction {
  forward,
  backward,
}

class CalendarCarousel extends StatefulWidget {
  const CalendarCarousel({
    Key? key,
    required this.initialDay,
    this.onBackgroundTap,
  }) : super(key: key);

  final DateTime initialDay;
  final VoidCallback? onBackgroundTap;

  @override
  State<CalendarCarousel> createState() => _CalendarCarouselState();
}

class _CalendarCarouselState extends State<CalendarCarousel> {
  late DateTime currentDateTime;
  late List<DateTime> dateTimeList;

  static const _kHalfSideCardCount = 10;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    currentDateTime = widget.initialDay;
    dateTimeList = _createDateListFromDelta(
        currentDateTime, _kHalfSideCardCount, _Direction.backward)
      ..add(currentDateTime)
      ..addAll(_createDateListFromDelta(
          currentDateTime, _kHalfSideCardCount, _Direction.forward));
    _pageController = PageController(
      initialPage: _kHalfSideCardCount,
      viewportFraction: 0.9,
    );
  }

  _navigateToDetail(DateTime date) {
    final now = DateTime.now();
    Navigator.of(context).push<dynamic>(
      EventDetail.route(
        EventDetailArguments(
          date: Util.roundWithFifteen(
              DateTime(date.year, date.month, date.day, now.hour, now.minute)),
          mode: EventDetailMode.add,
        ),
      ),
    );
  }

  List<DateTime> _createDateListFromDelta(
    DateTime dateTime,
    int days,
    _Direction direction,
  ) {
    final list = List.generate(
      days,
      (index) => dateTime.add(
        Duration(
            days: direction == _Direction.backward ? index - days : index + 1),
      ),
    );

    return list;
  }

  Widget _buildItem(DateTime date) {
    return Consumer(
      builder: (context, watch, child) {
        final eventDao = watch(databaseProvider).eventDao;
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ),
            child: Column(
              children: [
                _buildHeader(date),
                StreamBuilder<List<Event>>(
                  stream: eventDao.watchDayEvents(date),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _buildEmptyWidget();
                    }

                    final tEvents = snapshot.data ?? [];

                    return _buildScheduleBody(date, tEvents);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(DateTime date) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: Util.getFormattedDateTimeString(date, 'yyyy/MM/dd('),
                ),
                TextSpan(
                    text: Util.getFormattedDateTimeString(date, 'E'),
                    style: TextStyle(
                      color: (date.weekday == 6 || date.weekday == 7)
                          ? Colors.red
                          : Colors.black,
                    )),
                const TextSpan(
                  text: ')',
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => _navigateToDetail(date),
          icon: const Icon(
            Icons.add,
            color: Colors.blue,
            size: 30,
          ),
        )
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return PageView.builder(
              itemCount: dateTimeList.length,
              controller: _pageController,
              onPageChanged: (index) {
                if (index == 0) {
                  dateTimeList = _createDateListFromDelta(
                      dateTimeList[0], 10, _Direction.backward)
                    ..addAll(dateTimeList);
                  _pageController.jumpToPage(index + _kHalfSideCardCount);
                } else if (index == dateTimeList.length - 1) {
                  dateTimeList = dateTimeList
                    ..addAll(
                      _createDateListFromDelta(
                        dateTimeList.last,
                        _kHalfSideCardCount,
                        _Direction.forward,
                      ),
                    );
                }
                setState(() {});
              },
              itemBuilder: (context, currentIndex) {
                return _buildItem(
                  dateTimeList[currentIndex],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildScheduleBody(DateTime date, List<Event> events) {
    if (events.isEmpty) {
      return _buildEmptyWidget();
    }
    return Expanded(
      child: ListView.separated(
        itemCount: events.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return _buildScheduleCell(date, events[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
          );
        },
      ),
    );
  }

  Widget _buildScheduleCell(DateTime date, Event event) {

    const tSameDayTimeTS = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    const tOtherDayTimeTS = TextStyle(fontSize: 12);

    final tDividerColor = isSameDay(event.eventStart, event.eventEnd) ? Colors.blue : Colors.pink;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push<dynamic>(
            EventDetail.route(EventDetailArguments(
                date: date, mode: EventDetailMode.edit, event: event)),
          );
        },
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (event.isAllDay) ...[
                      const Text('終日')
                    ] else ...[
                      Text(
                        Util.getFormattedDateTimeString(
                            event.eventStart, 'HH:mm'),
                        style: isSameDay(date, event.eventStart) ? tSameDayTimeTS : tOtherDayTimeTS,
                      ),
                      Text(
                        Util.getFormattedDateTimeString(
                            event.eventEnd, 'HH:mm'),
                        style: isSameDay(date, event.eventEnd) ? tSameDayTimeTS : tOtherDayTimeTS,
                      ),
                    ]
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 2,
                  color: tDividerColor,
                ),
              ),
              Expanded(
                child: Text(
                  event.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return GestureDetector(
      onTap: () {
        if (widget.onBackgroundTap != null) {
          widget.onBackgroundTap!();
        }
      },
      child: Container(
        color: Colors.black.withOpacity(0.3),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Expanded(child: Center(child: Text('予定がありません')));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildBackground(),
        _buildContent(context),
      ],
    );
  }
}
