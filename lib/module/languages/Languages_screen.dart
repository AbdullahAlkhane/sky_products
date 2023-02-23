import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/shared/app_cubit/cubit.dart';
import 'package:sky_products/shared/app_cubit/states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context, state) {

      },
      builder: (context, state) {
        return Scaffold(
          appBar: customAppBar( title:AppLocalizations.of(context)!.selectLanguages.toString(),),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    AppCubit.get(context).setLocalLang('en');
                  },
                  child: const SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 8.0,start: 8.0),
                        child: Text('English'),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    AppCubit.get(context).setLocalLang('ar');
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 8.0,start: 8.0),
                        child: Text('عربي'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
