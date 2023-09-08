class Catalog {
  final String cID;
  final String cName;
  final String cBrand;
  final String cType;
  final String cPassengers;
  final String cImage;
  final String cPrice;

  Catalog(
    this.cID,
    this.cName,
    this.cBrand,
    this.cType,
    this.cPassengers,
    this.cImage,
    this.cPrice,
  );

  Catalog.fromJson(Map<String, dynamic> json)
      : cID = json['cID'],
        cName = json['cName'],
        cBrand = json['cBrand'],
        cType = json['cType'],
        cPassengers = json['cPassengers'],
        cImage = json['cImage'],
        cPrice = json['cPrice'];
}
