//
//  XXOGame.h
//  XXO
//
//  Created by Paul Jacobs on 1/19/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum player {
    blank = 0,
    playerX = 1,
    playerO = 2,
    Tie = 3
} player;

typedef enum boardSpace {
    upperLeft   = 0,
    upperMid    = 1,
    upperRight  = 2,
    centerLeft  = 3,
    centerMid   = 4,
    centerRight = 5,
    lowerLeft   = 6,
    lowerMid    = 7,
    lowerRight  = 8
} boardSpace;


@protocol XXOGameDelegate <NSObject>
#pragma  mark Delegate Callbacks
- (void)player:(player)player didPlayAtSpace:(boardSpace)spaceNumber;
- (void)gameDidReset;
- (void)gameDidLoad;
- (void)gameOverWithWinner:(player)winningPlayer;
@optional
@end

#pragma mark -
@interface XXOGameObjC : NSObject

#pragma mark Game Data
@property (strong, nonatomic)   NSMutableArray *board;
@property (assign)              player currentPlayer;
@property (weak, nonatomic)     id<XXOGameDelegate> delegate;

#pragma mark Setup
- (instancetype)initWithDelegate:(id<XXOGameDelegate>)del;

#pragma  mark Game Actions
- (player)playAtSpace:(boardSpace)spaceNumber;
- (void)resetGame;
- (void)saveGame;
- (void)loadGame;

@end
