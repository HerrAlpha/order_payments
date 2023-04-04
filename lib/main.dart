import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/repository/product_repository.dart';
import 'package:order_payments/ui/login/login_page.dart';
import 'package:order_payments/ui/main_menu/main_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(ProductRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Constants.PRIMARY_COLOR,
            textTheme: GoogleFonts.poppinsTextTheme()),
        home: Scaffold(
          body: Center(
            child: LoginPage(),
          ),
        ),
      ),
    );
  }
}
