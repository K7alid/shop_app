import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/constants.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
/*


التوكين انت حاطه فال constant صح؟
هو ب null عشان ممكن انت بعملتلهوش assign وانت بتعمل login بالاكك


* */
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;

        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is ShopLoadingUpdateUserState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultTextFormField(
                    label: 'Name',
                    prefix: Icons.person,
                    textInputType: TextInputType.name,
                    controller: nameController,
                    validate: (value) {
                      if (value.isEmpty()) {
                        return 'Name must not be empty';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultTextFormField(
                    label: 'Email Address',
                    prefix: Icons.email,
                    textInputType: TextInputType.emailAddress,
                    controller: emailController,
                    validate: (value) {
                      if (value.isEmpty()) {
                        return 'Email must not be empty';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultTextFormField(
                    label: 'Phone',
                    prefix: Icons.phone,
                    textInputType: TextInputType.phone,
                    controller: phoneController,
                    validate: (value) {
                      if (value.isEmpty()) {
                        return 'Phone must not be empty';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                    function: () {
                      if (formKey.currentState!.validate()) {
                        ShopCubit.get(context).updateUserData(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                      }
                    },
                    text: 'Update',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                    function: () {
                      signOut(context);
                    },
                    text: 'Logout',
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
