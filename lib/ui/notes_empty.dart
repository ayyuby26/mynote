import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotesEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            child: SvgPicture.asset('assets/pict/empty.svg'),
          ),
          SizedBox(height: 15),
          Text(
            'No Notes ',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
