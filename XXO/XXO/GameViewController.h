//
//  GameViewController.h
//  XXO
//

//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "XXOGame.h"

@interface GameViewController : UIViewController <XXOGameDelegate>

@property (assign) BOOL showDebugInfo;
@property (strong, nonatomic) IBOutlet UILabel *turnIndicator;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) XXOGame *game;

- (IBAction)resetGameButtonPressed;
- (void)currentPlayerPlayedAtSpace:(boardSpace)spaceNumber;

@end
