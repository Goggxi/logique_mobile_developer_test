import 'package:intl/intl.dart';

extension ExtDateFormat on DateTime {
  String toDDMMMYYYYHH({String? lang}) {
    return DateFormat("dd MMMM yyyy HH:mm", lang ?? "id").format(this);
  }

  String toDDMMMYYYY({String? lang}) {
    return DateFormat("dd MMMM yyyy", lang ?? "id").format(this);
  }
}
