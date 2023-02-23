import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/model/banner_model.dart';
import 'package:sky_products/model/category_model.dart';
import 'package:sky_products/model/services_model.dart';
import 'package:sky_products/remote/cach_helper.dart';
import 'package:sky_products/shared/app_cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<BannerModel> bannerModel = [];
  List<String> idBannerModel = [];

  void getBannerData() {
    bannerModel = [];
    idBannerModel = [];
    emit(AppCubitGetBannerLoadingState());
    FirebaseFirestore.instance.collection('banner').get().then((value) {
      value.docs.forEach((element) {
        bannerModel.add(BannerModel.fromJson(element.data()));
        idBannerModel.add(element.id);
      });
      emit(AppCubitGetBannerSuccessState());
    }).catchError(
      (error) {
        print(error.toString());
        emit(AppCubitGetBannerErrorState());
      },
    );
  }

  List<CategoryModel> categoryModel = [];
  List<String> idCategoryModel = [];

  void getCategoryData() {
    categoryModel = [];
    idCategoryModel = [];
    emit(AppCubitGetCategoryLoadingState());
    FirebaseFirestore.instance
        .collection('category')
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        categoryModel.add(CategoryModel.fromJson(element.data()));
        idCategoryModel.add(element.id);
      });
      emit(AppCubitGetCategorySuccessState());
    }).catchError(
      (error) {
        print(error.toString());
        emit(AppCubitGetCategoryErrorState());
      },
    );
  }

  List<ServicesModel> servicesModel = [];
  List<String> idServicesModel = [];

  void getLatServicesData() {
    servicesModel = [];
    idServicesModel = [];
    emit(AppCubitGetLastServicesLoadingState());
    FirebaseFirestore.instance
        .collection('services')
        .orderBy('date', descending: true)
        .limit(50)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        servicesModel.add(ServicesModel.fromJson(element.data()));
        idServicesModel.add(element.id);
      });
      emit(AppCubitGetLastServicesSuccessState());
    }).catchError(
      (error) {
        print(error.toString());
        emit(AppCubitLastGetServicesErrorState());
      },
    );
  }

  // void getServicesByCategoryData() {
  //   emit(AppCubitGetLastServicesLoadingState());
  //   FirebaseFirestore.instance.collection('services').orderBy('date',descending: true).limit(30).get().then((
  //       value) {
  //     value.docs.forEach((element) {
  //       servicesModel.add(ServicesModel.fromJson(element.data()));
  //       idServicesModel.add(element.id);
  //     });
  //     emit(AppCubitGetLastServicesSuccessState());
  //   }).catchError(
  //         (error) {
  //       print(error.toString());
  //       emit(AppCubitLastGetServicesErrorState());
  //     },
  //   );
  // }

  List<ServicesModel> servicesGetBySearchModel = [];
  List<String> idServicesGetBySearchModel = [];

  void getServicesBySearchData(String textSearch) {
    servicesGetBySearchModel = [];
    idServicesGetBySearchModel = [];
    emit(AppCubitGetBySearchServicesLoadingState());
    FirebaseFirestore.instance
        .collection('services')
        .orderBy(lang == 'ar' ? 'titleServicesAr' : 'titleServicesEn', descending: false)
        .where(lang == 'ar' ? 'titleServicesAr' : 'titleServicesEn',
            isGreaterThanOrEqualTo: textSearch,
            isLessThan: textSearch.substring(0, textSearch.length - 1) +
                String.fromCharCode(
                    textSearch.codeUnitAt(textSearch.length - 1) + 1))
        .get()
        .then((value) {
      print(value.docs.length);
      value.docs.forEach((element) {
        servicesGetBySearchModel.add(ServicesModel.fromJson(element.data()));
        idServicesGetBySearchModel.add(element.id);
      });
      emit(AppCubitGetBySearchServicesSuccessState());
    }).catchError(
      (error) {
        print(error.toString());
        emit(AppCubitBySearchGetServicesErrorState());
      },
    );
  }

  void setLocalLang(langCode) {
    lang = CachHelper.saveDataa(key: 'lang', value: langCode);
    lang = CachHelper.getData('lang');
    print(lang.toString());
    emit(AppCubitSetLocalLang());
  }
}
