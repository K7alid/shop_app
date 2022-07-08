import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories_screen.dart';
import 'package:shop_app/modules/favourites_screen.dart';
import 'package:shop_app/modules/products_screen.dart';
import 'package:shop_app/modules/settings_screen.dart';
import 'package:shop_app/shared/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int?, bool?>? favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      /*printFullText(homeModel!.data!.banners[0].image!);
      printFullText(homeModel!.data!.products[0].image!);
      printFullText(homeModel.toString());
      print(homeModel!.status);*/

      homeModel!.data!.products.forEach((element) {
        favorites?.addAll({
          element.id: element.inFavorites,
        });
      });

      print(favorites.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error, value) {
      print('the error that in the cubit is => ${error.toString()}');
      emit(ShopErrorHomeDataState(error.toString()));
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      printFullText(categoriesModel.toString());
      print(categoriesModel!.status);

      emit(ShopSuccessCategoriesState());
    }).catchError((error, value) {
      print('the error that in the cubit is => ${error.toString()}');
      emit(ShopErrorCategoriesState(error.toString()));
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites({
    required int productId,
  }) {
    favorites![productId] != favorites![productId];
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel!.status!) {
        favorites![productId] != favorites![productId];
      } else {
        getFavorites();
      }
      print(value.data);
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites![productId] != favorites![productId];
      emit(ShopErrorChangeFavoritesState(error.toString()));
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      printFullText(favoritesModel.toString());
      printFullText(value.data.toString());
      print(favoritesModel!.status);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error, value) {
      print('the error that in the cubit is => ${error.toString()}');
      emit(ShopErrorGetFavoritesState(error.toString()));
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingGetUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      printFullText(userModel!.data!.name.toString());
      /*printFullText(value.data.toString());
      print(favoritesModel!.status);*/

      emit(ShopSuccessGetUserDataState(userModel!));
    }).catchError((error, value) {
      print('the error that in the cubit is => ${error.toString()}');
      emit(ShopErrorGetUserDataState(error.toString()));
    });
  }

  void updateUserData({
    required String phone,
    required String name,
    required String email,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'email': email,
        'name': name,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      printFullText(userModel!.data!.name.toString());
      /*printFullText(value.data.toString());
      print(favoritesModel!.status);*/

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error, value) {
      print('the error that in the cubit is => ${error.toString()}');
      emit(ShopErrorUpdateUserState(error.toString()));
    });
  }
}
