import 'package:cridr/features/home/presentation/cubit/req_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:svg_flutter/svg.dart';

class RequestCard extends StatelessWidget {
  String name;
  String image;
  RequestCard({required this.name, required this.image});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ReqDataCubit>(context).updatereqesttype(name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SvgPicture.asset(image, width: 48, height: 48),
            Text(name),
          ],
        ),
      ),
    );
  }
}
