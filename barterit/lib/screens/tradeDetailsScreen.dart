import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/item.dart';
import '../models/user.dart';
import '../myconfig.dart';

class tradeDetailScreen extends StatefulWidget {
  final User user;
  final Item item;

  const tradeDetailScreen({Key? key, required this.user, required this.item})
      : super(key: key);

  @override
  State<tradeDetailScreen> createState() => _tradeDetailScreenState();
}

class _tradeDetailScreenState extends State<tradeDetailScreen> {
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm a');
  final List<File?> _images = List.generate(3, (index) => null);

  late double screenHeight, screenWidth, cardWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print(widget.item.itemId);
    print(widget.item.userId);
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              height: 270,
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    _images.length,
                    (index) {
                      return Column(
                        children: [
                          SizedBox(
                            width: screenWidth / 1.1,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  height: 230,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barterit/assets/images/${widget.item.itemId}-${index + 1}.png",
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.item.itemName.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(6),
                },
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Item Owner ID:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            widget.item.userId.toString(),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Description:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            widget.item.itemDesc.toString(),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Item Category:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            // Add the item category here
                            widget.item.itemType.toString(),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Upload Date:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            dateFormat.format(
                              DateTime.parse(widget.item.itemDate.toString()),
                            ),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Upload Location:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '${widget.item.itemLocality}, ${widget.item.itemState}',
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Item Interest:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            // Add the item category here
                            widget.item.itemInterest.toString(),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
