import 'package:flutter/material.dart';
import 'package:video_ai/common/ui_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.currentIndex, this.onTap});

  final int currentIndex;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              color: UiColors.c171C26,
              borderRadius: BorderRadius.circular(256)),
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              enableFeedback: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: onTap,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    label: '',
                    icon: Image.asset('images/icon/ic_home.png',
                        width: 32, height: 32),
                    activeIcon: Image.asset('images/icon/ic_home_selected.png',
                        width: 32, height: 32)),
                BottomNavigationBarItem(
                    label: '',
                    icon: Image.asset('images/icon/ic_mine.png',
                        width: 32, height: 32),
                    activeIcon: Image.asset('images/icon/ic_mine_selected.png',
                        width: 32, height: 32))
              ],
            ),
          )),
    );
  }
}
