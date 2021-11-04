// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String title;
  final String description;
  final bool isAllDay;
  final DateTime eventStart;
  final DateTime eventEnd;
  Event(
      {required this.id,
      required this.title,
      required this.description,
      required this.isAllDay,
      required this.eventStart,
      required this.eventEnd});
  factory Event.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Event(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
      isAllDay: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_all_day'])!,
      eventStart: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}event_start'])!,
      eventEnd: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}event_end'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['is_all_day'] = Variable<bool>(isAllDay);
    map['event_start'] = Variable<DateTime>(eventStart);
    map['event_end'] = Variable<DateTime>(eventEnd);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      isAllDay: Value(isAllDay),
      eventStart: Value(eventStart),
      eventEnd: Value(eventEnd),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      eventStart: serializer.fromJson<DateTime>(json['eventStart']),
      eventEnd: serializer.fromJson<DateTime>(json['eventEnd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'eventStart': serializer.toJson<DateTime>(eventStart),
      'eventEnd': serializer.toJson<DateTime>(eventEnd),
    };
  }

  Event copyWith(
          {int? id,
          String? title,
          String? description,
          bool? isAllDay,
          DateTime? eventStart,
          DateTime? eventEnd}) =>
      Event(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isAllDay: isAllDay ?? this.isAllDay,
        eventStart: eventStart ?? this.eventStart,
        eventEnd: eventEnd ?? this.eventEnd,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('eventStart: $eventStart, ')
          ..write('eventEnd: $eventEnd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, isAllDay, eventStart, eventEnd);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.isAllDay == this.isAllDay &&
          other.eventStart == this.eventStart &&
          other.eventEnd == this.eventEnd);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<bool> isAllDay;
  final Value<DateTime> eventStart;
  final Value<DateTime> eventEnd;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.eventStart = const Value.absent(),
    this.eventEnd = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    this.isAllDay = const Value.absent(),
    required DateTime eventStart,
    required DateTime eventEnd,
  })  : title = Value(title),
        description = Value(description),
        eventStart = Value(eventStart),
        eventEnd = Value(eventEnd);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? isAllDay,
    Expression<DateTime>? eventStart,
    Expression<DateTime>? eventEnd,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (eventStart != null) 'event_start': eventStart,
      if (eventEnd != null) 'event_end': eventEnd,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? description,
      Value<bool>? isAllDay,
      Value<DateTime>? eventStart,
      Value<DateTime>? eventEnd}) {
    return EventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isAllDay: isAllDay ?? this.isAllDay,
      eventStart: eventStart ?? this.eventStart,
      eventEnd: eventEnd ?? this.eventEnd,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (eventStart.present) {
      map['event_start'] = Variable<DateTime>(eventStart.value);
    }
    if (eventEnd.present) {
      map['event_end'] = Variable<DateTime>(eventEnd.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('eventStart: $eventStart, ')
          ..write('eventEnd: $eventEnd')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EventsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _isAllDayMeta = const VerificationMeta('isAllDay');
  late final GeneratedColumn<bool?> isAllDay = GeneratedColumn<bool?>(
      'is_all_day', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_all_day IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _eventStartMeta = const VerificationMeta('eventStart');
  late final GeneratedColumn<DateTime?> eventStart = GeneratedColumn<DateTime?>(
      'event_start', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _eventEndMeta = const VerificationMeta('eventEnd');
  late final GeneratedColumn<DateTime?> eventEnd = GeneratedColumn<DateTime?>(
      'event_end', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, isAllDay, eventStart, eventEnd];
  @override
  String get aliasedName => _alias ?? 'events';
  @override
  String get actualTableName => 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_all_day')) {
      context.handle(_isAllDayMeta,
          isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta));
    }
    if (data.containsKey('event_start')) {
      context.handle(
          _eventStartMeta,
          eventStart.isAcceptableOrUnknown(
              data['event_start']!, _eventStartMeta));
    } else if (isInserting) {
      context.missing(_eventStartMeta);
    }
    if (data.containsKey('event_end')) {
      context.handle(_eventEndMeta,
          eventEnd.isAcceptableOrUnknown(data['event_end']!, _eventEndMeta));
    } else if (isInserting) {
      context.missing(_eventEndMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Event.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(_db, alias);
  }
}

abstract class _$EventDatabase extends GeneratedDatabase {
  _$EventDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $EventsTable events = $EventsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$EventDaoMixin on DatabaseAccessor<EventDatabase> {
  $EventsTable get events => attachedDatabase.events;
}
