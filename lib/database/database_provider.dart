import 'package:flutter_calendar/database/event.dart';

class DatabaseProvider {
  final EventDao _eventDao;

  EventDao get eventDao => _eventDao;

  DatabaseProvider() : _eventDao = EventDao(EventDatabase());
}
