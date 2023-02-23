class CategoryModel {
  String? titleAr;
  String? titleEn;
  String? idCategory;
  String? date;

  CategoryModel({
    this.titleAr,
    this.titleEn,
    this.idCategory,
    this.date,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    titleAr = json['titleCategoryAr'];
    titleEn = json['titleCategoryEn'];
    idCategory = json['idCategory'];
    date = json['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'titleCategoryAr': titleAr,
      'titleCategoryEn': titleEn,
      'idCategory': idCategory,
      'date': date,
    };
  }
}
