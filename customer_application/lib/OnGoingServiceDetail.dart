import 'package:flutter/material.dart';

class OnGoingServiceDetail extends StatelessWidget {

  OnGoingServiceDetail({this.serviceName, this.bookingID, this.serviceAccount, this.agentName, this.deliveryAddress, this.preferredDate, this.preferredTime, this.paymentAccount,this.serviceCharge, this.branchName, this.leafCount, this.creditSlipfilled, this.requestDate, this.status, this.authCode});

  final String serviceName;
  final String bookingID;
  final String serviceAccount;
  final String agentName;
  final String deliveryAddress;
  final String preferredDate;
  final String preferredTime;
  final String paymentAccount;
  final String serviceCharge;
  final String branchName;
  final String leafCount;
  final String creditSlipfilled;
  final String requestDate;
  final String status;
  final String authCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Booking Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Row(
                children: <Widget>[
                  Text('Service Booking Detail', style: TextStyle(fontWeight: FontWeight.bold),),
                  Spacer(),
                  OutlineButton(
                    child: Text('View Details', style: TextStyle(color: Colors.blue),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Service Name'),
                          SizedBox(height: 5,),
                          Text('Service Name', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Booking Id'),
                          SizedBox(height: 5,),
                          Text('Booking Id', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Account For Delivery Service'),
                          SizedBox(height: 5,),
                          Text('Account For Delivery Service', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Agent Name'),
                          SizedBox(height: 5,),
                          Text('Agent  Name', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Delivery Address'),
                          SizedBox(height: 5,),
                          Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Preferred Date'),
                          SizedBox(height: 5,),
                          Text('Preffered Date', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Preferred Time'),
                          SizedBox(height: 5,),
                          Text('Preffered Time', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Payment Account'),
                          SizedBox(height: 5,),
                          Text('Payment Account', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Service Charge'),
                          SizedBox(height: 5,),
                          Text('Service Charge', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Branch Name'),
                          SizedBox(height: 5,),
                          Text('Branch Name', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ],
                  ),
                ),
              elevation: 3,),
              SizedBox(height: 20,),
              Text('Additional Service Detail', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Leaf Count'),
                          SizedBox(height: 5,),
                          Text('Credit Slip Filled'),
                          SizedBox(height: 10,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Leaf Count', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Text('Credit Slip Filled', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ],
                  ),
                ),
              elevation: 3,),
              SizedBox(height: 20,),
              Text('Other Details', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Mobile'),
                          SizedBox(height: 5,),
                          Text('Request Date'),
                          SizedBox(height: 10,),
                          Text('Status'),
                          SizedBox(height: 10,),
                          Text('Auth Code'),
                          SizedBox(height: 10,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Mobile', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Text('Request Date', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Status', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Text('Auth Code', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ],
                  ),
                ),
              elevation: 3,),
            ],
          ),
        ),
      ),
    );
  }
}
