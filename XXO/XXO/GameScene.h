//
//  GameScene.h
//  XXO
//

//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "XXOGame.h"

@class GameViewController;

@interface GameScene : SKScene

@property (strong,nonatomic) NSArray *board;
@property (weak,nonatomic) GameViewController *vc;

-(void)setBoardSpace:(boardSpace)spaceNum to:(player)playerValue;
-(void)resetBoard;

@end
