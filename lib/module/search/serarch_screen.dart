import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/model/services_model.dart';
import 'package:sky_products/shared/app_cubit/cubit.dart';
import 'package:sky_products/shared/app_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            // The search area here
              title: Container(
                width: double.infinity,
                height: 40.0,
                decoration: BoxDecoration(
                    color: AppColors.secondColor, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (value){
                      if(value.isNotEmpty) {
                        AppCubit.get(context).getServicesBySearchData(value);
                      } else{
                        showToast(AppLocalizations.of(context)!.pleaseEnterTextToSearch);
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search,color: AppColors.whiteColor,),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear,color: AppColors.whiteColor,),
                          onPressed: () {
                            searchController.clear();
                          },
                        ),
                        hintText:  AppLocalizations.of(context)!.search,
                        hintStyle: const TextStyle(color: AppColors.whiteColor),
                        border: InputBorder.none),
                  ),
                ),
              )),
          body:state is! AppCubitGetBySearchServicesLoadingState? Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppCubit.get(context).servicesGetBySearchModel.length > 0
                ? GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                //  childAspectRatio: 2 / 2.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                  mainAxisExtent: 120),
              itemBuilder: (context, index) {
                return buildServicesItems(context,
                    AppCubit.get(context).servicesGetBySearchModel[index]);
              },
              itemCount:
              AppCubit.get(context).servicesGetBySearchModel.length,
            )
                : Center(child: noData(context)),
          ):const Center(child: CircularProgressIndicator())
        );
      },
    );
  }
  Widget buildServicesItems(context, ServicesModel servicesModel) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(servicesModel.urlServices.toString()));
      },
      child: Container(
        color: Colors.grey.withOpacity(0.2),
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
              child: Text(
                lang == 'ar'
                    ? servicesModel.titleServicesAr.toString()
                    : servicesModel.titleServicesEn.toString(),
                style: const TextStyle(
                  fontSize: 12.0, fontWeight: FontWeight.w500,),maxLines: 2,overflow: TextOverflow.ellipsis,),
              ),
          ],
        ),
      ),
    );
  }

}
