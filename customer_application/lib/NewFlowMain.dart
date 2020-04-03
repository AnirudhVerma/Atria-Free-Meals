import 'dart:convert';

import 'package:customer_application/BookServiceNewFlow.dart';
import 'package:customer_application/CustomParamsDialog.dart';
import 'package:customer_application/FetchAccountParamsDialog.dart';
import 'package:customer_application/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'CommonMethods.dart';
import 'GlobalVariables.dart';
import 'JSONResponseClasses/BankOTPResponse.dart';

class NewFlowMain extends StatefulWidget {
  @override
  _NewFlowMainState createState() => _NewFlowMainState();
}

class _NewFlowMainState extends State<NewFlowMain> {
  @override
  Widget build(BuildContext context) {
    var bankOutput;
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              'Select Your Bank',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder(
                stream: Repository().getBankList().asStream(),
                builder: (context, bankListSnapshot){
                  if(!bankListSnapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(bankListSnapshot.hasError){
                    return Center(child: Text('Error Occured \n ${bankListSnapshot.error}'),);
                  }
                  else if(bankListSnapshot.data.oUTPUT.length == null){
                    return Container(child: Text('The length of bank list was 0'),);
                  }
                  else{
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                      ),
                      shrinkWrap: true,
                      itemCount: bankListSnapshot.data.oUTPUT.length,
                      itemBuilder: (context, index) {
                        {
                          bankOutput = bankListSnapshot.data.oUTPUT[index];
                          CommonMethods().printLog('project snapshot data is: ${bankListSnapshot.data}');
                          return GestureDetector(
                            onTap: () async {
                              return FetchAccountParamsDialog(selectedBank: bankOutput);
                             /* bankOutput = bankListSnapshot.data.oUTPUT[index];
//                              Repository().fetchUserAccountDetails(bankOutput.bankCode);
                              GlobalVariables().myBankOTPResponse = await Repository().fetchUserAccountDetails(bankOutput.bankCode);
                              GlobalVariables().bankname = bankOutput.bankname;
                              Navigator.push(context, CupertinoPageRoute(builder :(context) => BookServiceNewFlow()));*/
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 20,
                              margin: EdgeInsets.all(4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Hero(
                                    tag: bankOutput.bankname,
                                    child: CircleAvatar(
                                       child: Image.memory(base64Decode(bankOutput.icon.toString().split(',').last))
                                      /*child: new Image(
                                          image: new AssetImage('assets/images/bank_icon.png')),*/
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Center(child: Text(' ${bankOutput.bankname} ',textAlign: TextAlign.center,)),
                                ],
                              ),
                            ),
                          );
                        }
                      },);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
