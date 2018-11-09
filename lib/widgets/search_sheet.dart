import 'package:flutter/material.dart';

void showSearchSheet(BuildContext context) {
  showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.music_note),
              title: new Text('Music'),
              onTap: () => {},
            ),
            new ListTile(
              leading: new Icon(Icons.photo_album),
              title: new Text('Photos'),
              onTap: () => {},
            ),
            new ListTile(
              leading: new Icon(Icons.videocam),
              title: new Text('Video'),
              onTap: () => {},
            ),
          ],
        );
      });
}
