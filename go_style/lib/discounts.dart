class Discount {
  final String code;
  final DateTime date;
  final String value;

  Discount(this.code, this.date, this.value) {
    if (code == null) {
      throw ArgumentError("login of Member cannot be null. "
          "Received: '$code'");
    }
    if (date == null) {
      throw ArgumentError("avatarUrl of Member cannot be null. "
          "Received: '$date'");
    }
    if (value == null) {
      throw ArgumentError("avatarUrl of Member cannot be null. "
          "Received: '$value'");
    }
  }
}
