
import 'package:flutter/material.dart';


class OnSuccess extends StatefulWidget {

  final String total;

  const OnSuccess({Key key,@required this.total,}) : super(key: key);

  // const OnSuccess({Key key}) : super(key: key);

  @override
  _OnSuccessState createState() => _OnSuccessState();
}

class _OnSuccessState extends State<OnSuccess> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF090F13),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Color(0xFF1E2429),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        // borderColor: Colors.transparent,
                        borderRadius:BorderRadius.circular(30),

                      ),
                      child: IconButton(

                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFF4B39EF),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 30, 30),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: Text(
                'Payment Confirmed!',
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF4B39EF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: Text(
                '₹${widget.total}',
                style: TextStyle(
                  fontFamily: 'Overpass',
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 72,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
              child: Text(
                'Your payment has been confirmed, you will receive your conformation mail to your registered mail id .It may take 1-2 hours in order for your payment to go through and show up in your transation list.',
                textAlign: TextAlign.center,
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
      ),
    );
  }
}
