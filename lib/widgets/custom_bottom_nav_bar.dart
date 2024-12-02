import 'package:flutter/material.dart';
import 'package:video_ai/common/ui_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.currentIndex, this.onTap});

  final int currentIndex;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    const specialEffects = AssetImage('assets/images/ic_special_effects.png');
    const specialEffectsSelected = AssetImage('assets/images/ic_special_effects_selected.png');
    const home = AssetImage('assets/images/ic_home.png');
    const homeSelected = AssetImage('assets/images/ic_home_selected.png');
    const mine = AssetImage('assets/images/ic_mine.png');
    const mineSelected = AssetImage('assets/images/ic_mine_selected.png');
    precacheImage(specialEffects, context);
    precacheImage(specialEffectsSelected, context);
    precacheImage(home, context);
    precacheImage(homeSelected, context);
    precacheImage(mine, context);
    precacheImage(mineSelected, context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: UiColors.c23242A,
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
            items: const [
              BottomNavigationBarItem(
                label: '',
                icon: Image(image: specialEffects, width: 32, height: 32),
                activeIcon: Image(image: specialEffectsSelected, width: 32, height: 32),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image(image: home, width: 32, height: 32),
                activeIcon: Image(image: homeSelected, width: 32, height: 32),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image(image: mine, width: 32, height: 32),
                activeIcon: Image(image: mineSelected, width: 32, height: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
