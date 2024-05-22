import 'package:flutter/material.dart';

class CollapsableList extends StatefulWidget {
  final String title;
  final Widget child;

  const CollapsableList({super.key, required this.title, required this.child});

  @override
  State<CollapsableList> createState() => _CollapsableListState();
}

class _CollapsableListState extends State<CollapsableList>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18),
            ),
            Transform.scale(
              scale: 0.75,
              child: IconButton(
                onPressed: () {
                  if (_animationController.isDismissed) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                ),
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _animationController,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizeTransition(
          sizeFactor: _animationController,
          axis: Axis.vertical,
          child: widget.child,
        ),
      ],
    );
  }
}
