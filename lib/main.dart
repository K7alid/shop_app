import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';

import 'layout/cubit/states.dart';
import 'layout/shop_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  DioHelper.init();
  await CacheHelper.init();
  bool? onBoarding = CacheHelper.getBool(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  final Widget widget;

  if (onBoarding == null) {
    if (token == null) {
      widget = const ShopLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }
  print(token);
  print(onBoarding);
  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(MyApp(widget));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp(
    this.startWidget, {
    Key? key,
  }) : super(key: key);
  final Widget startWidget;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()
        ..getHomeData()
        ..getCategories()
        ..getFavorites()
        ..getUserData(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
            theme: lightTheme,
          );
        },
      ),
    );
  }
}
