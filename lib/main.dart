import 'package:cridr/core/utils/theme/app_theme.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cridr/features/auth/presentation/pages/login.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_cubit.dart';
import 'package:cridr/features/home/presentation/pages/home_page.dart';
import 'package:cridr/features/home/presentation/pages/price_nigotiation.dart';
import 'package:cridr/features/provider/presentation/cubit/provider_cubit.dart';
import 'package:cridr/features/provider/presentation/pages/pending_request.dart';
import 'package:cridr/features/track/presentation/cubit/track_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ReqDataCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ProviderCubit()),
        BlocProvider(create: (context) => TrackCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
        theme: ZAppTheme.lightTheme,
        darkTheme: ZAppTheme.darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
