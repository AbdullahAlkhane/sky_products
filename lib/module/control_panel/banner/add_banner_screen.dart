import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/shared/admin_cubit/states.dart';
import 'package:sky_products/uitls/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBannerScreen extends StatelessWidget {
  const AddBannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStets>(
      builder: (context, state) {
        return Scaffold(
          appBar: customAppBar(title:AppLocalizations.of(context)!.addBanner),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                            backgroundImage: AdminCubit.get(context)
                                        .bannerImage ==
                                    null
                                ? const AssetImage(
                                    'assets/images/logo.png',
                                  )
                                : FileImage(AdminCubit.get(context).bannerImage!)
                                    as ImageProvider,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            AdminCubit.get(context).getBannerImage();
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
                   state is! AdminCubitUploadBannerImageLoadingState?
                  customBottom(
                    width: double.infinity,
                    height: 40.0,
                    color: AppColors.primaryColor,
                    onPressed: () {
                      if(AdminCubit.get(context).bannerImage!=null) {
                        AdminCubit.get(context).uploadBannerImage();
                      }
                      else {
                        showToast( AppLocalizations.of(context)!.pleaseEnterImage);
                      }
                    },
                    widget:  Text(
                      AppLocalizations.of(context)!.addBanner,
                      style: const TextStyle(color: AppColors.whiteColor),
                    ),
                    borderColor: AppColors.secondColor,
                  ):const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AdminCubitUploadBannerImageSuccessState) {
          AdminCubit.get(context).addBanner(
            image: AdminCubit.get(context).bannerImageUrl,
          );
          AdminCubit.get(context).bannerImage=null;
        }
        if(state is AdminCubitAddBannerSuccessState)
        {
          showToastSuccess( AppLocalizations.of(context)!.bannerAddedSuccessful);
        }
      },
    );
  }
}
