class Selection {
  DateTime? start;
  DateTime? end;
  DateTime currentMonth = DateTime.now();
  bool isMultiple = false;

  Selection({DateTime? month, this.start, this.end, this.isMultiple = false}) {
    if (month != null) {
      currentMonth = month;
    }
  }

  Selection changeMonth(DateTime dateTime) {
    Selection selection = Selection();
    selection.start = start;
    selection.end = end;
    selection.isMultiple = isMultiple;
    selection.currentMonth = dateTime;
    return selection;
  }

  Selection clicked(DateTime dateTime) {
    Selection selection = Selection();
    if (isMultiple) {
      if (start != null && end != null) {
        selection.start = dateTime;
      } else if (start == null) {
        selection.start = dateTime;
      } else {
        final t = start!.compareTo(dateTime);
        if (t > 0) {
          final temp = start;
          selection.start = dateTime;
          selection.end = temp;
        } else {
          selection.start = start;
          selection.end = dateTime;
        }
      }
    } else {
      selection.start = dateTime;
      selection.end = dateTime;
    }
    selection.isMultiple = isMultiple;
    selection.currentMonth = currentMonth;
    return selection;
  }
}

class Date {
  DateTime day;
  bool isSelected = false;
  bool isCurrentMonth = false;

  Date(this.day, {this.isCurrentMonth = false, this.isSelected = false});
}

typedef SelectionChange = Function(Selection value);

extension DateTimeOperation on DateTime {
  bool isSameDay(DateTime other) {
    return (day == other.day && month == other.month && year == other.year);
  }

  bool between(DateTime d1, DateTime d2) {
    return isFutureDay(d1) && isPastDay(d2);
  }

  bool isFutureDay(DateTime d) {
    return (year > d.year ||
        (year == d.year && month > d.month) ||
        (year == d.year && month == d.month && day >= d.day));
  }

  bool isPastDay(DateTime d) {
    return (year < d.year ||
        (year == d.year && month < d.month) ||
        (year == d.year && month == d.month && day <= d.day));
  }
}
