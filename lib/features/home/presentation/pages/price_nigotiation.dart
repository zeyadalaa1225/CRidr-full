import 'dart:math';

import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_cubit.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_state.dart';
import 'package:cridr/features/home/presentation/pages/home_page.dart';
import 'package:cridr/features/track/presentation/pages/track_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PriceNigotiation extends StatefulWidget {
  @override
  State<PriceNigotiation> createState() => _PriceNigotiationState();
}

class _PriceNigotiationState extends State<PriceNigotiation> {
  int cost = 0;
  bool isloading = false;
  @override
  initState() {
    final cubit = context.read<ReqDataCubit>();
    cost = cubit.requestModel?.cost ?? 0;
    cubit.connectToSocket();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReqDataCubit, ReqDataState>(
      listener: (context, state) {
        print(state);
        if (state is ReqDataError) {
          setState(() {
            isloading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("can't update prices")));
        } else if (state is ReqDataLoading) {
          setState(() {
            isloading = true;
          });
        } else if (state is RequestCanceled) {
          print("Request Canceledddddd");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Request Canceled")));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        } else if (state is ReqAccepted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TrackPage(request: state.requestModel),
            ), ////// change tomorrow
            (Route<dynamic> route) => false,
          );
        } else if (state is ReqDataSuccess) {
          setState(() {
            isloading = false;
            cost =
                BlocProvider.of<ReqDataCubit>(context).requestModel?.cost ?? 0;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Price ")),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/blurred_map.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: ZColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (cost < 4)
                                    cost = 0;
                                  else
                                    cost -= 50;
                                });
                              },
                              child: Text(
                                "- 50",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Text(
                              cost.toString(),
                              style: TextStyle(fontSize: 50),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  cost += 50;
                                });
                              },
                              child: Text(
                                "+ 50",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<ReqDataCubit>(
                                context,
                              ).updateprice(cost);
                            },
                            child: isloading
                                ? CircularProgressIndicator()
                                : Text(
                                    "Confirm",
                                    style: TextStyle(fontSize: 30),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.red,
                              ),
                            ),
                            onPressed: () {
                              BlocProvider.of<ReqDataCubit>(
                                context,
                              ).cancelRequest();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontSize: 30),
                            ),
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
    );
  }
}
