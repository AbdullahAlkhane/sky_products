class ServicesModel {
  String? titleServicesAr;
  String? titleServicesEn;
  String? imageServices;
  String? urlServices;
  String? date;
  String? idCategory;

  ServicesModel({
    this.titleServicesEn,
    this.titleServicesAr,
    this.idCategory,
    this.imageServices,
    this.date,
    this.urlServices,
  });

  ServicesModel.fromJson(Map<String, dynamic> json) {
    titleServicesAr = json['titleServicesAr'];
    titleServicesEn = json['titleServicesEn'];
    idCategory = json['idCategory'];
    imageServices = json['imageServices'];
    date = json['date'];
    urlServices = json['urlServices'];
  }

  Map<String, dynamic> toMap() {
    return {
      'titleServicesAr': titleServicesAr,
      'titleServicesEn': titleServicesEn,
      'idCategory': idCategory,
      'imageServices': imageServices,
      'date': date,
      'urlServices': urlServices,
    };
  }
}
