import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/shared/admin_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddServicesScreen extends StatelessWidget {
  AddServicesScreen({Key? key}) : super(key: key);
  var titleArServicesController = TextEditingController();
  var titleEnServicesController = TextEditingController();
  var urlServicesController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStets>(
      builder: (context, state) {
        return Scaffold(
          appBar: customAppBar(title:AppLocalizations.of(context)!.addServices),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.secondColor,
                            radius: 110.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 100.0,
                              backgroundImage:
                                  AdminCubit.get(context).servicesImage == null
                                      ? const AssetImage(
                                          'assets/images/logo.png',
                                        )
                                      : FileImage(AdminCubit.get(context)
                                          .servicesImage!) as ImageProvider,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              AdminCubit.get(context).getServicesImage();
                            },
                            icon: const CircleAvatar(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    defaultFormField(
                        context: context,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterTitleServicesArabic;
                          }
                          return null;
                        },
                        controller: titleArServicesController,
                        keyboardType: TextInputType.text,
                        hint: AppLocalizations.of(context)!.enterTitleServicesArabic,
                        prefix: Icons.title),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                        context: context,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterTitleServicesEnglish;
                          }
                          return null;
                        },
                        controller: titleEnServicesController,
                        keyboardType: TextInputType.text,
                        hint:  AppLocalizations.of(context)!.enterTitleServicesEnglish,
                        prefix: Icons.title),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                        context: context,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return  AppLocalizations.of(context)!.pleaseEnterUrlServices;
                          }
                          return null;
                        },
                        controller: urlServicesController,
                        keyboardType: TextInputType.text,
                        hint:  AppLocalizations.of(context)!.enterUrlServices,
                        prefix: Icons.link_outlined),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(20.0),
                            isExpanded: true,
                            hint:  Text( AppLocalizations.of(context)!.pleaseEnterCategory),
                            value: AdminCubit.get(context).selectedCategory,
                            items: AdminCubit.get(context)
                                .categoryModel
                                .map((value) {
                              return DropdownMenuItem<String>(
                                value: value.idCategory,
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Text(lang=='ar'?value.titleAr.toString():value.titleEn.toString())),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              AdminCubit.get(context).selectedCategory =
                                  newValue;
                              AdminCubit.get(context).selectCategory();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    state is! AdminCubitUploadServicesImageLoadingState
                        ? customBottom(
                            width: double.infinity,
                            height: 40.0,
                            color: AppColors.primaryColor,
                            onPressed: () {
                              if(formKey.currentState!.validate())
                            {
                              if (AdminCubit.get(context).servicesImage !=
                                  null && AdminCubit.get(context).selectedCategory!.isNotEmpty) {
                                AdminCubit.get(context).uploadServicesImage();
                              } else {
                                showToast( AppLocalizations.of(context)!.pleaseEnterImageAndCategory);
                              }
                            }
                            },
                            widget:  Text(
                              AppLocalizations.of(context)!.addServices,
                              style: const TextStyle(color: AppColors.whiteColor),
                            ),
                            borderColor: AppColors.secondColor,
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AdminCubitUploadServicesImageSuccessState) {
          AdminCubit.get(context).addServices(
            date: DateTime.now().toString(),
            imageServices: AdminCubit.get(context).servicesImageUrl,
            idCategory: AdminCubit.get(context).selectedCategory.toString(),
            titleServicesAr: titleArServicesController.text,
            urlServices:urlServicesController.text,
            titleServicesEn: titleEnServicesController.text,
          );
        }
        if (state is AdminCubitAddServicesSuccessState) {
          showToastSuccess(AppLocalizations.of(context)!.servicesAddedSuccessful);
          AdminCubit.get(context).servicesImage = null;
          AdminCubit.get(context).selectedCategory = null;
          titleArServicesController.clear();
          titleEnServicesController.clear();
          urlServicesController.clear();
        }
      },
    );
  }
}
