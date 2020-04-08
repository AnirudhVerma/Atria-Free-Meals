import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'JSONResponseClasses/SelectedService.dart';

class MyAlertDialog extends StatefulWidget {

  const MyAlertDialog({
    Key key,
    this.title,
    this.titlePadding,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    this.elevation,
    this.actions,
    this.shape,
    this.semanticLabel,
  }) : assert(contentPadding != null),
        super(key: key);


  final Widget title;


  final EdgeInsetsGeometry titlePadding;


  final Widget content;
  final double elevation;
  final RoundedRectangleBorder shape;


  final EdgeInsetsGeometry contentPadding;


  final List<Widget> actions;


  final String semanticLabel;

  @override
  _MyAlertDialogState createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {

  String _date = "Not set";
  String _toDate = 'Not Set';

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    String label = widget.semanticLabel;

    if (widget.title != null) {
      children.add(new Padding(
        padding: widget.titlePadding ?? new EdgeInsets.fromLTRB(24.0, 24.0, 24.0, widget.content == null ? 20.0 : 0.0),
        child: new DefaultTextStyle(
          style: Theme.of(context).textTheme.title,
          child: new Semantics(child: widget.title, namesRoute: true),
        ),
      ));
    } /*else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          label = semanticLabel ?? MaterialLocalizations.of(context)?.alertDialogLabel;
      }
    }*/

    if (widget.content != null) {
      children.add(new Flexible(
        child: new Padding(
          padding: widget.contentPadding,
          child: new DefaultTextStyle(
            style: Theme.of(context).textTheme.subhead,
            child: widget.content,
          ),
        ),
      ));
    }

    if (widget.actions != null) {
      children.add(new ButtonTheme.bar(
        child: new ButtonBar(
          children: widget.actions,
        ),
      ));
    }

    Widget dialogChild = new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    if (label != null)
      dialogChild = new Semantics(
          namesRoute: true,
          label: label,
          child: dialogChild
      );

    return new Dialog(child: dialogChild);
  }

}