import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


void mpinOtp(BuildContext context){
  final double screenwidth = MediaQuery.of(context).size.width;
  final double screenheight = MediaQuery.of(context).size.height;

  showCupertinoModalPopup(
  context: context, 
  builder: (BuildContext context)=> 
   Container(
    width: double.infinity,
    
   child: Row(
    children: [
      Container(
         decoration:BoxDecoration(color: Colors.grey, border: Border.all(width: 1.0) ),
      ),
      Row(

      children: [
       Container(
        width: 20,height: 20,
        color: Colors.blueGrey,


      ),
       Container(

      ),
       Container(

      ),
       Container(

      ),

      ],
      )
     

    ],
   ),
  
   )  
  );

}
