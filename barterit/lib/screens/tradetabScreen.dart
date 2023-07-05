import 'dart:convert';
import 'dart:developer';
import 'package:barterit/models/item.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/tradeCartScreen.dart';
import 'package:barterit/screens/tradeDetailsScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../myconfig.dart';

class tradeTabScreen extends StatefulWidget {
  final User user;

  const tradeTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<tradeTabScreen> createState() => _tradeTabScreenState();
}

class _tradeTabScreenState extends State<tradeTabScreen> {
  String maintitle = "Trade";
  List<Item> itemlist = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  int cartqty = 0;
  var color;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTrade(1);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
        actions: [
          IconButton(
            onPressed: () {
              showSearchDialog();
            },
            icon: const Icon(Icons.search),
          ),
          TextButton.icon(
            icon: const Icon(Icons.shopping_cart),
            label: Text(cartqty.toString()),
            onPressed: () {
              if (cartqty > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => tradeCartScreen(
                      user: widget.user,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No item in cart")),
                );
              }
            },
          ),
        ],
      ),
      body: itemlist.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(
              children: [
                Container(
                  height: 24,
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    "$numberofresult Items Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(
                      itemlist.length,
                      (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async {
                              Item useritem =
                                  Item.fromJson(itemlist[index].toJson());
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (content) => tradeDetailScreen(
                                    user: widget.user,
                                    item: useritem,
                                  ),
                                ),
                              );
                              loadTrade(1);
                            },
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barterit/assets/images/${itemlist[index].itemId}-1.png",
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
                                Text(
                                  itemlist[index].itemLocality.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadTrade(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> loadTrade(int pg) async {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }
    await http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/load_item.php"),
      body: {
        //"userid": widget.user.id,
        "pageNo": pg.toString(),
        "search": searchController.text,
      },
    ).then((response) {
      itemlist.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = jsondata['numofpage'];
          numberofresult = jsondata['numberofresult'];
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemlist.add(Item.fromJson(v));
          });
        }
      }
      setState(() {});
    }).catchError((error) {
      print("Error: $error");
    });
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            "Search for Trade",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchItem(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void searchItem(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_item.php"),
        body: {
          "search": search,
        }).then((response) {
      log(response.body);
      itemlist.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemlist.add(Item.fromJson(v));
          });
          numofpage = jsondata['numofpage'];
          numberofresult = jsondata['numberofresult'];
        }
        setState(() {});
      }
    });
  }
}
