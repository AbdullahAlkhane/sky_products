import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/model/banner_model.dart';
import 'package:sky_products/module/control_panel/banner/add_banner_screen.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/shared/admin_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewBannerScreen extends StatelessWidget {
  const ViewBannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStets>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.secondColor,
            onPressed: () {
              pushToNextScreen(context, const AddBannerScreen());
            },
            child: const Icon(Icons.add),
          ),
          appBar: customAppBar(title:AppLocalizations.of(context)!.bannerSection),
          body: state is! AdminCubitGetBannerLoadingState
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AdminCubit.get(context).bannerModel.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2.4 / 2.9,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return buildBannerItems(
                                context,
                                AdminCubit.get(context).bannerModel[index],
                                AdminCubit.get(context).idBannerModel[index]);
                          },
                          itemCount: AdminCubit.get(context).bannerModel.length,
                        )
                      : noData(context),
                )
              : const Center(
                child: CircularProgressIndicator(),
              ),
        );
      },
      listener: (context, state) {
        if (state is AdminCubitDeleteBannerSuccessState) {
          showToastSuccess(AppLocalizations.of(context)!.deleteSuccessful);
        }
      },
    );
  }

  Widget buildBannerItems(context, BannerModel bannerModel, idBanner) {
    return Column(
      children: [
        CachedNetworkImage(
          height: 150.0,
          width: double.infinity,
          fit: BoxFit.cover,
          imageUrl:   bannerModel.image.toString(),
          // placeholder: (context, url) => constCenter(
          //               child: CircularProgressIndicator(
          //                 value: loadingProgress.expectedTotalBytes != null
          //                     ? loadingProgress.cumulativeBytesLoaded /
          //                     loadingProgress.expectedTotalBytes!
          //                     : null,
          //               ),
          //             );
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fadeOutDuration: const Duration(seconds: 1),
          fadeInDuration: const Duration(seconds: 3),
        ),
        Container(
          height: 25.0,
          decoration:
              BoxDecoration(color: AppColors.grayColor.withOpacity(0.1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                AppLocalizations.of(context)!.delete,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title:  Center(
                              child:
                                  Text(AppLocalizations.of(context)!.areYouSureFromDeleteThisItem),
                            ),
                            actions: [
                              customBottom(
                                width: 50.0,
                                height: 50.0,
                                color: AppColors.primaryColor,
                                onPressed: () {
                                  AdminCubit.get(context).deleteBanner(
                                    urlBanner: bannerModel.image.toString(),
                                    uIdBanner: idBanner,
                                    context: context,
                                  );
                                },
                                widget:  Text(
                                  AppLocalizations.of(context)!.yes,
                                  style: TextStyle(color: Colors.white),
                                ),
                                borderColor: AppColors.primaryColor,
                              ),
                              customBottom(
                                width: 50,
                                height: 50,
                                color: AppColors.primaryColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                widget:  Text(
                                  AppLocalizations.of(context)!.no,
                                  style: TextStyle(color: Colors.white),
                                ),
                                borderColor: AppColors.primaryColor,
                              ),
                            ]);
                      });
                },
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        )
      ],
    );
  }
}
