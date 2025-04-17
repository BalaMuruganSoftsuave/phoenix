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
import 'package:phoenix/helper/responsive_helper.dart';
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
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Set initial focus to username field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FocusScope.of(context).requestFocus(usernameFocusNode);
    });
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      resizeToAvoidBottomInset: false, // Prevents auto resizing issues
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: Responsive.padding(context, 3)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           SizedBox(height: Responsive.screenH(context, 10)),
                          Center(
                            child: SvgPicture.asset(
                              Assets.imagesPhoenixLogo,
                              height:  Responsive.screenH(context, 10),
                              width:  Responsive.screenH(context, 10),
                            ),
                          ),
                           SizedBox(height:  Responsive.screenH(context, 10)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate(TextHelper.userName)
                                      .toString()
                                      .trim(),
                                  style: getTextTheme().bodyMedium?.copyWith(
                                      fontSize: Responsive.fontSize(context, 4), color: AppColors.white),
                                ),
                                SizedBox(height:  Responsive.screenH(context, 1)),
                                CustomTextFormField(
                                  hintText: translate(TextHelper.userName),
                                  labelText: translate(TextHelper.userName),
                                  controller: userNameController,
                                  focusNode: usernameFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(passwordFocusNode);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return translate(TextHelper.pleaseEnterUsername);
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height:  Responsive.screenH(context, 3)),
                                Text(
                                  translate(TextHelper.password)
                                      .toString()
                                      .trim(),
                                  style: getTextTheme().bodyMedium?.copyWith(
                                      fontSize: Responsive.fontSize(context, 4), color: AppColors.white),
                                ),
                                SizedBox(height:  Responsive.screenH(context, 1)),
                                CustomTextFormField(
                                  hintText: translate(TextHelper.password),
                                  labelText: translate(TextHelper.password),
                                  controller: passwordController,
                                  focusNode: passwordFocusNode,
                                  isPassword: true,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().login(context, userNameController.text, passwordController.text);
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return translate(TextHelper.pleaseEnterPassword);
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height:  Responsive.screenH(context, 3)),
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
                                padding:  EdgeInsets.only(bottom:    Responsive.screenH(context, 3)),
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
                                  text: TextHelper.continue1,
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
    ));
  }
}