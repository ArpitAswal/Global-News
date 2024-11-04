import 'package:flutter/animation.dart';

// Custom RectTween with controlled animation speed
class CustomRectTween extends RectTween {
  CustomRectTween({super.begin, super.end});

  @override
  Rect lerp(double t) {
    // Adjust `t` to control the speed of the animation.
    // `t * t` slows down the transition
    // You can modify this to make the transition faster or slower
    final double customT = Curves.fastOutSlowIn.transform(t * 0.9);
    return Rect.lerp(begin, end, customT)!;
  }
}
/*
lerp(double t) is overridden in CustomRectTween to adjust the t parameter, which represents the animation progress.
Using Curves.easeInOut.transform(t * 0.6), the animation progress is slowed by 60%. Adjust this factor to control the speed—decrease it for slower transitions or increase it for faster ones.
 */