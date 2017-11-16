// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import "dto.dart";
import "dart:io";

import 'dart:async';

import 'package:flutter/services.dart';

// import "package:pointycastle/pointycastle.dart";

Future<Uint8List> getImgBytes(int id) async {
  var httpClient = createHttpClient();
  print("Download image from wikipedia");
  var response = await httpClient.get("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Indonesia_-_Lake_Toba_%2826224127503%29.jpg/450px-Indonesia_-_Lake_Toba_%2826224127503%29.jpg");
  return response.bodyBytes;
}


class AssetListView extends StatefulWidget {
  const AssetListView({ Key key }) : super(key: key);

  static const String routeName = '/material/list';

  @override
  AssetListState createState() => new AssetListState();
}

// The state should be just the respective asset summaries
// if the summaries already loaded, the widgest should just use it

class AssetListState extends State<AssetListView> {
  static final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  static const int listSize = 10;

  int numAssets = 0;
  List<Future> assetFutures = new List(listSize);
  List<AssetSummary> assetSummaries = new List(listSize);

  @override
  void initState() {
    super.initState();
    String json = "[{\"city\":\"Gilroy\",\"list_price\":3900000}]";
    assetSummaries = JSON.decode(json).map((j) => new AssetSummary.fromJson(j)).toList();
    numAssets = assetSummaries.length;
  }



  Widget buildListTile(BuildContext context, AssetSummary asset) {
    Widget secondary;
    secondary = const Text("Additional item information");
    print("Building list tile for asset summary ${asset.id}");
    return new ListTile(
        key  : new Key(asset.city),
        isThreeLine: true,
        leading:  new Text(asset.price.toString()),
        title: new Text(asset.city),
        subtitle: secondary,
        onTap :  () {
          // go to detail
          print("User tapped a list item, showing its detail");

          Navigator.of(context).pushNamed('/detail');
        },
        trailing:  new FutureBuilder(
          future : getImgBytes(asset.id),
          builder: (BuildContext context, AsyncSnapshot<Uint8List> imageData) {
            switch (imageData.connectionState) {
              case ConnectionState.none:
                return new Text('???');
              case ConnectionState.waiting:
                return new Text('Loading Image ...');
              default:
                if (imageData.hasError)
                  return new Text('Error: ${imageData.error}');
                else
                  //return new ImageIcon(new MemoryImage(imageData.data));
                  return new Image.memory(imageData.data);

            }
          }
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    var completer = new Completer();

    return new Scaffold(
      key: scaffoldKey,
      body: new Scrollbar(
        child : new ListView.builder(
          scrollDirection : Axis.vertical,
          padding: new EdgeInsets.all(8.0),
          itemExtent: 60.0,
          itemCount:  numAssets,
          itemBuilder: (BuildContext context, int index) {
             return new Padding(
                 padding: new EdgeInsets.all(2.0),
                 child: buildListTile(context,  assetSummaries[index])
             );
           },
        )
      )
    );
  }
}
