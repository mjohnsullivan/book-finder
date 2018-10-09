import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CacheSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cache = Cache.of(context);
    return StreamBuilder(
        stream: cache.stream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return Switch(
            value: snapshot.hasData ? snapshot.data : false,
            onChanged: (i) => cache.cache = i,
          );
        });
  }
}

class Cache extends InheritedWidget {
  Cache({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final _subject = BehaviorSubject<bool>(seedValue: false);

  Observable<bool> get stream => _subject.stream;

  bool get cache => _subject.value;
  set cache(bool value) => _subject.add(value);

  static Cache of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Cache);
  }

  @override
  bool updateShouldNotify(Cache old) => false;

  dispose() {
    _subject?.close();
  }
}
