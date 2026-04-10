import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_state.dart';
import 'package:cridr/features/auth/presentation/pages/new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyOtp extends StatefulWidget {
  String email;
  VerifyOtp({required this.email});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthVerifyOtpSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewPassword()),
          );
        }
        if (state is AuthCubitError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
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
          title: const Text(
            "CRidr",
            style: TextStyle(fontFamily: "KyivTypeSans"),
          ),
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(37),
                      topRight: Radius.circular(37),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Text(
                            "OTP Verification",
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff73559A),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 9,

                              child: TextFormField(
                                controller: otpControllers[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  if (value.isEmpty && index > 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                  if (value.isNotEmpty && index < 5) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "";
                                  }
                                  return null;
                                },
                              ),
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                String otp = otpControllers
                                    .map((controller) => controller.text)
                                    .join('');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Entered OTP: $otp")),
                                );
                                BlocProvider.of<AuthCubit>(
                                  context,
                                ).verifyOtp(otp, widget.email);
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: isLoading
                                  ? CircularProgressIndicator()
                                  : Center(child: Text("Verify OTP")),
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
