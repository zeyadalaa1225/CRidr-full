import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_state.dart';
import 'package:cridr/features/auth/presentation/pages/registration.dart';
import 'package:cridr/features/auth/presentation/pages/verify_otp.dart';
import 'package:cridr/features/auth/presentation/widgets/custome_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthCubitError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        } else if (state is AuthForgetPasswordSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtp(email: controller.text),
            ),
          );
        }
        if (state is AuthCubitLoading) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
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
                            "Enter your email ",
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff73559A),
                            ),
                          ),
                        ),
                        CustomeTextField(
                          title: "Email",
                          hintText: "example@ex.com",
                          controller: controller,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<AuthCubit>(
                                  context,
                                ).forgetPassword(controller.text);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              child: Center(child: Text("Submit")),
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
