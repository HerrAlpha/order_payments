import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/product_detail/product_detail_cubit.dart';
import 'package:order_payments/model/product_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/ui/detail_product/component/counter.dart';
import 'package:order_payments/utils/constant.dart' as Constants;

class DetailProduct extends StatefulWidget {
  const DetailProduct({Key? key}) : super(key: key);

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProductDetailCubit>(context).fetchDetailProduct(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6F8),
      body: Container(
        child: Column(
          children: <Widget>[
            BlocBuilder<ProductDetailCubit, ProductDetailState>(
                builder: (context, state) {
              ProductDetail productDetail = ProductDetail();
              if (state is ProductDetailLoadingState) {
                return CircularProgressIndicator();
              } else if (state is ProductDetailResponseState) {
                productDetail = state.product;
              }

              return Expanded(
                child: Column(
                  children: [
                    CachedNetworkImage(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      fit: BoxFit.cover,
                      imageUrl: "${dotenv.env['STORAGE_URL_API']}" +
                          productDetail.productPict!,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productDetail.name!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFF1F2430),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.orange,
                                      size: 20.0,
                                      semanticLabel:
                                          'Text to announce in accessibility modes',
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "4.3",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Color(0xFF1F2430),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "(342 Review)",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(child: CounterProduct(context))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Deskripsi produk",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Color(0xFF1F2430),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            productDetail.name! +
                                " merupakan makanan asli indonesia yang memiliki cita rasa khas rumahan \n" +
                                productDetail.description!,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              letterSpacing: 1,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        letterSpacing: 1,
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Rp.15.000",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        letterSpacing: 1,
                        color: Constants.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DetailProduct()));
                },
                child: Text("Checkout"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF1F2430)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 30,vertical: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
