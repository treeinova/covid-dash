import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListTileEstado extends StatelessWidget {
  final int ranking;
  final String estado;
  final int casos;
  final int total;
  final int mortes;
  const ListTileEstado({
    Key key,
    this.ranking,
    this.estado,
    this.casos,
    this.mortes,
    this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0, // has the effect of softening the shadow
              spreadRadius: 6, // has the effect of extending the shadow
              offset: Offset(
                0, // horizontal, move right 10
                3, // vertical, move down 10
              ),
            )
          ]),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                "${ranking.toString()}º",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontFamily: 'Poppins',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  estado,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Casos:$casos",
                      style: TextStyle(
                          fontSize: 11,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Mortos:$mortes",
                      style: TextStyle(
                          fontSize: 11,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Letalidade:${(casos / mortes).toStringAsFixed(1)}%",
                      style: TextStyle(
                          fontSize: 11,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 134,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.black12,
                    value: casos / total,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
