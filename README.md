# resizable-navigation-bar
Open source implementation of resizable navigation bars in iOS

This project was inspired by Level Money's shift to large navigation headers in iOS and Apple's inability to correctly support this functionality. We were unable to find any implementation, although much of the original research and inspiration behind this project came from edmentec (http://www.emdentec.com/blog/2014/2/25/hacking-uinavigationbar)

![alt tag](https://github.com/Levelmoney/resizable-navigation-bar/blob/master/gifs/resizable_header_fast_small.gif)
![alt tag](https://github.com/Levelmoney/resizable-navigation-bar/blob/master/gifs/resizable_header_slow.gif)

### How to Use

Replace UINavigationController with LVResizableNavigationController.  Then, in any UIViewController that needs to modify the navigation height, implement the protocol LVResizableNavigationBarController.

The code was written in such a way that using LVResizableNavigationController without implementing the LVResizableNavigationBarController protocol will not cause any problems.

// Height for navigation bar -> should be larger than 44.  
// If not implemented, 44 is assumed.
. - (CGFloat)resizableNavigationBarControllerNavigationBarHeight;

// Not required in order to change the BarTintColor but
// necessary if you want to animate color changes between pushes
. - (UIColor *)resizableNavigationBarControllerNavigationBarTintColor;

// Optionally place a subview in the Navigation Bar.  
// Frame is determined by Navigation bar to be.
// {0, 44, screenWidth, resizableNavigationBarControllerNavigationBarHeight - 44}.
. - (UIView *)resizableNavigationBarControllerSubHeaderView;

### Limitations

- The code currently assumes a status bar of 20 pts (fixable).
- Landscape mode is not yet supported
- Navigation bar only works for flat colors, not images or gradients
- Animations aren't *flawless*

### How it Works

Feel free to read through the code.  It is a bit hacky and could struggle in future versions of iOS.  

- The navigation bar is resized using sizeToFit and sizeThatFits.  
- The animations are all controlled by a custom navigation animation to override iOS default behavior.  
- NavigationItems are hidden at animation start, and show at animation complete.
- We rely on changing the color of UINavigationController.view.backgroundColor, which is visible when the navigation bar is larger than 44 pts.  This is why images are difficult to support
- The navigation bar height changes in order to keep layouts sane and correct.  This allows views to be designed in storyboard or programmatically without needed to know what height the navigation bar could become.
