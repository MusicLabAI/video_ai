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
        color: UiColors.c1B1B1F,
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
                icon: Image.asset("assets/images/ic_player.png",
                    width: 28, height: 28),
                activeIcon: Image.asset("assets/images/ic_player_selected.png",
                    width: 28, height: 28),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset("assets/images/ic_edit.png",
                    width: 28, height: 28),
                activeIcon: Image.asset("assets/images/ic_edit_selected.png",
                    width: 28, height: 28),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset("assets/images/ic_video.png",
                    width: 28, height: 28),
                activeIcon: Image.asset("assets/images/ic_video_selected.png",
                    width: 28, height: 28),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset("assets/images/ic_profile.png",
                    width: 28, height: 28),
                activeIcon: Image.asset("assets/images/ic_profile_selected.png",
                    width: 28, height: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
