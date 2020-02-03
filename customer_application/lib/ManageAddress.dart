import 'dart:convert';

import 'package:customer_application/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'GlobalVariables.dart';
import 'JSONResponseClasses/Address.dart';
import 'networkConfig.dart';

class ManageAddress extends StatelessWidget {

  var addressOutput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Addresses'),
        actions: <Widget>[
          new IconButton(
            icon: new CircleAvatar(child: Icon(Icons.add),),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
//        leading: new Container(),
      ),
      body: FutureBuilder(
        future: Repository().getAddress(),
        builder: (context, addressSnapShot) {
          if (addressSnapShot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
//            itemCount: int.parse(addressSnapShot.data.length),
              shrinkWrap: true,
              itemCount: addressSnapShot.data.length,
              itemBuilder: (context, index) {
                {
                  addressOutput = addressSnapShot.data[index];
                  print('project snapshot data is: ${addressSnapShot.data}');
                  return ListTile(
                    leading: CircleAvatar(
                      child: new Image(
                          image: new AssetImage('assets/images/address_icon.png')),
                    ),
                    title: Text(addressOutput.address),
                    subtitle: Text(addressOutput.addressid.toString()),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }



}
