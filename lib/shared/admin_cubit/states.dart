abstract class AdminStets {}

class InitialState extends AdminStets{}

class ShowPassword extends AdminStets{}

class AdminLoginAdminLoadingState extends AdminStets{}

class AdminLoginAdminSuccessState extends AdminStets{
  final  String ? uid;
  AdminLoginAdminSuccessState({this.uid});
}

class AdminLoginAdminErrorState extends AdminStets{}

class AdminCubitImagePickedSuccessState extends AdminStets{}

class AdminCubitImagePickedErrorState extends AdminStets{}

class AdminCubitUploadBannerImageLoadingState extends AdminStets{}

class AdminCubitUploadBannerImageSuccessState extends AdminStets{}

class AdminCubitUploadBannerImageErrorState extends AdminStets{}

class AdminCubitAddBannerLoadingState extends AdminStets{}

class AdminCubitAddBannerSuccessState extends AdminStets{}

class AdminCubitAddBannerErrorState extends AdminStets{}

class AdminCubitGetBannerLoadingState extends AdminStets{}

class AdminCubitGetBannerSuccessState extends AdminStets{}

class AdminCubitGetBannerErrorState extends AdminStets{}

class AdminCubitDeleteBannerLoadingState extends AdminStets{}

class AdminCubitDeleteBannerSuccessState extends AdminStets{}

class AdminCubitDeleteBannerErrorState extends AdminStets{}




class AdminCubitAddCategoryLoadingState extends AdminStets{}

class AdminCubitAddCategorySuccessState extends AdminStets{}

class AdminCubitAddCategoryErrorState extends AdminStets{}

class AdminCubitGetCategoryLoadingState extends AdminStets{}

class AdminCubitGetCategorySuccessState extends AdminStets{}

class AdminCubitGetCategoryErrorState extends AdminStets{}

class AdminCubitDeleteCategoryLoadingState extends AdminStets{}

class AdminCubitDeleteCategorySuccessState extends AdminStets{}

class AdminCubitDeleteCategoryErrorState extends AdminStets{}

class AdminCubitEditCategoryLoadingState extends AdminStets{}

class AdminCubitEditCategorySuccessState extends AdminStets{}

class AdminCubitEditCategoryErrorState extends AdminStets{}




class AdminCubitImagePickedServicesSuccessState extends AdminStets{}

class AdminCubitImagePickedServicesErrorState extends AdminStets{}

class AdminCubitUploadServicesImageLoadingState extends AdminStets{}

class AdminCubitUploadServicesImageSuccessState extends AdminStets{}

class AdminCubitUploadServicesImageErrorState extends AdminStets{}

class AdminStateSelectCategoryState extends AdminStets{}

class AdminCubitAddServicesLoadingState extends AdminStets{}

class AdminCubitAddServicesSuccessState extends AdminStets{}

class AdminCubitAddServicesErrorState extends AdminStets{}

class AdminCubitGetServicesLoadingState extends AdminStets{}

class AdminCubitGetServicesSuccessState extends AdminStets{}

class AdminCubitGetServicesErrorState extends AdminStets{}

class AdminCubitDeleteServicesLoadingState extends AdminStets{}

class AdminCubitDeleteServicesSuccessState extends AdminStets{}

class AdminCubitDeleteServicesErrorState extends AdminStets{}

class AdminCubitEditServicesLoadingState extends AdminStets{}

class AdminCubitEditServicesSuccessState extends AdminStets{}

class AdminCubitEditServicesErrorState extends AdminStets{}

class AdminCubitLogoutState extends AdminStets{}


