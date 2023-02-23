import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/model/banner_model.dart';
import 'package:sky_products/model/category_model.dart';
import 'package:sky_products/model/services_model.dart';
import 'package:sky_products/remote/cach_helper.dart';
import 'package:sky_products/shared/admin_cubit/states.dart';

class AdminCubit extends Cubit<AdminStets> {
  AdminCubit() : super(InitialState());

  static AdminCubit get(context) => BlocProvider.of(context);
  IconData iconData = Icons.visibility_outlined;

  bool isoscureShow = true;

  void eyeisShow() {
    iconData = isoscureShow
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    isoscureShow = !isoscureShow;
    emit(ShowPassword());
  }

  void adminLogin({
    required String email,
    required String password,
  }) {
    emit(AdminLoginAdminLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(AdminLoginAdminSuccessState(uid: value.user!.uid));
      CachHelper.saveDataa(key: 'uId', value: value.user!.uid).then((value) {
        uId = CachHelper.getData('uId');
      });
    }).catchError(
      (error) {
        emit(AdminLoginAdminErrorState());
      },
    );
  }

//******************** Add Banner ********************//
  File? bannerImage;

  final picker = ImagePicker();

  Future getBannerImage() async {
    final pikedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pikedFile != null) {
      bannerImage = File(pikedFile.path);
      emit(AdminCubitImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(AdminCubitImagePickedErrorState());
    }
  }

  String bannerImageUrl = '';

  void uploadBannerImage() {
    emit(AdminCubitUploadBannerImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'banner/${Uri.file(bannerImage!.path).pathSegments.last}',
        )
        .putFile(bannerImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        bannerImageUrl = value;
        emit(AdminCubitUploadBannerImageSuccessState());
        print(value);
      }).catchError((error) {
        emit(AdminCubitUploadBannerImageErrorState());
        print(error.toString());
        print('error 1');
      });
    }).catchError((error) {
      emit(AdminCubitUploadBannerImageErrorState());
      print(error.toString());
    });
  }

  void addBanner({
    required String image,
  }) {
    emit(AdminCubitAddBannerLoadingState());
    FirebaseFirestore.instance.collection('banner').add({
      'bannerImage': image,
    }).then(
      (value) {
        emit(AdminCubitAddBannerSuccessState());
        getBannerData();
      },
    ).catchError(
      (error) {
        emit(AdminCubitAddBannerErrorState());
      },
    );
  }

  List<BannerModel> bannerModel = [];
  List<String> idBannerModel = [];

  void getBannerData() {
    bannerModel = [];
    idBannerModel = [];
    emit(AdminCubitGetBannerLoadingState());
    FirebaseFirestore.instance.collection('banner').get().then((value) {
      value.docs.forEach((element) {
        bannerModel.add(BannerModel.fromJson(element.data()));
        idBannerModel.add(element.id);
      });
      emit(AdminCubitGetBannerSuccessState());
    }).catchError(
      (error) {
        print(error.toString());
        emit(AdminCubitGetBannerErrorState());
      },
    );
  }

  void deleteBanner({
    required String uIdBanner,
    required String urlBanner,
    required context,
  }) {
    FirebaseStorage.instance.refFromURL(urlBanner).delete().then((value) {
      print('done');
    }).catchError((error) {
      print(error);
    });
    print(uIdBanner);
    emit(AdminCubitDeleteBannerLoadingState());
    FirebaseFirestore.instance
        .collection('banner')
        .doc(uIdBanner)
        .delete()
        .then((value) {
      emit(AdminCubitDeleteBannerSuccessState());
      Navigator.pop(context);
      getBannerData();
    }).catchError((error) {
      emit(AdminCubitDeleteBannerErrorState());
    });
  }

  //************************Category******************//

  void addCategory({
    required String titleAr,
    required String titleEn,
    required String date,
  }) async{
     CollectionReference ref =
     await FirebaseFirestore.instance.collection('category');
    String docId=ref.doc().id;

    CategoryModel model = CategoryModel(titleAr: titleAr, titleEn: titleEn,idCategory: docId,date:date);
    emit(AdminCubitAddCategoryLoadingState());
    ref.doc(docId).set(model.toMap()).then(
      (value) {
        emit(AdminCubitAddCategorySuccessState());
        getCategoryData();
      },
    ).catchError(
      (error) {
        emit(AdminCubitAddCategoryErrorState());
      },
    );
  }

  List<CategoryModel> categoryModel = [];
  List<String> idCategoryModel = [];

  void getCategoryData() {
    categoryModel = [];
    idCategoryModel = [];
    emit(AdminCubitGetCategoryLoadingState());
    FirebaseFirestore.instance.collection('category').orderBy('date',descending: true).get().then((value) {
      value.docs.forEach((element) {
        categoryModel.add(CategoryModel.fromJson(element.data()));
        idCategoryModel.add(element.id);
      });
      emit(AdminCubitGetCategorySuccessState());
    }).catchError(
      (error) {
        print(error.toString());
        emit(AdminCubitGetCategoryErrorState());
      },
    );
  }

  void deleteCategory({
    required String uIdCategory,
    required context,
  }) {
    print(uIdCategory);
    emit(AdminCubitDeleteCategoryLoadingState());
    FirebaseFirestore.instance
        .collection('category')
        .doc(uIdCategory)
        .delete()
        .then((value) {
      emit(AdminCubitDeleteCategorySuccessState());
      Navigator.pop(context);
      getCategoryData();
    }).catchError((error) {
      emit(AdminCubitDeleteCategoryErrorState());
    });
  }

  void editCategory({
    required String titleAr,
    required String titleEn,
    required String idCategory,
    required String date,
    context,
  }) {
    CategoryModel model = CategoryModel(titleAr: titleAr, titleEn: titleEn,idCategory: idCategory,date: date);
    emit(AdminCubitEditCategoryLoadingState());
    FirebaseFirestore.instance
        .collection('category')
        .doc(idCategory)
        .update(model.toMap())
        .then(
      (value) {
        emit(AdminCubitEditCategorySuccessState());
        Navigator.pop(context);
        getCategoryData();
      },
    ).catchError(
      (error) {
        emit(AdminCubitEditCategoryErrorState());
      },
    );
  }

  //************************ Services ******************//

  File? servicesImage;

  final pickerImageServices = ImagePicker();

  List<ServicesModel> servicesModel = [];
  List<String> idServicesModel = [];

  Future getServicesImage() async {

    final pikedFile = await pickerImageServices.pickImage(source: ImageSource.gallery);
    if (pikedFile != null) {
      servicesImage = File(pikedFile.path);
      emit(AdminCubitImagePickedServicesSuccessState());
    } else {
      print('No image selected');
      emit(AdminCubitImagePickedServicesErrorState());
    }
  }

  String servicesImageUrl = '';

  void uploadServicesImage() {
    emit(AdminCubitUploadServicesImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
      'services/${Uri.file(servicesImage!.path).pathSegments.last}',
    )
        .putFile(servicesImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        servicesImageUrl = value;
        emit(AdminCubitUploadServicesImageSuccessState());
        print(value);
      }).catchError((error) {
        emit(AdminCubitUploadServicesImageErrorState());
        print(error.toString());
        print('error 1');
      });
    }).catchError((error) {
      emit(AdminCubitUploadServicesImageErrorState());
      print(error.toString());
    });
  }

  String? selectedCategory;

  void selectCategory() {
    emit(AdminStateSelectCategoryState());
  }

  void addServices({
    required String titleServicesAr,
    required String titleServicesEn,
    required String imageServices,
    required String urlServices,
    required String idCategory,
    required String date,
  }) {
    ServicesModel model = ServicesModel(
        titleServicesAr: titleServicesAr,
        titleServicesEn: titleServicesEn,
        idCategory: idCategory,
        date:date,
        urlServices: urlServices,
        imageServices: imageServices);
    emit(AdminCubitAddServicesLoadingState());
    FirebaseFirestore.instance.collection('services').add(model.toMap()).then(
      (value) {
        emit(AdminCubitAddServicesSuccessState());
        getServicesData();
      },
    ).catchError(
      (error) {
        emit(AdminCubitAddServicesErrorState());
      },
    );
  }


  void getServicesData() {
    servicesModel = [];
    idServicesModel = [];
    emit(AdminCubitGetServicesLoadingState());
    FirebaseFirestore.instance.collection('services').orderBy('date',descending: true).get().then((value) {
      value.docs.forEach((element) {
        servicesModel.add(ServicesModel.fromJson(element.data()));
        idServicesModel.add(element.id);
      });
      emit(AdminCubitGetServicesSuccessState());
    }).catchError(
      (error) {
        print(error.toString());
        emit(AdminCubitGetServicesErrorState());
      },
    );
  }

  void deleteServices({
    required String uIdServices,
    required String urlServices,
    required context,
  }) {
    FirebaseStorage.instance.refFromURL(urlServices).delete().then((value) {
      print('done');
    }).catchError((error) {
      print(error);
    });
    print(uIdServices);
    emit(AdminCubitDeleteServicesLoadingState());
    FirebaseFirestore.instance
        .collection('services')
        .doc(uIdServices)
        .delete()
        .then((value) {
      emit(AdminCubitDeleteServicesSuccessState());
      Navigator.pop(context);
      getServicesData();
    }).catchError((error) {
      emit(AdminCubitDeleteServicesErrorState());
    });
  }

  void editServices({
    required String idServices,
    required String titleServicesAr,
    required String titleServicesEn,
    required String imageServices,
    required String urlServices,
    required String idCategory,
    required String date,
    context,
  }) {
    ServicesModel model = ServicesModel(
        titleServicesAr: titleServicesAr,
        titleServicesEn: titleServicesEn,
        idCategory: idCategory,
        date:date,
        urlServices: urlServices,
        imageServices: imageServices);
    emit(AdminCubitEditServicesLoadingState());
    FirebaseFirestore.instance
        .collection('services')
        .doc(idServices)
        .update(model.toMap())
        .then(
      (value) {
        emit(AdminCubitEditServicesSuccessState());
        print('EDIT SERVICE');
        getServicesData();
      },
    ).catchError(
      (error) {
        emit(AdminCubitEditServicesErrorState());
      },
    );
  }

  void logout(context, Widget screen) {
    CachHelper.removeData('uId');
    uId = CachHelper.getData('uId');
    navigatorAndFinish(context,  screen);
    emit(AdminCubitLogoutState());
  }

}
