class VehiclePlates {
  int idPlat;
  String plat;

  VehiclePlates({
    required this.idPlat,
    required this.plat,
  });

  factory VehiclePlates.fromJson(Map<String, dynamic> json) {
    return VehiclePlates(
      idPlat: json['idPlat'],
      plat: json['plat'],
    );
  }
}
