import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/cubit/auth/auth_cubit.dart';
import 'package:phoenix/cubit/auth/auth_state.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/widgets/gradient_button.dart';
import 'package:phoenix/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

final GlobalKey<FormState> _formKey= GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      resizeToAvoidBottomInset: false, // Prevents auto resizing issues
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 80),
                          Center(
                            child: SvgPicture.asset(
                              Assets.imagesPhoenixLogo,
                              height: 100,
                              width: 100,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate(TextHelper.userName)
                                      .toString()
                                      .trim(),
                                  style: getTextTheme().bodyMedium?.copyWith(
                                      fontSize: 16, color: AppColors.white),
                                ),
                                const SizedBox(height: 8),
                                CustomTextFormField(
                                  hintText: translate(TextHelper.userName),
                                  labelText: translate(TextHelper.userName),
                                  controller: userNameController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter username";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  translate(TextHelper.password)
                                      .toString()
                                      .trim(),
                                  style: getTextTheme().bodyMedium?.copyWith(
                                      fontSize: 16, color: AppColors.white),
                                ),
                                const SizedBox(height: 8),
                                CustomTextFormField(
                                  hintText: translate(TextHelper.password),
                                  labelText: translate(TextHelper.password),
                                  controller: passwordController,
                                  isPassword: true,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter password";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<AuthCubit, AuthState>(
                            listenWhen: (oldState, newState) =>
                                oldState.authState != newState.authState,
                            listener: (context, state) {
                              if (state.authState == ProcessState.success) {
                                CustomToast.show(context: context, message: translate(TextHelper.loggedSuccessfully), status: ToastStatus.success);
                                getDashBoardCubit(context)?.getPermissionsData(context);
                                openScreen(dashboardScreen,requiresAsInitial: true);
                              }
                            },
                            buildWhen: (oldState, newState) =>
                                oldState.authState != newState.authState,
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: GradientButton(
                                  isLoading:
                                      state.authState == ProcessState.loading,
                                  onPressed: () {
                                    if (state.authState != ProcessState.loading&& _formKey.currentState!.validate()) {
                                      context
                                          .read<AuthCubit>()
                                          .login(context, userNameController.text, passwordController.text);
                                    }
                                  },
                                  text: "CONTINUE",
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}