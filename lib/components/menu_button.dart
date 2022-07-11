import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
          width: 15,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black87.withOpacity(0.8))),
        ),
        const SizedBox(
          height: 3,
        ),
        SizedBox(
          height: 4,
          width: 25,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black87.withOpacity(0.8))),
        ),
        const SizedBox(
          height: 3,
        ),
        SizedBox(
          height: 4,
          width: 20,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black87.withOpacity(0.8))),
        ),
      ],
    );
  }
}
