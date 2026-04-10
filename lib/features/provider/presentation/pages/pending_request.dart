import 'package:cridr/core/socket/socket_server.dart';
import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/home/presentation/pages/home_page.dart';
import 'package:cridr/features/provider/presentation/cubit/provider_cubit.dart';
import 'package:cridr/features/provider/presentation/cubit/provider_state.dart';
import 'package:cridr/features/track/presentation/pages/track_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingRequest extends StatefulWidget {
  @override
  State<PendingRequest> createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {
  List<RequestModel> requests = [];
  @override
  void initState() {
    super.initState();
    // Delay cubit call until widget is mounted
    final cubit = context.read<ProviderCubit>();
    cubit.getRequests();
    cubit.connectToSocket(); // pass token here
  }
@override
void dispose() {
  SocketServer().off("request:update"); // remove listener
  SocketServer().off("request:accept:success"); // remove listener
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderCubit, ProviderState>(
      listener: (context, state) {
        print(state);
        if (state is RequestAccepted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => (TrackPage(
              request: state.request,
            ))),
            (Route<dynamic> route) => false,
          );
        }
        if (state is RequestTaken) {
          requests = BlocProvider.of<ProviderCubit>(context).requests;
        }
      },
      builder: (context, state) {
        if (state is ProviderLoaded) {
          requests = state.requests;
          return Scaffold(
            appBar: AppBar(title: Text("Pending Request")),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 250,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: .5,
                          blurRadius: 6,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  requests[index].customerName ?? "",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ZColors.primaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                requests[index].customerPhone ?? "",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: ZColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Service Type",
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  requests[index].issueType,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: ZColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Price",
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    requests[index].cost.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: ZColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: ZColors.primaryColor,
                              ),
                              Text(
                                "${requests[index].latitude}, ${requests[index].longitude}",
                                style: TextStyle(color: ZColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Decline"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ProviderCubit>(
                                  context,
                                ).acceptRequest(requests[index].id);
                              },
                              child: Text("Accept"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: requests.length,
            ),
          );
        } else if (state is ProviderError) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else if (state is ProviderLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AcceptRequestLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text("No requests"));
        }
      },
    );
  }
}
