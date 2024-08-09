
// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Bool.dart';
import '../Constant/links.dart';
import '../Models/sql.dart';

class item_w extends StatefulWidget {
  final image, title, price, idp, love, image_details;
  Function? fun;

  item_w(this.image, this.title, this.price, this.idp, this.love,
      this.image_details,this.fun, {super.key});

  @override
  State<item_w> createState() => _item_wState();
}

final auth = FirebaseAuth.instance;
var fav = FirebaseFirestore.instance.collection("Favorite");
SQLDB sql = SQLDB();

class _item_wState extends State<item_w> {
  @override

  Widget build(BuildContext context) {
    var l=widget.love;
    return Consumer<Bool>(builder: (context, Bool, child) {
      return Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.maxFinite,
                decoration: const ShapeDecoration(shape: StadiumBorder()),
                child: Image.network(
                  "$linkImageRoot/${widget.image}",
                  fit: BoxFit.fill,
                ),
              ),
              // Expanded(child: SizedBox()),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "${widget.price} EGP",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                            isSelected: l,
                            icon: const FaIcon(
                              FontAwesomeIcons.heart,
                              size: 20,
                            ),
                            selectedIcon: const FaIcon(
                              FontAwesomeIcons.solidHeart,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () async {
                              print(l);
                              if (widget.love) {
                                await sql.delete('Favorite', widget.idp);
                                setState(() {
                                  l=false;
                                });
                              } else {
                                await sql.insert('Favorite', {
                                  "id": widget.idp,
                                  'name': widget.title,
                                  'price': widget.price,
                                  'image': widget.image,
                                  'image_details': widget.image_details
                                }); setState(() {
                                  l=true;
                                });
                              }
                              setState(() {
                                print(l);
                              });
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ));
    });
  }
}
