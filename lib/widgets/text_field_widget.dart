import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/utils.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autoFocus;
  final String? errorMessage;
  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.autoFocus = false,
    this.errorMessage,
    this.focusNode,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _internalFocusNode;
  bool _isObscured = true;
  bool _shouldDisposeFocusNode = false;

  @override
  void initState() {
    super.initState();

    // If no external focus node is provided, create one
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
      _shouldDisposeFocusNode = true;
    } else {
      _internalFocusNode = widget.focusNode!;
    }
  }

  @override
  void dispose() {
    if (_shouldDisposeFocusNode) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _internalFocusNode,
      style: getTextTheme().displayMedium?.copyWith(
        color: Colors.white,
        fontSize: 16,
      ),
      cursorColor: Colors.white,
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      autofocus: widget.autoFocus,
      decoration: InputDecoration(
        fillColor: AppColors.darkBg2,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          child: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        )
            : widget.suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.subText),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: AppColors.notificationCardBackground),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorStyle: getTextTheme().displayMedium?.copyWith(color: Colors.red),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorText: widget.errorMessage,
      ),
    );
  }
}
