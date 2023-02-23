import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/model/category_model.dart';
import 'package:sky_products/module/control_panel/category/add_category_screen.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/shared/admin_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ViewCategoryScreen extends StatelessWidget {
  ViewCategoryScreen({Key? key}) : super(key: key);
  var titleArCategoryController = TextEditingController();
  var titleEnCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStets>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.secondColor,
            onPressed: () {
              pushToNextScreen(context, AddCategoryScreen());
            },
            child: const Icon(Icons.add),
          ),
          appBar: customAppBar(title:AppLocalizations.of(context)!.categorySection),
          body: state is! AdminCubitGetCategoryLoadingState
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AdminCubit.get(context).categoryModel.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2.4 /  2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return buildCategoryItems(
                                context,
                                AdminCubit.get(context).categoryModel[index],
                                AdminCubit.get(context).idCategoryModel[index],
                                state);
                          },
                          itemCount:
                              AdminCubit.get(context).categoryModel.length,
                        )
                      : noData(context),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
      listener: (context, state) {
        if (state is AdminCubitDeleteCategorySuccessState) {
          showToastSuccess(AppLocalizations.of(context)!.deleteSuccessful);
        }
        if (state is AdminCubitEditCategorySuccessState) {
          titleEnCategoryController.clear();
          titleArCategoryController.clear();
          showToastSuccess(AppLocalizations.of(context)!.editSuccessful);
        }
      },
    );
  }

  Widget buildCategoryItems(
      context, CategoryModel categoryModel, idCategory, state) {
    return InkWell(
      onTap: () {
        showDialog(

          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Column(
                  children: [
                     Text(AppLocalizations.of(context)!.editCategory),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(

                        context: context,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterTitleCategoryArabic;
                          }
                          return null;
                        },
                        controller: titleArCategoryController,
                        keyboardType: TextInputType.text,
                        hint: AppLocalizations.of(context)!.enterTitleCategoryArabic,
                        prefix: Icons.title),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                        context: context,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterTitleCategoryEnglish;
                          }
                          return null;
                        },
                        controller: titleEnCategoryController,
                        keyboardType: TextInputType.text,
                        hint: AppLocalizations.of(context)!.enterTitleCategoryEnglish,
                        prefix: Icons.title),
                  ],
                ),
                actions: [
                  state is! AdminCubitEditCategoryLoadingState
                      ? customBottom(
                    width: double.infinity,
                    height: 40.0,
                    color: AppColors.primaryColor,
                    onPressed: () {
                      if (titleArCategoryController
                          .text.isNotEmpty &&
                          titleEnCategoryController
                              .text.isNotEmpty) {
                        AdminCubit.get(context).editCategory(
                          titleEn:
                          titleEnCategoryController.text,
                          titleAr:
                          titleArCategoryController.text,
                          idCategory: idCategory,
                          date: categoryModel.date.toString(),
                          context: context,
                        );
                      } else {
                        showToast(
                            AppLocalizations.of(context)!.pleaseEnterTitleCategory);
                      }
                    },
                    widget:  Text(
                      AppLocalizations.of(context)!.editCategory,
                      style: const TextStyle(
                          color: AppColors.whiteColor),
                    ),
                    borderColor: AppColors.secondColor,
                  )
                      : const Center(
                      child: CircularProgressIndicator()),
                ]);
          });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: Text(categoryModel.titleAr.toString())),
          const SizedBox(
            height: 20.0,
          ),
          Flexible(child: Text(categoryModel.titleEn.toString())),
          const SizedBox(height: 20.0),
          Container(
            height: 25.0,
            decoration:
                BoxDecoration(color: AppColors.grayColor.withOpacity(0.1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(

                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Column(
                                children: [
                                   Text(AppLocalizations.of(context)!.editCategory),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  defaultFormField(

                                      context: context,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.pleaseEnterTitleCategoryArabic;
                                        }
                                        return null;
                                      },
                                      controller: titleArCategoryController,
                                      keyboardType: TextInputType.text,
                                      hint: AppLocalizations.of(context)!.enterTitleCategoryArabic,
                                      prefix: Icons.title),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  defaultFormField(
                                      context: context,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.pleaseEnterTitleCategoryEnglish;
                                        }
                                        return null;
                                      },
                                      controller: titleEnCategoryController,
                                      keyboardType: TextInputType.text,
                                      hint: AppLocalizations.of(context)!.enterTitleCategoryEnglish,
                                      prefix: Icons.title),
                                ],
                              ),
                              actions: [
                                state is! AdminCubitEditCategoryLoadingState
                                    ? customBottom(
                                  width: double.infinity,
                                  height: 40.0,
                                  color: AppColors.primaryColor,
                                  onPressed: () {
                                    if (titleArCategoryController
                                        .text.isNotEmpty &&
                                        titleEnCategoryController
                                            .text.isNotEmpty) {
                                      AdminCubit.get(context).editCategory(
                                        titleEn:
                                        titleEnCategoryController.text,
                                        titleAr:
                                        titleArCategoryController.text,
                                        idCategory: idCategory,
                                        date: categoryModel.date.toString(),
                                        context: context,
                                      );
                                    } else {
                                      showToast(
                                          AppLocalizations.of(context)!.pleaseEnterTitleCategory);
                                    }
                                  },
                                  widget:  Text(
                                    AppLocalizations.of(context)!.editCategory,
                                    style: const TextStyle(
                                        color: AppColors.whiteColor),
                                  ),
                                  borderColor: AppColors.secondColor,
                                )
                                    : const Center(
                                    child: CircularProgressIndicator()),
                              ]);
                        });
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.yellowColor,
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
                                    AdminCubit.get(context).deleteCategory(
                                      uIdCategory: idCategory,
                                      context: context,
                                    );
                                  },
                                  widget:  Text(
                                    AppLocalizations.of(context)!.yes,
                                    style: const TextStyle(color: AppColors.whiteColor),
                                  ),
                                  borderColor: AppColors.secondColor,
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
                                    style: const TextStyle(color: AppColors.whiteColor),
                                  ),
                                  borderColor: AppColors.primaryColor,
                                ),
                              ]);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever_outlined,
                    color: AppColors.redColor,
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
