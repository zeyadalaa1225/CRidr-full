import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_state.dart';
import 'package:cridr/features/auth/presentation/pages/terms_conditons.dart';
import 'package:cridr/features/auth/presentation/widgets/custome_text_field.dart';
import 'package:cridr/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String role = "";
  bool isloading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthCubitError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        } else if (state is authRegisterSuccess) {
          setState(() {
            emailController.clear();
            passwordController.clear();
            nameController.clear();
            phoneController.clear();
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ZColors.containterColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(37),
                        topRight: Radius.circular(37),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Text(
                              "Create an account",
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xff73559A),
                              ),
                            ),
                          ),
                          CustomeTextField(
                            title: "Name",
                            hintText: "John Doe",
                            controller: nameController,
                          ),
                          CustomeTextField(
                            title: "Email",
                            hintText: "johndoe@example.com",
                            controller: emailController,
                          ),
                          CustomeTextField(
                            title: "Phone",
                            hintText: "01234567890",
                            controller: phoneController,
                          ),
                          CustomeTextField(
                            title: "Password",
                            hintText: "********",
                            controller: passwordController,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Role",
                                style: TextStyle(color: Color(0xff73559A)),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    groupValue: role,
                                    value: "User",
                                    onChanged: (value) {
                                      setState(() {
                                        role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    "User",
                                    style: TextStyle(color: Color(0xff73559A)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<String>(
                                    groupValue: role,
                                    value: "Provider",
                                    onChanged: (value) {
                                      setState(() {
                                        role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    "Provider",
                                    style: TextStyle(color: Color(0xff73559A)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "By signing up you agree to our ",
                                style: TextStyle(
                                  color: Color(0xff73559A),
                                  fontSize: 10,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TermsConditions(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (role == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Please select a role"),
                                      ),
                                    );
                                  } else {
                                    print("aaaaaarole:$role");
                                    BlocProvider.of<AuthCubit>(
                                      context,
                                    ).register(
                                      nameController.text,
                                      emailController.text,
                                      phoneController.text,
                                      passwordController.text,
                                      role,
                                    );
                                  }
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                child: isloading
                                    ? CircularProgressIndicator()
                                    : Center(child: Text("Sign Up")),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(color: Color(0xff73559A)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xff73559A),
                                    decoration: TextDecoration.underline,
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
      ),
    );
  }
}
