import 'package:flutter/material.dart';
import './row.dart';

class Grid extends StatelessWidget{
  final int n;
  final List<List<int>> grid;
  final List<Color> theme;
  Grid(this.n,this.grid,this.theme);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for(var i=0;i<n;i++)
            Rows(n,grid[i],theme)
        ],
      ),
    );
  }  
}