import 'package:flutter/material.dart';
import 'package:sqlite_flutter_one/models/Movie.dart';
import 'package:sqlite_flutter_one/widgets/AvatarImageView.dart';

class MovieListItem extends StatelessWidget {
  final Movie item;

  const MovieListItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          SizedBox.fromSize(
            size: Size(60, 60),
            child: AvatarImageView(
              name: item.name,
              photoUrl: item.imageUrl,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.year,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.black.withAlpha(150)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          if (item.watchedTimes != null) Text('👀 ${item.watchedTimes}')
        ],
      ),
    );
  }
}
