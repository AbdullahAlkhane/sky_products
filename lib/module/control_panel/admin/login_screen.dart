import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/module/control_panel/control_panel_screen.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/shared/admin_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStets>(
      builder: (context, state) {
        return Scaffold(
          appBar: customAppBar(title:AppLocalizations.of(context)!.loginAdmin),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80.0,
                    ),
                     Padding(
                      padding: const EdgeInsetsDirectional.only(start: 5.0),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: const Image(
                            fit: BoxFit.cover,
                            height: 150.0,
                            width: 200,
                            image: AssetImage(
                              'assets/images/logo.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    // const Text(
                    //   'Email',
                    //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    // ),
                    // const SizedBox(
                    //   height: 5.0,
                    // ),
                    defaultFormField(
                        context: context,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterYourEmail;
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        hint: AppLocalizations.of(context)!.enterYourEmail,
                        prefix: Icons.email_outlined),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                        isPassword: AdminCubit.get(context).isoscureShow,
                        context: context,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterYourPassword;
                          }
                          return null;
                        },
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        hint: '*****',
                        prefix: Icons.key_outlined,
                        suffix: AdminCubit.get(context).iconData,
                        suffixPressed: () {
                          AdminCubit.get(context).eyeisShow();
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    state is! AdminLoginAdminLoadingState?bottom(
                        width: double.infinity,
                        color: AppColors.whiteColor.withOpacity(0.7),
                        borderColor: AppColors.primaryColor,
                        height: 50.0,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            AdminCubit.get(context).adminLogin(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        text: AppLocalizations.of(context)!.login,
                        colorText: AppColors.primaryColor):const Center(child: CircularProgressIndicator(),)
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AdminLoginAdminErrorState) {
          showToast(AppLocalizations.of(context)!.pleaseCheckFromPasswordAndUsername);
        }
        if (state is AdminLoginAdminSuccessState) {
          navigatorAndFinish(context, const ControlPanelScreen());
        }
      },
    );
  }
}
