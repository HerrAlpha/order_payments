import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/model/product.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';
import 'package:order_payments/ui/main_menu/components/product_card.dart';
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
    BlocProvider.of<ProductCubit>(context).fetchProduct();
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
      color: Color(0xFFF4F6F8),
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
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text(
                  "Pilihan Paket",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoadingState && state.isFirstFetch) {
                          return LoadingIndicator(context);
                        }
                        List<Products> products = [];
                        bool isLoading = false;
                        if (state is ProductLoadingState) {
                          products = state.oldProduct;
                          isLoading = true;
                        } else if (state is ProductResponseState) {
                          products = state.product;
                        }

                        return GridView.builder(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          controller: scrollController,
                          gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio : 3/5 ,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20),
                          itemBuilder: (context, index) {
                            if (index < products.length)
                              return ProductCard(products[index], context);
                            else {
                              Timer(Duration(milliseconds: 30), () {
                                scrollController.jumpTo(
                                    scrollController.position.maxScrollExtent);
                              });
                              return LoadingIndicator(context);
                            }
                          },
                          itemCount: products.length + (isLoading ? 1 : 0),
                        );

                        // return ListView.separated(
                        //   controller: scrollController,
                        //   itemBuilder: (context, index) {
                        //     if (index < products.length)
                        //       return _product(products[index], context);
                        //     else {
                        //       Timer(Duration(milliseconds: 30), () {
                        //         scrollController.jumpTo(
                        //             scrollController.position.maxScrollExtent);
                        //       });
                        //       return _loadingIndicator();
                        //     }
                        //   },
                        //   separatorBuilder: (context, index) {
                        //     return Divider(
                        //       color: Colors.grey[400],
                        //     );
                        //   },
                        //
                        // );
                      }),
                )
              ],
            ),
          ))
        ],
      ),

    );
  }
}
