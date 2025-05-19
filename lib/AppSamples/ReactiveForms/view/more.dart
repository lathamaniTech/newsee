import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void moreActionSheet(
  BuildContext context,
  String action,
) {
  showCupertinoModalPopup<void>(
    context: context,
    builder:
        (BuildContext context) => CupertinoActionSheet(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40, right: 20),
                child: Text(
                  'More',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              SingleChildScrollView(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(130, 158, 158, 158), width: 2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [Icon(Icons.badge_sharp, color: const Color.fromARGB(255, 198, 27, 27), size: 30,), Text('Retail Loan',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal,),)],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(130, 158, 158, 158,), width: 2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [Icon(Icons.agriculture, color: const Color.fromARGB(252, 198, 27, 27),size: 30,), 
                            Text('Agree Loan',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal,),)],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(130, 158, 158, 158), width: 2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [Icon(Icons.business, color: const Color.fromARGB(255, 198, 27, 27),size: 30,), Text('MSME Loan',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal,),)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(130, 158, 158, 158), width: 2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [Icon(Icons.home_filled, color: const Color.fromARGB(255, 198, 27, 27),size: 30,), Text('Home Loan', style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal,),)],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(130, 158, 158, 158), width: 2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [Icon(Icons.car_rental_rounded, color: const Color.fromARGB(255, 198, 27, 27),size: 30,), Text('Vehicle Loan',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal,),)],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(130, 158, 158, 158), width: 2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [Icon(Icons.card_giftcard, color: const Color.fromARGB(255, 198, 27, 27),size: 30,), Text('Gold Loan',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal,),)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 40,right: 20),
                      child: Text("OTHER SERVICES",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.left,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                             Icon(Icons.currency_rupee_rounded),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text('Manage e-Mandates',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.normal
                          ),
                          
                          ),
                        ),
                          ],
                        ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_forward_ios_outlined,
                                             
                          color: const Color.fromARGB(198, 7, 61, 105),
                          size: 20,
                          weight:80,
                                             
                        ),
                      ),
                      
                      ],
                    ),
                    SizedBox(height: 30),
                       Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                             Icon(Icons.person_add_alt),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text('Update Employer Details',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.normal
                          ),
                          
                          ),
                        ),
                          ],
                        ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_forward_ios_outlined,
                                             
                          color: const Color.fromARGB(198, 7, 61, 105),
                          size: 20,
                          weight:80,
                                             
                        ),
                      ),
                      
                      ],
                    )

                  ],
                ),
                


              )
            ],
          ),

          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                   color: const Color.fromARGB(255, 3, 9, 110),
                    child: Text(
                      action,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
  );
}
