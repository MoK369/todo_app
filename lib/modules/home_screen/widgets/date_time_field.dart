import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/custom_form_field.dart';

class DateTimeField extends StatefulWidget {
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final bool editable;
  final String title;
  final String hintText;
  final IconData prefixIcon;
  final Validator? validator;
  final Color? fillColor;

  const DateTimeField(
      {super.key,
      this.onTap,
      this.controller,
      this.editable = false,
      required this.hintText,
      required this.prefixIcon,
      required this.title,
      this.validator,
      this.fillColor});

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          TextFormField(
            initialValue: null,
            onTap: () {
              widget.onTap?.call();
            },
            controller: widget.controller,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enableInteractiveSelection: widget.editable,
            focusNode: FocusNode(),
            readOnly: true,
            style: GoogleFonts.montserrat(
                color: theme.inputDecorationTheme.hintStyle!.color,
                fontSize: 20,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              fillColor: widget.fillColor,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintText: widget.hintText,
              prefixIcon: Icon(widget.prefixIcon),
            ),
          ),
        ],
      ),
    );
  }
}
