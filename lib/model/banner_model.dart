class BannerModel {
  String? image;

  BannerModel({
    this.image,
  });

  BannerModel.fromJson(Map<String, dynamic> json) {
    image = json['bannerImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'bannerImage': image,
    };
  }
}
