import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:firestore/pages/checkout.dart';



import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class TasksPage extends StatefulWidget {
  final String option;

  const TasksPage({Key key, @required this.option}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState(option);
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    getData();
    // collectionReference.{'300'}.get().then((querySnapshot) {
    //   querySnapshot.docs.forEach((result) {
    //     print(result.data());
    //   });
    // });
    super.initState();
  }
  Future<void> getData() async {
    time=[];
    griddata=[];
    seats=[];
    bookingData=[];
    if(option=='View'){
      num='300';
    }else if(option=='Experience'){
      num='600';
    }else{
      num='1000';
    }
    // final CollectionReference collectionReference = FirebaseFirestore.instance.collection(DateFormat('dd-MM-yyyy').format(selectedDate));
    // var collectionReference = FirebaseFirestore.instance.collection(DateFormat('dd-MM-yyyy').format(selectedDate));
    var temp=[];
    collectionReference.collection(DateFormat('dd-MM-yyyy').format(selectedDate)).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        final j=(result.get(num)).toString();
        final decoded = jsonDecode(j) as Map;
        final data = decoded['slots'] as Map;
        for (final name in data.keys) {
          final value = data[name];
          setState(() {
            time.add(name);
            griddata.add(value);
            bookingData.add(0);
            temp=[];
            for (int j=0;j<value;j++){
                temp.add(0);
                print(["hello"]);
              }
            seats.add(temp);
          });
          print('$name,$value'); // prints entries like "AED,3.672940"
          // print(finalDate);
        }

      });
    });


     }
  final String option;
  _TasksPageState(this.option);

  final TextEditingController _textEditingController = TextEditingController();

  var num;
  var time=[];
  var griddata=[];
   List<int> bookingData=[];
  // var data=[11,12,3,7];
  // var griddata=[1,2,3,3];
  var seats=[];
  // var result=[0,0,0,0];
  var totalAmount=0;
  var dyanmicColor=Colors.green;
  DateTime selectedDate=DateTime.now();

  var collectionReference = FirebaseFirestore.instance;

  _selectDate(BuildContext context) async {
    print(time);
    print(DateFormat('dd-MM-yyyy').format(selectedDate));

    bool _decideWhichDayToEnable(DateTime day) {
      if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
          day.isBefore(DateTime.now().add(Duration(days: 90))))) {
        return true;
      }
      return false;
    }
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      selectableDayPredicate: _decideWhichDayToEnable,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String finalDate=DateFormat('dd-MM-yyyy').format(selectedDate);
        getData();
        totalAmount=0;
        //   data=[11,12,3];
        //   griddata=[1,2,3];
        // seats=[[0], [0, 0], [0, 0, 0]];
      });
  }
  void incrementCount (slotIndex,index) {
    setState(() {
      if(seats[slotIndex][index]==0){
        seats[slotIndex][index]=1;
      }else{
        seats[slotIndex][index]=0;
      }


      // for(int i=0;i<seats.length;i++){
      //   for(int j=0;j<seats[i].length;j++){
      //     print(seats[i][j]);
      //   }
      // }
      for(int i=0;i<seats.length;i++){
        var count=0;
        for (int j = 0; j < seats[i].length; j++) {
          if (seats[i][j] == 1) {
            count++;
          }
          bookingData[i]=count;
          print(bookingData);
          // print("${count}, ${i}");
        }
      }
      totalAmount=0;
      for(int i=0;i<seats.length;i++){
        totalAmount=totalAmount+bookingData[i];
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '${widget.option}',
            style: TextStyle(
              fontFamily: 'Lexend Deca',
              color: Color(0xFF090F13),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [],
          elevation: 4,
        ),
         bottomNavigationBar: Container(
           height: 75,
           margin: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
           width: MediaQuery.of(context).size.width * 0.9,
           decoration: BoxDecoration(
             color: Color(0xFF14181B),
             boxShadow: [
               BoxShadow(
                 blurRadius: 4,
                 color: Color(0x55000000),
                 offset: Offset(0, 2),
               )
             ],
             borderRadius: BorderRadius.circular(16),
           ),
           child: Padding(
             padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
             child: Row(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisSize: MainAxisSize.max,
                       children: [
                         Text(
                           '₹${totalAmount*int.parse(num)}',
                           style: TextStyle(
                             fontFamily: 'Lexend Deca',
                             color: Colors.white,
                             fontSize: 18,
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                         Padding(
                           padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                           child: Text(
                             '',
                             style: TextStyle(
                               fontFamily: 'Lexend Deca',
                               color: Color(0xFF8B97A2),
                               fontSize: 14,
                               fontWeight: FontWeight.normal,
                             ),
                           ),
                         ),
                       ],
                     ),
                     Padding(
                       padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                       child: Text(
                         'Total',
                         style: TextStyle(
                           fontFamily: 'Lexend Deca',
                           color: Color(0xFF8B97A2),
                           fontSize: 14,
                           fontWeight: FontWeight.normal,
                         ),
                       ),
                     ),
                   ],
                 ),
                 GestureDetector(
                   onTap: (){
                     var route=new MaterialPageRoute(
                       builder: (BuildContext context)=> new CheckoutWidget(option: option,bookingData: bookingData,time: time,date: DateFormat('dd-MM-yyyy').format(selectedDate)));
                     Navigator.of(context).push(route);
                   },
                   child: Container(
                     decoration: BoxDecoration(
                       color: Color(0xFF4B39EF),
                       borderRadius: BorderRadius.circular(25),
                       border: Border.all(
                         color: Color(0xFF4B39EF),
                       ),
                     ),
                     child: Padding(
                       padding: EdgeInsetsDirectional.fromSTEB(
                           10, 10, 10, 10),
                       child: Text(
                         'Book Now',
                         style:
                         TextStyle(
                           fontFamily: 'Lexend Deca',
                           color: Colors.white,
                           fontSize: 14,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),



          backgroundColor: Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10,),
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFDBE2E7),
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(

                              "${selectedDate.toLocal()}".split(' ')[0],

                              style:TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF4B39EF),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(


                              icon: Icon(
                                Icons.edit_outlined,
                                color: Color(0xFF4B39EF),
                                size: 14,
                              ),
                              onPressed: () => _selectDate(context),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(

                              'R.s ${num}',
                              style:TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF4B39EF),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),

                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Expanded(
                child: ListView.builder(
                    itemCount:time.length,
                    itemBuilder: (BuildContext context,int slotIndex){
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),),
                              child: Container(
                                width: double.infinity,
                                // decoration: BoxDecoration(
                                //   color: Color(0xFFA2F743),
                                //   borderRadius: BorderRadius.circular(20),
                                //   shape: BoxShape.rectangle,
                                // ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                                        child: Text(
                                          '${time[slotIndex]}',
                                          textAlign: TextAlign.start,
                                          style:TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF4B39EF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),

                                        ),
                                      ),
                                      SizedBox(
                                        height: 80,

                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                          child: GridView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: griddata[slotIndex],
                                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 50,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                // childAspectRatio: 1,
                                              ),
                                              itemBuilder:(BuildContext context,index){
                                                return SizedBox(
                                                  // height: ,
                                                  // width: 10,
                                                  child: GestureDetector(
                                                    onTap:()async{incrementCount(slotIndex,index);},
                                                    child: Container(
                                                      // width: 5,
                                                      // height: 5,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Color(0xFF4B39EF),
                                                        ),
                                                        color: seats[slotIndex][index]!=1?Colors.white:Color(0xFF4B39EF),
                                                        borderRadius: BorderRadius.circular(5),
                                                        shape: BoxShape.rectangle,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,)
                        ],
                      );

                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

