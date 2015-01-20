//
//  GameScene.m
//  XXO
//
//  Created by Paul Jacobs on 1/19/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import "GameBoard.h"
#import "GameViewController.h"

@implementation GameBoard

SKTexture *textureX;
SKTexture *textureO;
SKTexture *textureBlank;

-(void)didMoveToView:(SKView *)view {
    self.board = @[ [self childNodeWithName:@"0"],
                    [self childNodeWithName:@"1"],
                    [self childNodeWithName:@"2"],

                    [self childNodeWithName:@"3"],
                    [self childNodeWithName:@"4"],
                    [self childNodeWithName:@"5"],
                    
                    [self childNodeWithName:@"6"],
                    [self childNodeWithName:@"7"],
                    [self childNodeWithName:@"8"]];
    
    textureX = [SKTexture textureWithImageNamed:@"X"];
    textureO = [SKTexture textureWithImageNamed:@"O"];
    textureBlank = [SKTexture textureWithImageNamed:@"blank"];
}

-(void)resetBoard
{
    for (boardSpace space = 0; space < 9; space++) {
        [self setBoardSpace:space to:blank];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKSpriteNode *sprite = (SKSpriteNode*)[self nodeAtPoint:location];

        if (! [sprite isKindOfClass:[SKSpriteNode class]] && sprite.name.length != 1) {
            // Not a sprite
            return;
        }

        if (sprite.texture != textureBlank) {
            // Already filled in
            return;
        }

        NSInteger spaceNum = [sprite.name integerValue];
        if (spaceNum >=0 && spaceNum <= 8) {
            [self.vc currentPlayerPlayedAtSpace:(boardSpace)spaceNum];
        }
    }
}

-(void)setBoardSpace:(boardSpace)spaceNum to:(player)playerValue
{
    SKSpriteNode *theSpace = self.board[spaceNum];
    
    if (playerValue == playerO) {
        [theSpace setTexture:textureO];
        [theSpace runAction:[SKAction sequence:@[[SKAction scaleBy:5 duration:0.00], [SKAction scaleBy:0.2 duration:0.6]]]];
    } else if (playerValue == playerX) {
        [theSpace setTexture:textureX];
        [theSpace runAction:[SKAction sequence:@[[SKAction scaleBy:5 duration:0.00], [SKAction scaleBy:0.2 duration:0.6]]]];
    } else {
        [theSpace setTexture:textureBlank];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {

}

@end
