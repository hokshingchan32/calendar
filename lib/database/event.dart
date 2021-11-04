import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'event.g.dart';

LazyDatabase _openConncection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get isAllDay => boolean().withDefault(const Constant(false))();
  DateTimeColumn get eventStart => dateTime()();
  DateTimeColumn get eventEnd => dateTime()();
}

@UseMoor(tables: [Events])
class EventDatabase extends _$EventDatabase {
  EventDatabase() : super(_openConncection());

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [Events])
class EventDao extends DatabaseAccessor<EventDatabase> with _$EventDaoMixin {
  EventDao(EventDatabase db) : super(db);

  Future<List<Event>> getAllEvents() => select(events).get();

  Stream<List<Event>> watchAllEvents() => select(events).watch();

  Stream<List<Event>> watchDayEvents(DateTime dateTime) {
    return (select(events)
          ..where((e) =>
              (e.eventStart.isSmallerOrEqual(Variable(
                    dateTime,
                  )) &
                  e.eventEnd.isBiggerOrEqual(Variable(
                    dateTime,
                  ))) |
              e.eventStart.isBetweenValues(
                DateTime(dateTime.year, dateTime.month, dateTime.day),
                DateTime(
                    dateTime.year, dateTime.month, dateTime.day, 23, 59, 59),
              ) | e.eventEnd.isBetweenValues(
                DateTime(dateTime.year, dateTime.month, dateTime.day),
                DateTime(
                    dateTime.year, dateTime.month, dateTime.day, 23, 59, 59),
              )))
        .watch();
  }

  Future insertEvent(EventsCompanion event) => into(events).insert(event);

  Future updateEvent(Event event) => update(events).replace(event);

  Future deleteEvent(Event event) => delete(events).delete(event);
}
