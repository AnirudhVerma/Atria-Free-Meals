import 'package:customer_application/CommonMethods.dart';
import 'package:customer_application/MyMapsApp.dart';
import 'package:customer_application/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GlobalVariables.dart';

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
            onPressed: () {
              GlobalVariables().longitude = null;
              GlobalVariables().longitude = null;
              Navigator.push(context, CupertinoPageRoute(builder: (context) => MyMapsApp(2)));
            }
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
          }
          if(addressSnapShot.data.length == 1){
            return ListView.builder(
//            itemCount: int.parse(addressSnapShot.data.length),
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
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
          else {
            return ListView.separated(
//            itemCount: int.parse(addressSnapShot.data.length),
              shrinkWrap: true,
              itemCount: addressSnapShot.data.length,
              padding: EdgeInsets.all(10),
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
                    trailing: IconButton(icon: CircleAvatar(child: Icon(Icons.remove_circle),),
                    onPressed: () {
                      String result = Repository().removeAddress(addressOutput.addressid.toString());
                      CommonMethods().toast(context, result);
                    },),
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider(indent: 16,endIndent: 16,);
              },
            );
          }
        },
      ),
    );
  }

}
