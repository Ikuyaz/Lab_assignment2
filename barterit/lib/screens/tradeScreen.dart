import 'dart:convert';
import 'dart:developer';
import 'package:barterit/models/item.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/addScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class tradeScreen extends StatefulWidget {
  final User user;

  const tradeScreen({super.key, required this.user});

  @override
  State<tradeScreen> createState() => _tradeScreenState();
}

class _tradeScreenState extends State<tradeScreen> {
  int _currentIndex = 1;
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Trade";
  List<Item> itemlist = <Item>[];

  @override
  void initState() {
    super.initState();
    loadTrade();
    print("Trade");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: itemlist.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Colors.deepPurpleAccent,
                alignment: Alignment.center,
                child: Text(
                  "${itemlist.length} Item Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(
                      itemlist.length,
                      (index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Card(
                            child: InkWell(
                              onLongPress: () {
                                // onDeleteDialog(index);
                              },
                              onTap: () async {
                                Item singleitem =
                                    Item.fromJson(itemlist[index].toJson());
                                // await Navigator.push(
                                //     context,
                                //     // MaterialPageRoute(
                                //     //     builder: (content) => EditCatchScreen(
                                //     //           user: widget.user,
                                //     //           usercatch: singlecatch,
                                //     //         )));
                                // loadsellerCatches();
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().SERVER}/barterit/assets/images/${itemlist[index].itemId}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Text(
                                    itemlist[index].itemName.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    itemlist[index].itemType.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.user.id != "na") {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (content) => addScreen(
                  user: widget.user,
                ),
              ),
            );
            loadTrade();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please login/register an account"),
              ),
            );
          }
        },
        child: const Text(
          "+",
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  void loadTrade() {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_item.php"),
        body: {"userid": widget.user.id}).then((response) {
      //print(response.body);
      //log(response.body);
      itemlist.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemlist.add(Item.fromJson(v));
          });
          //print(itemlist[0].itemName);
        }
        setState(() {});
      }
    });
  }

  // void onDeleteDialog(int index) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //         title: Text(
  //           "Delete ${catchList[index].itemName}?",
  //         ),
  //         content: const Text("Are you sure?", style: TextStyle()),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text(
  //               "Yes",
  //               style: TextStyle(),
  //             ),
  //             onPressed: () {
  //               deleteCatch(index);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text(
  //               "No",
  //               style: TextStyle(),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void deleteCatch(int index) {
  //   http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/delete_catch.php"),
  //       body: {
  //         "userid": widget.user.id,
  //         "catchid": catchList[index].itemId
  //       }).then((response) {
  //     print(response.body);
  //     //catchList.clear();
  //     if (response.statusCode == 200) {
  //       var jsondata = jsonDecode(response.body);
  //       if (jsondata['status'] == "success") {
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(const SnackBar(content: Text("Delete Success")));
  //         loadsellerCatches();
  //       } else {
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(const SnackBar(content: Text("Failed")));
  //       }
  //     }
  //   });
  // }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
