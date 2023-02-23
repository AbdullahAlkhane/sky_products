import 'package:flutter/material.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/module/control_panel/banner/view_banner_screen.dart';
import 'package:sky_products/module/control_panel/category/view_category_screen.dart';
import 'package:sky_products/module/control_panel/services/view_services_screen.dart';
import 'package:sky_products/module/home/home_screen.dart';
import 'package:sky_products/remote/cach_helper.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ControlPanelScreen extends StatelessWidget {
  const ControlPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        shadowColor: AppColors.secondColor,
        title:  Text(
          AppLocalizations.of(context)!.controlPanel,
        ),
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () {
            CachHelper.removeData('uId');
            uId = CachHelper.getData('uId');
            navigatorAndFinish(context, const HomeScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40.0,
              ),
              bottom(
                width: double.infinity,
                color: AppColors.whiteColor.withOpacity(0.7),
                borderColor: AppColors.secondColor,
                height: 50.0,
                onPressed: () {
                  pushToNextScreen(context, const ViewBannerScreen());
                  AdminCubit.get(context).getBannerData();
                },
                text: AppLocalizations.of(context)!.managementBanner,
                colorText: AppColors.primaryColor,
              ),
              const SizedBox(
                height: 20.0,
              ),
              bottom(
                width: double.infinity,
                color: AppColors.whiteColor.withOpacity(0.7),
                borderColor: AppColors.secondColor,
                height: 50.0,
                onPressed: () {
                  pushToNextScreen(context, ViewCategoryScreen());
                  AdminCubit.get(context).getCategoryData();
                },
                text: AppLocalizations.of(context)!.managementCategory,
                colorText: AppColors.primaryColor,
              ),
              const SizedBox(
                height: 20.0,
              ),
              bottom(
                width: double.infinity,
                color: AppColors.whiteColor,
                borderColor: AppColors.secondColor,
                height: 50.0,
                onPressed: () {
                  pushToNextScreen(context, const ViewServicesScreen());
                  AdminCubit.get(context).getServicesData();
                },
                text: AppLocalizations.of(context)!.managementServices,
                colorText: AppColors.primaryColor,
              ),
              // const Spacer(),
              // const Center(
              //   child: Text(
              //     'Sky Products',
              //     style: TextStyle(color: AppColors.secondColor),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
