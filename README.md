TDDebug
=======

Idriss Juhoor

Debug helper widget

## Overview ##

It's a little widget that pops up a contextual menu for debugging purpose

## How to use it ##

**It needs QuartzCore framework** otherwise you'll see a linker error.

   //Create the hud:
   TDDebugHud *hud = [TDDebugHud currentHud];
   [[self view] addSubview:hud];
  
   //Remove all existing actions if there is:
   [hud removeAllAction];
   
   //Add the actions
   [hud addActionTitle:@"Say Hello"
              onTarget:self
          withSelector:@selector(debugSayHello:)];
~~~

## Bonus
- You can move the hud around if it gets in your way!
