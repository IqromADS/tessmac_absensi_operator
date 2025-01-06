class History {
  final String? checkinDate;
  final String? checkoutDate;
  final String? checkinLocation;
  final String? checkoutLocation;
  final String? day;

  History({
    this.checkinDate,
    this.checkoutDate,
    this.checkinLocation,
    this.checkoutLocation,
    this.day,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      checkinDate: json['checkindate'] as String?,
      checkoutDate: json['checkoutdate'] as String?,
      checkinLocation: json['checkinLocation'] as String?,
      checkoutLocation: json['checkoutLocation'] as String?,
      day: json['hari'] as String?,
    );
  }
}
