// ignore_for_file: file_names
import 'package:flutter/material.dart'; // could not fix warning for naming of file
import 'package:provider/provider.dart';
import 'package:frontend/providers/selected_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                  'Shapes Of Sound',
                  style: TextStyle(
                      fontFamily: 'AlfaSlabOne',
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),
            ]));
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _changePage(BuildContext context, int index) {
    context.read<SelectedPage>().selectedPage = index;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: const Color(0xFF355085),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.translate,
                size: 38,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                size: 38,
              ),
              label: '')
        ],
        selectedItemColor: const Color(0xFFBBBBBB),
        unselectedItemColor: const Color(0x4DBBBBBB),
        currentIndex: context.watch<SelectedPage>().selectedPage,
        onTap: ((value) => _changePage(context, value)),
      ),
    );
  }
}
