import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/module/control_panel/control_panel_screen.dart';
import 'package:sky_products/module/home/home_screen.dart';
import 'package:sky_products/module/splash/splash_screen.dart';
import 'package:sky_products/remote/cach_helper.dart';
import 'package:sky_products/shared/admin_cubit/cubit.dart';
import 'package:sky_products/shared/app_cubit/cubit.dart';
import 'package:sky_products/shared/app_cubit/states.dart';
import 'package:sky_products/shared/simple_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  Widget startApp;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CachHelper.init();
  uId=CachHelper.getData('uId');

  if(CachHelper.getData('lang')!=null)
  {
    lang=CachHelper.getData('lang');
  }
  if(lang==null || lang=='') {
    lang = CachHelper.saveDataa(key: 'lang', value: 'ar');
    lang=CachHelper.getData('lang');
  }

  print(lang);

  Bloc.observer = SimpleBlocObserver();
  if(uId!=null){
    startApp=const ControlPanelScreen();
  }
  else{
    startApp=const HomeScreen();
  }

  runApp( MyApp(startApp: startApp,langApp: lang,));
}

class MyApp extends StatelessWidget {
  Widget? startApp;
  String? langApp;


  MyApp( {super.key,this.startApp,this.langApp});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()..getBannerData()..getCategoryData()..getLatServicesData()),
        BlocProvider(create: (context) => AdminCubit()),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
       listener: (context, state) {},
        builder: (context, state) {
          return  MaterialApp(

            // localeResolutionCallback: (locale, supportedLocales,) {
            //   if(lang==null ||lang =='') {
            //       CachHelper.saveDataa(key: 'lang', value: locale!.languageCode.toString());
            //     }
            //     return locale;
            // },
            debugShowCheckedModeBanner: false,
            title: 'Sky Products',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale:  Locale(lang),
            theme: ThemeData(
              textTheme: const TextTheme(bodyLarge: TextStyle(color: Color(0xfffe48aa),fontSize: 22)),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor:Color(0xfffe48aa) ,
                unselectedItemColor: Colors.grey,
              ),
              fontFamily: '29LTZ',

              buttonTheme: const ButtonThemeData(buttonColor:Color(0xff000df4) ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              ),
              primarySwatch: Colors.pink,
            ),
            home:SplashPage(),
          );
        },
      ));
  }
}

//#fe48aa
//#000df4
