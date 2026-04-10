import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_state.dart';
import 'package:cridr/features/auth/presentation/pages/forget_password.dart';
import 'package:cridr/features/auth/presentation/pages/registration.dart';
import 'package:cridr/features/auth/presentation/widgets/custome_text_field.dart';
import 'package:cridr/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isloading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is authLoginSuccess) {
          setState(() {
            emailController.clear();
            passwordController.clear();
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        } else if (state is AuthCubitError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          setState(() {
            isloading = false;
          });
        } else if (state is AuthCubitLoading) {
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
                            "Welcome back",
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff73559A),
                            ),
                          ),
                        ),
                        CustomeTextField(
                          title: "Email",
                          hintText: "example@ex.com",
                          controller: emailController,
                        ),
                        CustomeTextField(
                          title: "Password",
                          hintText: "********",
                          controller: passwordController,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                textAlign: TextAlign.end,
                                "Forgot Password ?",

                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff73559A),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<AuthCubit>(context).login(
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: isloading
                                    ? CircularProgressIndicator()
                                    : Text("Login"),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Don't have an account ?",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff73559A),
                                ),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Registration(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff73559A),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
