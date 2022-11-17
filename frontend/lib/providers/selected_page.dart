import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SelectedPage with ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;
}
