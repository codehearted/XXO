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
NSMutableArray *stdBoardPosition;

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
    stdBoardPosition = [@[] mutableCopy];
    for (int i=0;i<9;i++) {
        [stdBoardPosition addObject:
        [NSValue valueWithCGPoint:CGPointMake(((SKSpriteNode*)self.board[i]).position.x,
                                              ((SKSpriteNode*)self.board[i]).position.y)]];
    }

    textureX = [SKTexture textureWithImageNamed:@"X"];
    textureO = [SKTexture textureWithImageNamed:@"O"];
    textureBlank = [SKTexture textureWithImageNamed:@"blank"];
}

-(void)resetBoard
{
    for (boardSpace space = 0; space < 9; space++) {
        [self setBoardSpace:space to:blank];
        //((SKSpriteNode*)self.board[space]).position = [stdBoardPosition[space] CGPointValue];
        [self.board[space] runAction:[SKAction moveTo:[stdBoardPosition[space] CGPointValue] duration:0.8]];
        [((SKSpriteNode*)self.board[space]) runAction:[SKAction rotateToAngle:0 duration:1.1]];
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
        [theSpace runAction:[SKAction sequence:@[[SKAction scaleBy:5 duration:0.00], [SKAction scaleBy:0.2 duration:0.2]]]];
        theSpace.physicsBody = [SKPhysicsBody bodyWithTexture:textureO alphaThreshold:0.2 size:theSpace.size];
        theSpace.physicsBody.pinned = YES;
        theSpace.physicsBody.affectedByGravity = NO;
        theSpace.physicsBody.dynamic = NO;
        theSpace.physicsBody.friction = 0.1;
        theSpace.physicsBody.mass = 18;
        theSpace.physicsBody.charge = 10;
    } else if (playerValue == playerX) {
        [theSpace setTexture:textureX];
        [theSpace runAction:[SKAction sequence:@[[SKAction scaleBy:5 duration:0.00], [SKAction scaleBy:0.2 duration:0.2]]]];
        theSpace.physicsBody = [SKPhysicsBody bodyWithTexture:textureX alphaThreshold:0.2 size:theSpace.size];
        theSpace.physicsBody.pinned = YES;
        theSpace.physicsBody.affectedByGravity = NO;
        theSpace.physicsBody.dynamic = NO;
        theSpace.physicsBody.friction = 0.5;
        theSpace.physicsBody.mass = 10;
        theSpace.physicsBody.charge = 100;
    } else {
        theSpace.physicsBody.pinned = YES;
        theSpace.physicsBody.affectedByGravity = NO;
        theSpace.physicsBody.dynamic = NO;
        [theSpace setTexture:textureBlank];
    }
    
}

-(void)destroyBoard
{
    for (SKSpriteNode *node in self.board) {
        node.physicsBody.pinned = NO;
        node.physicsBody.affectedByGravity = YES;
        node.physicsBody.dynamic = YES;
        [node.physicsBody applyForce:CGVectorMake(1, 10)];
    }
    SKFieldNode *explosionField = ((SKFieldNode*)[self childNodeWithName:@"explosionField"]);
    explosionField.position = CGPointMake(explosionField.position.x + (arc4random() % 200) - 100, explosionField.position.y + (arc4random() % 200) - 100);
    
    
}

-(void)update:(CFTimeInterval)currentTime {

}


@end

