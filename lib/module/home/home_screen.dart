import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/model/category_model.dart';
import 'package:sky_products/model/services_model.dart';
import 'package:sky_products/module/control_panel/admin/login_screen.dart';
import 'package:sky_products/module/languages/Languages_screen.dart';
import 'package:sky_products/module/search/serarch_screen.dart';
import 'package:sky_products/module/services/services_from_category_screen.dart';
import 'package:sky_products/shared/app_cubit/cubit.dart';
import 'package:sky_products/shared/app_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 28.0,
                  child: DrawerHeader(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                    ),
                    child: Text(
                      '',
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: AppColors.secondColor,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.aboutUs,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                  onTap: () {
                    launchUrl(Uri.parse('https://skyproductss.com/about-us/'),       mode: LaunchMode.externalApplication,
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.login,
                    color: AppColors.secondColor,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.admin,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pushToNextScreen(context, LoginScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.language_outlined,
                    color: AppColors.secondColor,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.languages,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pushToNextScreen(context, const LanguagesScreen());
                  },
                ),
              ],
            ),
          ),
          appBar: customAppBar(
              title: AppLocalizations.of(context)!.skyProducts,
              actions: [
                IconButton(
                  onPressed: () {
                    pushToNextScreen(context, SearchScreen());
                  },
                  icon: const Icon(Icons.search_outlined),
                ),
              ]),
          body: AppCubit.get(context).bannerModel.isNotEmpty ||
                 AppCubit.get(context).categoryModel.isNotEmpty ||
              AppCubit.get(context).servicesModel.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      buildSlider(context),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.category,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondColor,
                            fontSize: 20.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                AppCubit.get(context).categoryModel.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildCategory(context,
                                  AppCubit.get(context).categoryModel[index]);
                            }),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.lastServices,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondColor,
                            fontSize: 20.0),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      AppCubit.get(context).servicesModel.length > 0
                          ? GridView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      //  childAspectRatio: 2 / 2.4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 4,
                                      mainAxisExtent: 129,
                                  ),
                              itemBuilder: (context, index) {
                                return buildServicesItems(context,
                                    AppCubit.get(context).servicesModel[index]);
                              },
                              itemCount:
                                  AppCubit.get(context).servicesModel.length,
                            )
                          : Center(child: noData(context)),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget buildSlider(context) {
    return AppCubit.get(context).bannerModel.length > 0
        ? CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1,
            ),
            items: AppCubit.get(context)
                .bannerModel
                .map(
                  (item) => ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: item.image.toString(),
                      //   placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fadeOutDuration: const Duration(seconds: 1),
                      fadeInDuration: const Duration(seconds: 1),
                    ),
                  ),
                )
                .toList(),
          )
        : noData(context);
  }

  Widget buildCategory(context, CategoryModel categoryModel) {
    return InkWell(
      onTap: () {
        pushToNextScreen(
          context,
          ServicesByCategoryScreen(
            categoryModel: categoryModel,
          ),
        );
      },
      child: SizedBox(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100.0,
          ),
          child: Card(
            color: AppColors.primaryColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  lang == 'ar'
                      ? categoryModel.titleAr.toString()
                      : categoryModel.titleEn.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildServicesItems(context, ServicesModel servicesModel) {
    return InkWell(
      onTap: ()async{
        if (!await launchUrl(
            Uri.parse(servicesModel.urlServices.toString()),
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{'my_header_key': 'my_header_value'}),
        )) {
        throw Exception('Could not launch ${servicesModel.urlServices.toString()}');
        }
      //  launchUrl(Uri.parse(servicesModel.urlServices.toString()) , mode: LaunchMode.inAppWebView,);
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            border: Border.all(color: AppColors.secondColor, width: 1.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: 80.0,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: servicesModel.imageServices.toString(),
              // placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fadeOutDuration: const Duration(seconds: 1),
              fadeInDuration: const Duration(seconds: 3),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  lang == 'ar'
                      ? servicesModel.titleServicesAr.toString()
                      : servicesModel.titleServicesEn.toString(),
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
