import 'package:intl/intl.dart';

class FormattedTime {
  String time;
  DateTime _lastModified;
  DateFormat _dateFormatter = DateFormat.yMMMMEEEEd().add_jm();
  String _formattedDate;

  FormattedTime({this.time});

  String getFormattedTime() {
    //print(time);
    _lastModified = DateTime.parse(time);
    _formattedDate = _dateFormatter.format(_lastModified);
    //print(_formattedDate);
    return _formattedDate;
  }


}