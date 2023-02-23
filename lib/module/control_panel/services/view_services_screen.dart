import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/model/services_model.dart';
import 'package:sky_products/module/control_panel/services/add_services_screen.dart';
import 'package:sky_products/module/control_panel/services/edit_services_screen.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/shared/admin_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewServicesScreen extends StatelessWidget {
  const ViewServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStets>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.secondColor,
            onPressed: () {
              pushToNextScreen(context, AddServicesScreen());
              AdminCubit.get(context).getCategoryData();
            },
            child: const Icon(Icons.add),
          ),
          appBar: customAppBar(title:AppLocalizations.of(context)!.servicesSection),
          body: state is! AdminCubitGetServicesLoadingState
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AdminCubit.get(context).servicesModel.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.55,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return buildServicesItems(
                                context,
                                AdminCubit.get(context).servicesModel[index],
                                AdminCubit.get(context).idServicesModel[index]);
                          },
                          itemCount:
                              AdminCubit.get(context).servicesModel.length,
                        )
                      : noData(context),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
      listener: (context, state) {
        if (state is AdminCubitDeleteServicesSuccessState) {
          showToastSuccess(AppLocalizations.of(context)!.deleteSuccessful);
        }
      },
    );
  }

  Widget buildServicesItems(context, ServicesModel servicesModel, idServices) {
    return InkWell(
      onTap: (){
        pushToNextScreen(
            context,
            EditServicesScreen(
              idServices: idServices,
              servicesModel: servicesModel,
            ));
        AdminCubit.get(context).getCategoryData();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            height: 150.0,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl:   servicesModel.imageServices.toString(),
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
          Flexible(
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(servicesModel.titleServicesAr.toString()))),
          const Divider(),
          Flexible(child: Text(servicesModel.titleServicesEn.toString())),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 25.0,
            decoration:
                BoxDecoration(color: AppColors.grayColor.withOpacity(0.1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    pushToNextScreen(
                        context,
                        EditServicesScreen(
                          idServices: idServices,
                          servicesModel: servicesModel,
                        ));
                    AdminCubit.get(context).getCategoryData();
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.amber,
                  ),
                  padding: EdgeInsets.zero,
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
                                    AdminCubit.get(context).deleteServices(
                                      urlServices:
                                          servicesModel.imageServices.toString(),
                                      uIdServices: idServices,
                                      context: context,
                                    );
                                  },
                                  widget:  Text(
                                    AppLocalizations.of(context)!.yes,
                                    style: const TextStyle(color: Colors.white),
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
                                    style: const TextStyle(color: Colors.white),
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
      ),
    );
  }
}
