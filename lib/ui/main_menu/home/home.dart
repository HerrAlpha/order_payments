import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/model/product.dart';
import 'package:order_payments/utils/constant.dart' as Constants;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

final scrollController = ScrollController();

void setupScrollController(context) {
  scrollController.addListener(() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels != 0) {
        BlocProvider.of<ProductCubit>(context).fetchProduct();
      }
    }
  });
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupScrollController(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<ProductCubit>();
      cubit.fetchProduct();
    });
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
                            "HI Wildan",
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                        return _loadingIndicator();
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
                        controller: scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 20),
                        itemBuilder: (context, index) {
                          if (index < products.length)
                            return _product(products[index], context);
                          else {
                            Timer(Duration(milliseconds: 30), () {
                              scrollController.jumpTo(
                                  scrollController.position.maxScrollExtent);
                            });
                            return _loadingIndicator();
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _product(Products product, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //add this
          children: <Widget>[
            Expanded(
              child: Center(
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.fill, // add this
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(product.title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
