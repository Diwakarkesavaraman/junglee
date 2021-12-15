import 'package:firestore/pages/options.dart';
import 'package:firestore/pages/successPage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;

// import 'package:google_fonts/google_fonts.dart';

class CheckoutWidget extends StatefulWidget {
  final List time;
  final List bookingData;
  final String option;
  final String date;

  const CheckoutWidget({Key key,@required this.option,@required this.date,@required this.time,@required this.bookingData}) : super(key: key);

  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  Razorpay _razorpay;
  @override
  void initState() {

    if(widget.option=='View'){
      num='300';
    }else if(widget.option=='Experience'){
      num='600';
    }else{

      num='1000';
    }

    for(int i =0;i<widget.bookingData.length;i++){
      if(widget.bookingData[i]!=0){
        shortbookingData.add(widget.bookingData[i]);
        shortTime.add(widget.time[i]);
        total=total+widget.bookingData[i];
      }

    }
    total=total*int.parse(num);
    print(total);
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var res= await http.get(Uri.parse('http://10.0.2.2:5000/createOrder?amount=${total*100}'));
print("code12");
    final decoded = jsonDecode(res.body.toString()) as Map;
    print(decoded["id"].toString());
    var options = {
      'key': 'rzp_test_yO2Ma68Ms23SBV',
      'amount': total*100,
      'name': 'Junglee',
      'description': 'slots',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': { 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    options['order_id']=decoded['id'].toString();
    print(options.toString());


    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async {
    var slotsString='';
    // Map slotTime;
    for(int i=0;i<shortbookingData.length;i++){
      slotsString=slotsString+"${shortTime[i]}:${shortbookingData[i]} ";
    }
    // print(slotTime);
    // Map printData;
    // printData.addAll({});
    var res= await http.post(Uri.parse('http://10.0.2.2:5000/text-mail?paymentId=${response.paymentId}&orderId=${response.orderId}&total=${total}&slots=${slotsString}'));
    print("success");
    var route=new MaterialPageRoute(
      builder: (BuildContext context)=> new OnSuccess(),);
    Navigator.of(context).push(route);
    // await collectionReference.updateData({
    //   'price' : 200
    // });
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, );
  }

  void _handlePaymentError(PaymentFailureResponse response)async {
    var res= await http.get(Uri.parse('http://10.0.2.2:5000/text-mail'));
    print(res.body);
    print("dskjfalisfbwebfogwefvdsahlfvoueafyblewabfvuoaydcouqbulfb");
    print(response.code.toString()+response.message);
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool agree = false;
  var num;
  var total=0;
  var shortbookingData=[];
  var shortTime=[];
  var collectionReference = FirebaseFirestore.instance;
      // .collection(widget.date);


  // void _proceed() {
  //   var options = {
  //     'key': 'rzp_test_NNbwJ9tmM0fbxj',
  //     'amount': total*100,
  //     'name': 'Shaiq',
  //     'description': 'Payment',
  //     'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
  //     'external': {
  //       'wallets': ['paytm']
  //     }
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint(e);
  //   }
  //   print(shortTime);
  //   print(shortbookingData);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,

        title: Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Lexend Deca',
            color: Color(0xFF151B1E),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF1F5F8),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.96,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x3A000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white,
                                width: 0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 0, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/pigeon-bird.png',
                                          width: 74,
                                          height: 74,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.option}',
                                          style: TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF111417),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 4, 0, 4),
                                          child: Text(
                                            '${num}',
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Color(0xFF090F13),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 8, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 4, 12, 0),
                                                child: Text(
                                                  'Total',
                                                  textAlign: TextAlign.center,
                                                  style:TextStyle(
                                                    fontFamily: 'Lexend Deca',
                                                    color: Color(0xFF111417),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 16, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${total}',
                                                        style: TextStyle
                                                            (
                                                          fontFamily:
                                                          'Lexend Deca',
                                                          color:
                                                          Color(0xFF151B1E),
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x3A000000),
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16, 16, 16, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Slot Timings',
                                    style: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF090F13),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.0*widget.time.length,
                              child: ListView.builder(
                                shrinkWrap: true,
                                  itemCount: shortbookingData.length,
                                  itemBuilder: (BuildContext context,int index){
                                return Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${shortTime[index]}',
                                        style: TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Color(0xFF8B97A2),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '${shortbookingData[index]} persons',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Color(0xFF111417),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),

                            
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Colors.transparent,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x3A000000),
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16, 16, 16, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Terms and Conditions',
                                    style: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF090F13),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                              child: Text(
                                '11.00 am',
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF8B97A2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                              child: Text(
                                '11.00 am',
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF8B97A2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                              child: Text(
                                '11.00 am',
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF8B97A2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                              child: Text(
                                '11.00 am',
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF8B97A2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: agree,
                                  onChanged: (value) {
                                    setState(() {
                                      agree = value ?? false;
                                    });
                                  },
                                ),
                                Text('I have accepted the terms and conditions',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF8B97A2),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(8),
                    //         child: Image.asset(
                    //           'assets/images/applePay.png',
                    //           width: 160,
                    //           height: 44,
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ),
                    //     ClipRRect(
                    //       borderRadius: BorderRadius.circular(8),
                    //       child: Image.asset(
                    //         'assets/images/payPal.png',
                    //         width: 160,
                    //         height: 44,
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    GestureDetector(
                      onTap:

                          agree?openCheckout:null,


                        // agree?openCheckout():null;
                        // var route=new MaterialPageRoute(
                        //   builder: (BuildContext context)=> new Options());
                        // Navigator.of(context).push(route);

                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(

                          decoration: BoxDecoration(
                            color: agree?Color(0xFF4B39EF):Colors.grey,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
