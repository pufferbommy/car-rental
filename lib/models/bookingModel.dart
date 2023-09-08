class Booking {
  String? bID;
  String? uID;
  String? cID;
  String? uDateFrom;
  String? uDateTo;
  String? uTelephone;
  String? uPassword;
  String? uName;
  String? cName;
  String? cBrand;
  String? cType;
  String? cPassengers;
  String? cImage;
  String? cPrice;

  Booking(
      {this.bID,
      this.uID,
      this.cID,
      this.uDateFrom,
      this.uDateTo,
      this.uTelephone,
      this.uPassword,
      this.uName,
      this.cName,
      this.cBrand,
      this.cType,
      this.cPassengers,
      this.cImage,
      this.cPrice});

  Booking.fromJson(Map<String, dynamic> json) {
    bID = json['bID'];
    uID = json['uID'];
    cID = json['cID'];
    uDateFrom = json['uDateFrom'];
    uDateTo = json['uDateTo'];
    uTelephone = json['uTelephone'];
    uPassword = json['uPassword'];
    uName = json['uName'];
    cName = json['cName'];
    cBrand = json['cBrand'];
    cType = json['cType'];
    cPassengers = json['cPassengers'];
    cImage = json['cImage'];
    cPrice = json['cPrice'];
  }
}
