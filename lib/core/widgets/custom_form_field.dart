import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef Validator = String? Function(String? inputText);
typedef OnChange = void Function(String changedText);

class CustomFormField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final Validator? validator;
  final TextEditingController? controller;
  final OnChange? onChange;
  final GlobalKey<FormFieldState>? formKey;

  const CustomFormField(
      {super.key,
      required this.hintText,
      required this.prefixIcon,
      this.isPasswordField = false,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.controller,
      this.onChange,
      this.formKey});

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool isTextSecured;

  @override
  void initState() {
    super.initState();
    isTextSecured = widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: TextFormField(
          key: widget.formKey,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: isTextSecured,
          onChanged: widget.onChange,
          textDirection: TextDirection.ltr,
          style: GoogleFonts.montserrat(
              color: theme.inputDecorationTheme.hintStyle!.color,
              fontSize: 25,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            label: Text(
              widget.hintText,
            ),
            hintText: widget.hintText,
            suffixIcon: widget.isPasswordField
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            isTextSecured = !isTextSecured;
                          });
                        },
                        icon: isTextSecured
                            ? const Icon(
                                Icons.visibility_off,
                                size: 30,
                              )
                            : const Icon(
                                Icons.visibility,
                                size: 30,
                              )),
                  )
                : null,
            prefixIcon: Icon(widget.prefixIcon),
          ),
        ));
  }
}
