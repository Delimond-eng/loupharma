import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final MaterialColor color;
  final IconData icon;
  final String label;
  final Function onPressed;
  const MenuItem({
    Key key,
    this.color,
    this.label,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          left: BorderSide(
            color: color.shade900,
            width: 3,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              Flexible(
                child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: color.shade100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          icon ?? Icons.arrow_right_alt_outlined,
                          color: color ?? Colors.black,
                          size: 18.0,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          label,
                          style: TextStyle(
                            color: color ?? Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
