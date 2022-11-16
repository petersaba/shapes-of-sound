// ignore_for_file: file_names
import 'package:flutter/material.dart'; // could not fix warning for naming of file

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Column(children: <Widget>[
        const SizedBox(height: 55),
        Row(
          children: const <Widget>[
            SizedBox(width: 20,),
            Text(
              'Shapes Of Sound',
              style: TextStyle(
                fontFamily: 'AlfaSlabOne', 
                fontSize: 22,
                color: Colors.white),
            ),
          ]
        )
      ]),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}