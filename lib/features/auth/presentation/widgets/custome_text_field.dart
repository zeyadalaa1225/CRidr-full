import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/core/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomeTextField extends StatefulWidget {
  String title;
  String hintText;
  TextEditingController controller;
  CustomeTextField({
    required this.title,
    required this.hintText,
    required this.controller,
  });

  @override
  State<CustomeTextField> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: TextStyle(color: Color(0xff73559A))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // shadow color
                    spreadRadius: .5,
                    blurRadius: 6,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                controller: widget.controller,
                keyboardType: widget.title == "Phone"
                    ? TextInputType.phone
                    : TextInputType.text,
                obscureText:
                    isVisible ||
                        widget.title != "Password" &&
                            widget.title != "Re-Enter Password" &&
                            widget.title != "Enter New Password"
                    ? false
                    : true,
                validator: (value) {
                  if (widget.title == "Email") {
                    return ZValidator.validateEmail(value);
                  } else if (widget.title == "Password" ||
                      widget.title == "Enter New Password" ||
                      widget.title == "Re-Enter Password") {
                    return ZValidator.validatePassword(value);
                  } else if (widget.title == "Phone") {
                    return ZValidator.validatePhoneNumber(value);
                  } else if (widget.title == "Name") {
                    if (value!.isEmpty) {
                      return "Name cannot be empty";
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon:
                      widget.title == "Password" ||
                          widget.title == "Enter New Password" ||
                          widget.title == "Re-Enter Password"
                      ? IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                        )
                      : null,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),

                  hintText: widget.hintText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
