import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/shared/admin_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCategoryScreen extends StatelessWidget {
   AddCategoryScreen({Key? key}) : super(key: key);
  var titleArCategoryController = TextEditingController();
  var titleEnCategoryController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStets>(
      builder: (context, state) {
        return Scaffold(
          appBar: customAppBar(title:AppLocalizations.of(context)!.addCategory),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
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
                    const SizedBox(height: 20.0,),
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
                    const SizedBox(
                      height: 50.0,
                    ),
                    state is! AdminCubitAddCategoryLoadingState?
                    customBottom(
                      width: double.infinity,
                      height: 40.0,
                      color: AppColors.primaryColor,
                      onPressed: () {
                        if(formKey.currentState!.validate())
                        {
                          AdminCubit.get(context).addCategory(titleAr: titleArCategoryController.text,titleEn: titleEnCategoryController.text,date:DateTime.now().toString());
                        }
                      },
                      widget:  Text(
                        AppLocalizations.of(context)!.addCategory,
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                      borderColor: AppColors.secondColor,
                    ):const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {

        if(state is AdminCubitAddCategorySuccessState)
        {
         titleArCategoryController.clear();
         titleEnCategoryController.clear();
          showToastSuccess(AppLocalizations.of(context)!.categoryAddedSuccessful);
        }
      },
    );
  }
}

