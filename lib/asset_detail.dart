import 'package:flutter/material.dart';

class AssetDetailView extends StatelessWidget {
  const AssetDetailView({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new
    Scaffold(
      appBar: new AppBar(title: new Text('My Page')),
      body: new Center(
        child: new FlatButton(
          child: new Text('POP'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

}

