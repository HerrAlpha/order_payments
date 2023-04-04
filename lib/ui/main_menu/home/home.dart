import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/model/product.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

final scrollController = ScrollController();

void setupScrollController(context) {
  scrollController.addListener(() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      BlocProvider.of<ProductCubit>(context).fetchProduct();
    }
    // if (scrollController.position.atEdge) {
    //   if (scrollController.position.pixels != 0) {

    //   }
    // }
  });
}

class _HomeState extends State<Home> {
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupScrollController(context);
    () async {
      await _getDataUser();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  _getDataUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('user_data');
    if (data != null) {
      final user_data = jsonDecode(data);
      user = User.fromJson(user_data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg-home.png"), fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        child: Image(
                          image: AssetImage("assets/icon/avatar.png"),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                          "HI "+(user?.name ?? ''),
                            style: TextStyle(
                                color: Constants.PRIMARY_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Resto/Vendor",
                            style: TextStyle(
                                color: Constants.PRIMARY_COLOR, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: TextField(
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.all(0),
                          hintText: 'Cari Paket...',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          prefixIcon: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 1),
                            child: Icon(Icons.search),
                            width: 20,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
