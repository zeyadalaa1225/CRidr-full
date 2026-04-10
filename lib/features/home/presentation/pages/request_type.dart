
import 'package:cridr/features/home/presentation/cubit/req_data_cubit.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_state.dart';
import 'package:cridr/features/home/presentation/pages/map_page.dart';
import 'package:cridr/features/home/presentation/widgets/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestType extends StatelessWidget {
  List<String> names = [
    "Tow Truck",
    "Tire Change",
    "Jump Start",
    "Fuel Delivery",
    "Locked in",
  ];
  List<String> images = [
    "assets/tow-truck-svgrepo-com.svg",
    "assets/tire-svgrepo-com.svg",
    "assets/car-battery-solid-svgrepo-com.svg",
    "assets/fuel-gas-station-svgrepo-com.svg",
    "assets/lock-svgrepo-com.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReqDataCubit, ReqDataState>(
      listener: (context, state) {
        if (state is ReqDataSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapPage()),
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(height: MediaQuery.of(context).size.height / 5),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: names.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return RequestCard(name: names[index], image: images[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
