import 'dart:math';

import 'package:cridr/features/home/data/data_sources/vehicle_remote_data_source.dart';
import 'package:cridr/features/home/data/repository/vehicle_rpository_imp.dart';
import 'package:cridr/features/home/domain/repository/vehicle_repository.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_cubit.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_state.dart';
import 'package:cridr/features/home/presentation/pages/price_nigotiation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleInformation extends StatefulWidget {
  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  VehicleRepository repository = VehicleRpositoryImp(VehicleRemoteDataSource());
  List<String> selections = [
    "Select Year",
    "Select Make",
    "Select Model",
    "Select Color",
  ];
  List<dynamic> selectedvalues = [0, "", "", ""];
  List<List<dynamic>> data = [
    List.generate(50, (index) => 2025 - index),
    [],
    [],
    [
      "Red",
      "Green",
      "Blue",
      "Yellow",
      "Orange",
      "Purple",
      "Pink",
      "Brown",
      "Grey",
      "Black",
      "White",
      "Amber",
      "Cyan",
      "Indigo",
      "Lime",
      "Teal",
      "Magenta",
      "Violet",
      "Turquoise",
      "Lavender",
      "Maroon",
      "Olive",
      "Navy",
      "Beige",
      "Coral",
      "Gold",
      "Silver",
      "Bronze",
      "Khaki",
      "Mint",
      "Peach",
      "Plum",
      "Tan",
      "Azure",
      "Ivory",
      "Charcoal",
      "Crimson",
      "Salmon",
      "Mustard",
      "Rose",
      "Emerald",
      "Aquamarine",
      "Chocolate",
      "Copper",
      "Pearl",
      "Sand",
      "Sky Blue",
      "Forest Green",
      "Hot Pink",
      "Sea Green",
      "Slate Gray",
      "Wine",
    ],
  ];

  @override
  Widget build(BuildContext context) {
    List<bool> isactivated = [
      true,
      selectedvalues[0] != 0,
      selectedvalues[1] != "",
      true,
      selectedvalues[0] != 0 &&
              selectedvalues[1] != "" &&
              selectedvalues[2] != "" &&
              selectedvalues[3] != ""
          ? true
          : false,
    ];
    List<Future<void> Function()> functions = [
      () async {},
      () async {
        if (selectedvalues[0] == 0) return;
        final makes = await repository.getMakesForYear(selectedvalues[0]);
        setState(() {
          data[1] = makes.map((e) => e.make_name).toList();
        });
      },
      () async {
        if (selectedvalues[1] == "") return;
        final models = await repository.getModelsForMakeYear(
          selectedvalues[1],
          2025,
        );
        setState(() {
          data[2] = models.map((e) => e.model_name).toList();
        });
      },
      () async {},
    ];

    return BlocListener<ReqDataCubit, ReqDataState>(
      listener: (context, state) {
        if (state is ReqDataSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Success")));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PriceNigotiation()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Vehicle Information')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: selections.length,
                itemBuilder: (context, index) {
                  return CustomDropDown(
                    text: selections[index],
                    isactivated: isactivated[index],
                    onTap: () async {
                      await functions[index]();
                      if (!isactivated[index]) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please ${selections[index - 1]}"),
                          ),
                        );
                        return;
                      }

                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data[index].length,
                            itemBuilder: (context, index2) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedvalues[index] = data[index][index2];
                                    selections[index] = data[index][index2]
                                        .toString();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                          ),
                                          child: Text(
                                            data[index][index2].toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Radio(
                                        value: data[index][index2],
                                        groupValue: selectedvalues[index],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedvalues[index] = value!;
                                            selections[index] =
                                                data[index][index2].toString();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isactivated[isactivated.length - 1]) {
                        BlocProvider.of<ReqDataCubit>(
                          context,
                        ).updatevehicleinfo(
                          selectedvalues[0],
                          selectedvalues[1],
                          selectedvalues[2],
                          selectedvalues[3],
                        );
                      } else
                        return;
                    },
                    child: Text("Next"),
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

class CustomDropDown extends StatelessWidget {
  String text;
  bool isactivated;
  VoidCallback onTap;
  CustomDropDown({
    required this.text,
    required this.isactivated,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isactivated ? Colors.black : Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: isactivated ? Colors.black : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
