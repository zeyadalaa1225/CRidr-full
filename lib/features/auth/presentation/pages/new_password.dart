import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_state.dart';
import 'package:cridr/features/auth/presentation/pages/forget_password.dart';
import 'package:cridr/features/auth/presentation/pages/login.dart';
import 'package:cridr/features/auth/presentation/pages/registration.dart';
import 'package:cridr/features/auth/presentation/widgets/custome_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPassword extends StatefulWidget {
  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool isloading = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthCubitError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        } else if (state is AuthResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password reset successfully")),
          );
          setState(() {
            passwordController.clear();
            confirmPasswordController.clear();
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
        if (state is AuthCubitLoading) {
          setState(() {
            isloading = true;
          });
        } else {
          setState(() {
            isloading = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("CRidr", style: TextStyle(fontFamily: "KyivTypeSans")),

          backgroundColor: ZColors.primaryColor,
        ),
        backgroundColor: ZColors.primaryColor,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .8,
                  decoration: BoxDecoration(
                    color: ZColors.containterColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(37),
                      topRight: Radius.circular(37),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff73559A),
                            ),
                          ),
                        ),
                        CustomeTextField(
                          title: "Enter New Password",
                          hintText: "********",
                          controller: passwordController,
                        ),
                        CustomeTextField(
                          title: "Re-Enter Password",
                          hintText: "********",
                          controller: confirmPasswordController,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (passwordController.text ==
                                    confirmPasswordController.text) {
                                  BlocProvider.of<AuthCubit>(
                                    context,
                                  ).resetPassword(passwordController.text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Password doesn't match"),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              child: isloading
                                  ? Center(child: CircularProgressIndicator())
                                  : Center(child: Text("Reset Password")),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
