import 'package:flutter/material.dart';

import '../common/ui_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String errorText;
  final String reg;
  final bool isPwd;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.controller,
    this.isPwd = false,
    required this.errorText,
    required this.reg,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Toggle the obscureText value
    });
  }

  @override
  Widget build(BuildContext context) {
    const noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    );
    const errorBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: UiColors.cFC5454,
        ));

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPwd && _obscureText,
      // Control text visibility
      maxLines: 1,
      style: const TextStyle(fontSize: 12, color: UiColors.cDBFFFFFF),
      decoration: InputDecoration(
        suffixIcon: widget.isPwd
            ? IconButton(
                icon: Image.asset(_obscureText
                    ? "assets/images/ic_pwd_visible.png"
                    : "assets/images/ic_pwd_invisible.png", width: 16,),
                onPressed:
                    _togglePasswordVisibility, // Toggle visibility on press
              )
            : null,
        filled: true,
        fillColor: UiColors.c23242A,
        errorStyle: const TextStyle(fontSize: 12, color: UiColors.cFC5454),
        hintStyle: const TextStyle(fontSize: 12, color: UiColors.c99FFFFFF),
        hintText: widget.hintText,
        enabledBorder: noBorder,
        focusedBorder: noBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
      validator: (value) {
        print(value);
        if (value == null ||
            value.isEmpty ||
            !RegExp(widget.reg).hasMatch(value)) {
          return widget.errorText;
        }
        return null;
      },
    );
  }
}
