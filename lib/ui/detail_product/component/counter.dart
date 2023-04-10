import 'package:flutter/material.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
Widget CounterProduct(context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
    decoration: BoxDecoration(
      color:  Color(0xFFEBECF0),
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.remove_circle,
          color: Colors.orange,
          size: 25.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
        SizedBox(width: 20,),
        Text(
          "1",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: Color(0xFF1F2430),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 20,),
        Icon(
          Icons.add_circle_outlined,
          color: Colors.orange,
          size: 25.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
      ],
    ),
  );
}
