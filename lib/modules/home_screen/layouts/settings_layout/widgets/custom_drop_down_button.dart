import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  final String currentDropDownValue;
  final List<String> dropDownList;
  final void Function(String? value) onChanged;
  final void Function(String e) onTap;
  final String title;
  final IconData icon;

  const CustomDropDownButton(
      {super.key,
      required this.currentDropDownValue,
      required this.dropDownList,
      required this.onChanged,
      required this.onTap,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF5D9CEC), width: 1.5),
          ),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.height * 0.01),
          child: DropdownButton<String>(
            menuWidth: size.width * 0.8,
            underline: const SizedBox(
              height: 0,
            ),
            isExpanded: true,
            icon: Icon(icon),
            value: currentDropDownValue,
            items: dropDownList.map<DropdownMenuItem<String>>(
              (e) {
                return DropdownMenuItem(
                  value: e,
                  onTap: () {
                    onTap(e);
                  },
                  child: Text(e),
                );
              },
            ).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
