//
//  GameViewController.h
//  XXO
//

//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

#import "GameBoard.h"
#import "XXOGame.h"

@interface GameViewController : UIViewController <XXOGameDelegate>

@property (assign) BOOL showDebugInfo;
@property (assign) BOOL soundsEnabled;
@property (strong, nonatomic) IBOutlet UILabel *turnIndicator;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) XXOGame *game;
@property (strong, nonatomic) GameBoard *board;
@property (strong, nonatomic) AVAudioPlayer *audioPlayerObj;

- (IBAction)resetGameButtonPressed;
- (void)currentPlayerPlayedAtSpace:(boardSpace)spaceNumber;

@end
