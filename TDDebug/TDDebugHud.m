//
//  TDDebugHud.m
//  TouchDebug
//
//  Created by Idriss Juhoor on 6/15/12.
//  Copyright (c) 2012 Idriss Juhoor, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>

#import "TDDebugHud.h"


#define BT_HEIGHT 40.0f

BOOL moved;
CGPoint lastTouchPosition;
CGRect _originalSize;

BOOL _menuOpened;

TDDebugHud *_sharedInstance = nil;

@interface TDDebugHud (_internals)

- (void)fadeOut;

- (void)openMenu;
- (void)closeMenu;

- (UIScrollView*)makeScrollView:(CGRect)frame;

@end

@implementation TDDebugHud


+ (TDDebugHud*)currentHud {
  
  if (_sharedInstance == nil) {
    _sharedInstance = [[TDDebugHud alloc] initWithFrame:CGRectMake(0,0,46,46)];
  }
  
  if ([_sharedInstance superview] != nil){
    [[_sharedInstance superview] addSubview:_sharedInstance];
  }
  
  return _sharedInstance;
  
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
      _originalSize = CGRectInset(frame, 0, 0);
      
      [[self layer] setCornerRadius:8.0f];
      [[self layer] setBackgroundColor:[[UIColor blackColor] CGColor]];
      [[self layer] setFrame:_originalSize];
      
      _containerLayer = [CALayer layer];
      [_containerLayer setFrame:_originalSize];
      
      CALayer *bg3Circle = [CALayer layer];
      [bg3Circle setBackgroundColor:[[UIColor whiteColor] CGColor]];
      [bg3Circle setFrame:CGRectInset(_originalSize, 4.0f, 4.0f)];
      [bg3Circle setShadowColor:[[UIColor blackColor] CGColor]];
      [bg3Circle setShadowOffset:CGSizeMake(0,0)];
      [bg3Circle setShadowRadius:4.0];
      [bg3Circle setShadowColor:[[UIColor blackColor] CGColor]];
      [bg3Circle setShadowOpacity:0.8];
      [bg3Circle setCornerRadius:[bg3Circle frame].size.height / 2.0f ];
      [bg3Circle setOpacity:0.4];
      
      CALayer *bg2Circle = [CALayer layer];
      [bg2Circle setBackgroundColor:[[UIColor whiteColor] CGColor]];
      [bg2Circle setFrame:CGRectInset(_originalSize, 8.0f, 8.0f)];
      [bg2Circle setShadowColor:[[UIColor blackColor] CGColor]];
      [bg2Circle setShadowOffset:CGSizeMake(0,0)];
      [bg2Circle setShadowRadius:2.0];
      [bg2Circle setShadowColor:[[UIColor blackColor] CGColor]];
      [bg2Circle setShadowOpacity:0.8];
      [bg2Circle setCornerRadius:[bg2Circle frame].size.height / 2.0f ];
      [bg2Circle setOpacity:0.6];
      
      CALayer *bgCircle = [CALayer layer];
      [bgCircle setBackgroundColor:[[UIColor whiteColor] CGColor]];
      [bgCircle setFrame:CGRectInset(_originalSize, 12.0f, 12.0f)];
      [bgCircle setShadowColor:[[UIColor blackColor] CGColor]];
      [bgCircle setShadowOffset:CGSizeMake(0,0)];
      [bgCircle setShadowRadius:2.0];
      [bgCircle setShadowColor:[[UIColor blackColor] CGColor]];
      [bgCircle setShadowOpacity:0.8];
      [bgCircle setCornerRadius:[bgCircle frame].size.height / 2.0f ];
      [bgCircle setOpacity:0.9];
      
      [_containerLayer addSublayer:bg3Circle];
      [_containerLayer addSublayer:bg2Circle];
      [_containerLayer addSublayer:bgCircle];
      
      [[self layer] addSublayer:_containerLayer];
      
      
      [self setAlpha:1.0f];
      
      [self performSelector:@selector(fadeOut) withObject:nil afterDelay:3.0f];
      
      _menuOpened = NO;
      
      _actions = [[NSMutableDictionary alloc] init];
     
      _sharedInstance = self;
      
    }
  
    return self;
}

- (void)dealloc {
  
  _sharedInstance = nil;
  [_actions release];
  [super dealloc];
  
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  //register the touch
  UITouch *touch = [touches anyObject];
  lastTouchPosition = [touch locationInView:[self superview]];
  
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOut) object:nil];
  [UIView animateWithDuration:0.2 
                        delay:0 
                      options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut 
                   animations:^{
                     [self setAlpha:1];
                   }
                   completion:^(BOOL finished){
                     
                   }];
  
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  //Move the view
  
  if (!_menuOpened){
    moved = YES;
    
    CGPoint touch = [[touches anyObject] locationInView:[self superview]];
    
    CGRect windowSize = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] bounds];
    
    if (touch.x > windowSize.size.width)
      touch.x = windowSize.size.width;
    
    if (touch.y > windowSize.size.height )
      touch.y = windowSize.size.height;
    
    
    if (sqrt( pow(touch.x - lastTouchPosition.x, 2) + pow(touch.y - lastTouchPosition.y, 2) ) > 5.0f){
      
      CGRect newPosition = [self frame];
      newPosition.origin.x = touch.x - newPosition.size.width / 2.0f;
      newPosition.origin.y = touch.y - newPosition.size.width / 2.0f;
      
      [self setFrame:newPosition];
      
    }
  }
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
  if (moved){
   
    //If moved, snap to a correct position
    
    float hDivider = 1.0;
    float vDivider = 1.0;
    
    CGRect windowSize = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] bounds];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    float horizontalLength = windowSize.size.width;
    float verticalLength = windowSize.size.height - statusBarFrame.size.height;
    
    if (horizontalLength > 320)
      hDivider = 3.0;
    if (verticalLength > 320)
      vDivider = 3.0;
    
    
    int hModulo = (horizontalLength - self.frame.size.width) / hDivider;
    int vModulo = (verticalLength - self.frame.size.height) / vDivider;
    
    CGRect correctedPosition = [self frame];
    correctedPosition.origin.x = (int)roundf(correctedPosition.origin.x / hModulo) * hModulo;
    correctedPosition.origin.y = (int)roundf(correctedPosition.origin.y / vModulo) * vModulo;
    
    [UIView animateWithDuration:0.4f animations:^(void){
      [self setFrame:correctedPosition];
    }];
    
    _originalSize = correctedPosition;
    
  }else{
   
    if (_menuOpened){
      [self closeMenu];
    }else{
      [self openMenu];
      
    }
    
  }
  
  [self performSelector:@selector(fadeOut) withObject:nil afterDelay:3.0f];
  
  moved = NO;
  
}


- (void)addActionTitle:(NSString*)title onTarget:(id)target withSelector:(SEL)selector {
  
  UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
  [bt setTitle:title forState:UIControlStateNormal];
  [[bt titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
  [bt addTarget:target 
         action:selector 
forControlEvents:UIControlEventTouchUpInside];
  
  [bt addTarget:self 
         action:@selector(closeMenu) 
forControlEvents:UIControlEventTouchUpInside];
  
  [[bt layer] setBorderColor:[[UIColor whiteColor] CGColor]];
  [[bt layer] setCornerRadius:2.0f];
  [[bt layer] setBorderWidth:2.0f];
  
  [_actions setValue:bt forKey:title];
  
}

- (void)removeActionForTitle:(NSString*)title {
  
  [_actions removeObjectForKey:title];
  
}

- (void)removeAllAction {
  
  [_actions removeAllObjects];
  
}

@end

@implementation TDDebugHud (_internals)

- (void)fadeOut {
  
  if (!_menuOpened){
  
    [UIView animateWithDuration:0.4 
                          delay:0 
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut 
                     animations:^{
                       [self setAlpha:0.2f];
                     }
                     completion:^(BOOL finished){
                       
                     }];
  } 
}


- (void)openMenu {

  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOut) object:nil];
  
  CGRect windowSize = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] bounds];
  
  CGRect popup = CGRectMake(0, 0, 300, 300);
  popup.origin.x = (windowSize.size.width - popup.size.width) / 2.0f;
  popup.origin.y = (windowSize.size.height - popup.size.height) / 2.0f;
  
  CGRect closeButtonRect = [_containerLayer frame];
  closeButtonRect.origin.x = (300 - closeButtonRect.size.width ) / 2.0f;
  closeButtonRect.origin.y = 300 - closeButtonRect.size.height;
  
  
  [UIView animateWithDuration:0.2 
                        delay:0 
                      options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut 
                   animations:^{
                     
                     [_containerLayer setFrame:closeButtonRect];
                     [[self layer] setFrame:popup];
                     
                   }
                   completion:^(BOOL finished){
                     
                     _actionsView = [self makeScrollView:CGRectMake(10,10, 280,250)];
                     
                     [self addSubview:_actionsView];
                      
                   }];
  
  _menuOpened = YES;
}

- (void)closeMenu {
  
  [_actionsView removeFromSuperview];
  _actionsView = nil;
  
  [UIView animateWithDuration:0.2 
                        delay:0 
                      options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut 
                   animations:^{
                     
                     [_containerLayer setFrame:CGRectMake(0,0,_originalSize.size.width, _originalSize.size.height)];
                     [[self layer] setFrame:_originalSize];
                   }
                   completion:^(BOOL finished){
                     [self performSelector:@selector(fadeOut) withObject:nil afterDelay:3.0f];
                     
                   }];

  _menuOpened = NO;
}


- (UIScrollView*)makeScrollView:(CGRect)frame {
  
  int actionsCount = [_actions count];
  
  UIScrollView *sc = [[UIScrollView alloc] initWithFrame:frame];
  [sc setBackgroundColor:[UIColor clearColor]];
  
  float contentHeight = actionsCount * BT_HEIGHT;
  
  [sc setContentSize:CGSizeMake(frame.size.width, contentHeight)];
  
  int i = 0;
  for (UIButton *bt in [_actions allValues]) {
    
    [sc addSubview:bt];
    [bt setFrame:CGRectMake(0, i*BT_HEIGHT, frame.size.width, BT_HEIGHT)];
    
    i++;
  }
  
  return [sc autorelease];
  
}

@end
