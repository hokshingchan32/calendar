import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moor/moor.dart' as moor;
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_calendar/database/event.dart';
import 'package:flutter_calendar/main.dart';
import 'package:flutter_calendar/model/event_detail_mode.dart';
import 'package:flutter_calendar/model/picker_type.dart';
import 'package:flutter_calendar/util/constant.dart';
import 'package:flutter_calendar/util/util.dart';

const kYYYYMMDDHHSS = 'yyyy-MM-dd HH:mm';
const kYYYYMMDD = 'yyyy-MM-dd';

class EventDetailArguments {
  final EventDetailMode mode;
  final DateTime date;
  final Event? event;

  EventDetailArguments({
    required this.mode,
    required this.date,
    this.event,
  });
}

class EventAddValidation extends ChangeNotifier {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  bool _didEdited = false;
  bool _isValid = false;
  bool _isAllDay = false;

  bool get didEdited => _didEdited;
  bool get isValid => _isValid;
  bool get isAllDay => _isAllDay;

  changeAllDay(bool isOn) {
    _isAllDay = isOn;
    notifyListeners();
  }

  changeDidEdit(bool v) {
    _didEdited = v;
    notifyListeners();
  }

  checkValid() {
    if (titleEditingController.text.isNotEmpty &&
        descriptionEditingController.text.isNotEmpty &&
        didEdited) {
      _isValid = true;
    } else {
      _isValid = false;
    }
    notifyListeners();
  }

  reset() {
    _didEdited = false;
    _isValid = false;
    _isAllDay = false;
    titleEditingController.clear();
    descriptionEditingController.clear();
  }
}

final validationProvider = ChangeNotifierProvider((ref) {
  return EventAddValidation();
});

class EventDetail extends StatefulWidget {
  const EventDetail({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final EventDetailArguments arguments;

  static Route<dynamic> route(EventDetailArguments arguments) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => EventDetail(arguments: arguments),
    );
  }

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Event? event;

  DateTime eventStart = DateTime.now();
  DateTime eventEnd = DateTime.now().add(
    const Duration(hours: 1),
  );

  static const _dateTextStyle = TextStyle(fontSize: 18);

  @override
  void initState() {
    super.initState();

    event = widget.arguments.event;
    eventStart = event?.eventStart ?? widget.arguments.date;
    eventEnd =
        event?.eventEnd ?? widget.arguments.date.add(const Duration(hours: 1));

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read(validationProvider).titleEditingController.text =
          event?.title ?? '';
      context.read(validationProvider).descriptionEditingController.text =
          event?.description ?? '';
      context.read(validationProvider).changeAllDay(event?.isAllDay ?? false);
    });
  }

  _changeEventStart() {
    final isAllDay = context.read(validationProvider).isAllDay;
    _selectDate(
      context,
      eventStart,
      isAllDay ? PickerType.date : PickerType.dateAndTime,
      (date) {
        setState(() {
          eventStart = date;

          // 終了時間を変更
          if (isAllDay) {
            eventEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
          } else {
            eventEnd = eventStart.add(const Duration(hours: 1));
          }
        });
        _checkValid();
      },
    );
  }

  _changeEventEnd() {
    final isAllDay = context.read(validationProvider).isAllDay;
    _selectDate(
        context, eventEnd, isAllDay ? PickerType.date : PickerType.dateAndTime,
        (date) {
      setState(() {
        if (date.compareTo(eventStart) > 0) {
          eventEnd = date;
        } else {
          print('終了時間が開始時間より前の場合。。。');
        }
      });
      _checkValid();
    });
  }

  _checkValid() {
    context.read(validationProvider).changeDidEdit(true);
    context.read(validationProvider).checkValid();
  }

  _selectDate(
    BuildContext context,
    DateTime dateTime,
    PickerType type,
    Function(DateTime) onSelected,
  ) async {
    Picker(
      adapter: DateTimePickerAdapter(
        value: dateTime,
        type: type == PickerType.date
            ? PickerDateTimeType.kYMD
            : PickerDateTimeType.kYMDHM,
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
        onSelected(selectedDateTime);
      },
    ).showModal(context);
  }

  _handleSwitch(bool isOn) {
    context.read(validationProvider).changeAllDay(isOn);
    if (isOn) {
      eventStart = DateTime(eventStart.year, eventStart.month, eventStart.day);
      eventEnd = eventStart.add(const Duration(days: 1, minutes: -1));
    } else {
      final now = DateTime.now();
      eventStart = Util.roundWithFifteen(
        DateTime(eventStart.year, eventStart.month, eventStart.day, now.hour,
            now.minute),
      );
      eventEnd = eventStart.add(const Duration(hours: 1));
    }
    _checkValid();
  }

  _back() {
    context.read(validationProvider).reset();
    Navigator.of(context).pop();
  }

  _showDiscardConfirmActionSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text('編集を破棄'),
              onPressed: () {
                context.read(validationProvider).reset();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
          cancelButton: CupertinoButton(
            child: const Text('キャンセル'),
            onPressed: () => _back(),
          ),
        );
      },
    );
  }

  _showDeleteConfirmDialog(EventDao eventDao) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('予定の削除'),
          content: const Text('本当にこの日の予定を削除しますか？'),
          actions: [
            CupertinoDialogAction(
              child: const Text('キャンセル'),
              onPressed: () => _back(),
            ),
            CupertinoDialogAction(
              child: const Text('削除'),
              onPressed: () => _deleteEvent(eventDao),
            ),
          ],
        );
      },
    );
  }

  _onCloseButtonPressed() {
    if (context.read(validationProvider).didEdited) {
      _showDiscardConfirmActionSheet();
    } else {
      _back();
    }
  }

  _saveEvent(EventDao eventDao) {
    if (!context.read(validationProvider).isValid) {
      return;
    }
    final title = context.read(validationProvider).titleEditingController.text;
    final description =
        context.read(validationProvider).descriptionEditingController.text;
    final isAllDay = context.read(validationProvider).isAllDay;

    if (event == null) {
      final newEvent = EventsCompanion(
        title: moor.Value(title),
        description: moor.Value(description),
        isAllDay: moor.Value(isAllDay),
        eventStart: moor.Value(eventStart),
        eventEnd: moor.Value(eventEnd),
      );
      eventDao
          .insertEvent(newEvent)
          .then((_) => _back())
          .onError((error, stackTrace) => print('ERROR: $error\n$stackTrace'));
    } else {
      final newEvent = Event(
        id: event!.id,
        title: title,
        description: description,
        isAllDay: isAllDay,
        eventStart: eventStart,
        eventEnd: eventEnd,
      );
      eventDao
          .updateEvent(newEvent)
          .then((_) => _back())
          .onError((error, stackTrace) => print('ERROR: $error\n$stackTrace'));
    }
  }

  _deleteEvent(EventDao eventDao) {
    if (event == null) {
      return;
    }
    eventDao
        .deleteEvent(event!)
        .then((_) => Navigator.of(context).popUntil((route) => route.isFirst));
  }

  _createInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: InputBorder.none,
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final eventDao = watch(databaseProvider).eventDao;
      final isAllDay = watch(validationProvider).isAllDay;
      return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.arguments.mode == EventDetailMode.add ? '予定追加' : '予定編集'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onCloseButtonPressed,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      watch(validationProvider).isValid
                          ? Colors.white
                          : Colors.grey),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  _saveEvent(eventDao);
                },
                child: Text(
                    widget.arguments.mode == EventDetailMode.add ? '追加' : '保存'),
              ),
            ),
          ],
        ),
        body: Container(
          color: Constant.backgroundColor,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      TextFormField(
                        controller: context
                            .read(validationProvider)
                            .titleEditingController,
                        decoration: _createInputDecoration('タイトルを入力してください'),
                        onChanged: (_) => _checkValid(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Text('終日'),
                                trailing: Switch(
                                  value: isAllDay,
                                  onChanged: _handleSwitch,
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Text('開始'),
                                trailing: Text(
                                  Util.getFormattedDateTimeString(eventStart,
                                      isAllDay ? kYYYYMMDD : kYYYYMMDDHHSS),
                                  style: _dateTextStyle,
                                ),
                                onTap: _changeEventStart,
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Text('終了'),
                                trailing: Text(
                                  Util.getFormattedDateTimeString(eventEnd,
                                      isAllDay ? kYYYYMMDD : kYYYYMMDDHHSS),
                                  style: _dateTextStyle,
                                ),
                                onTap: _changeEventEnd,
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: context
                            .read(validationProvider)
                            .descriptionEditingController,
                        maxLines: 5,
                        decoration: _createInputDecoration('コメントを入力してください'),
                        onChanged: (_) => _checkValid(),
                      ),
                      if (widget.arguments.mode == EventDetailMode.edit) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Container(
                                color: Colors.white,
                                child: const Center(
                                  child: Text(
                                    'この予定を削除',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () => _showDeleteConfirmDialog(eventDao),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
