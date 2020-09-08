import 'package:flutter/material.dart';

class Rows extends StatelessWidget{
  final int n;
  final List<int> row;
  final List <Color> theme;
  Rows (this.n,this.row,this.theme);
  @override
  Widget build(BuildContext context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for(var i=0;i<n;i++)
            Container(
              width :((MediaQuery.of(context).size.width)/n),
              height :((MediaQuery.of(context).size.width)/n),
              child: null,
              color: theme[row[i]]                                                   ,
            )
        ],
      ),
    );
  }
}