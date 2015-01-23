//
//  XXOGame.m
//  XXO
//
//  Created by Paul Jacobs on 1/19/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import "XXOGameObjC.h"

#pragma mark -

@implementation XXOGameObjC

#pragma mark Setup
- (instancetype)initWithDelegate:(id<XXOGameDelegate>)del
{
    self = [super init];
    if (self) {
        self.delegate = del;
        // if game was interrupted, load from storage.
        [self resetGame];
    }
    return self;
}


#pragma mark Game Actions
- (player)playAtSpace:(boardSpace)spaceNumber
{
    if (spaceNumber <= 8 && [self.board[spaceNumber] integerValue] == blank && self.currentPlayer != blank) {
        if (self.currentPlayer == playerX) {
            //            self.board[spaceNumber] = [NSNumber numberWithInt:playerX];
            [self.board setObject:[NSNumber numberWithInt:playerX] atIndexedSubscript:spaceNumber];
            self.currentPlayer = playerO;
            [self.delegate player:playerX didPlayAtSpace:spaceNumber];
        } else if (self.currentPlayer == playerO) {
            //self.board[spaceNumber] = [NSNumber numberWithInt:playerO];
            [self.board setObject:[NSNumber numberWithInt:playerO] atIndexedSubscript:spaceNumber];
            self.currentPlayer = playerX;
            [self.delegate player:playerO didPlayAtSpace:spaceNumber];
        }
    }
    
    player winningPlayer = [self checkForWin];
    if (winningPlayer != blank) {
        [self.delegate gameOverWithWinner:winningPlayer];
    }
    [self saveGame];
    return winningPlayer;
}

- (player)checkForWin
{
    player winningPlayer = blank;
    if (!self.board) {
        return winningPlayer;
    }
    if ([self.board[upperLeft] isEqualToNumber: self.board[upperMid]] &&
        [self.board[upperLeft] isEqualToNumber:self.board[upperRight]] &&
        ![self.board[upperLeft] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        // Upper Row Winner
        winningPlayer = (player)[self.board[upperLeft] integerValue];
    } else
    if ([self.board[centerLeft] isEqualToNumber: self.board[centerMid]] &&
        [self.board[centerLeft] isEqualToNumber:self.board[centerRight]] &&
        ![self.board[centerLeft] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        // Center Row Winner
        winningPlayer = (player)[self.board[centerLeft] integerValue];
    } else
    if ([self.board[lowerLeft] isEqualToNumber: self.board[lowerMid]] &&
        [self.board[lowerLeft] isEqualToNumber:self.board[lowerRight]] &&
        ![self.board[lowerLeft] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        //  Lower Row Winner
        winningPlayer = (player)[self.board[lowerLeft] integerValue];
    } else

    if ([self.board[upperLeft] isEqualToNumber: self.board[lowerLeft]] &&
        [self.board[upperLeft] isEqualToNumber:self.board[centerLeft]] &&
        ![self.board[upperLeft] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        // Left Col Winner
        winningPlayer = (player)[self.board[upperLeft] integerValue];
    } else
    if ([self.board[upperMid] isEqualToNumber: self.board[centerMid]] &&
        [self.board[upperMid] isEqualToNumber:self.board[lowerMid]] &&
        ![self.board[upperMid] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        // Middle Col Winner
        winningPlayer = (player)[self.board[upperMid] integerValue];
    } else
    if ([self.board[upperRight] isEqualToNumber: self.board[lowerRight]] &&
        [self.board[upperRight] isEqualToNumber:self.board[centerRight]] &&
        ![self.board[upperRight] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        // Right Col Winner
        winningPlayer = (player)[self.board[upperRight] integerValue];
    } else

    if ([self.board[upperLeft] isEqualToNumber: self.board[lowerRight]] &&
        [self.board[upperLeft] isEqualToNumber:self.board[centerMid]] &&
        ![self.board[upperLeft] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        // Diagonal Upper Left <-> Lower Right Winner
        winningPlayer = (player)[self.board[upperLeft] integerValue];
    } else
    if ([self.board[upperRight] isEqualToNumber: self.board[lowerLeft]] &&
        [self.board[upperRight] isEqualToNumber:self.board[centerMid]] &&
        ![self.board[upperRight] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        // Diagonal Upper Right <-> Lower Left Winner
        winningPlayer = (player)[self.board[upperRight] integerValue];
    } else
    if (self.board &&
        ![self.board[upperLeft] isEqualToNumber:[NSNumber numberWithInt:blank]] &&
        ![self.board[upperMid] isEqualToNumber:[NSNumber numberWithInt:blank]] &&
        ![self.board[upperRight] isEqualToNumber:[NSNumber numberWithInt:blank]] &&
        ![self.board[centerLeft] isEqualToNumber:[NSNumber numberWithInt:blank]] &&
        ![self.board[centerMid] isEqualToNumber:[NSNumber numberWithInt:blank]] &&
        ![self.board[centerRight] isEqualToNumber:[NSNumber numberWithInt:blank]] &&
        ![self.board[lowerLeft] isEqualToNumber:[NSNumber numberWithInt:blank]] &&
        ![self.board[lowerMid] isEqualToNumber:[NSNumber numberWithInt:blank]] &&
        ![self.board[lowerRight] isEqualToNumber:[NSNumber numberWithInt:blank]]) {
        // Tie
        winningPlayer = Tie;
    } else {
        winningPlayer = winningPlayer;
    }
    return winningPlayer;
}

- (void)resetGame
{
    self.board = [@[] mutableCopy];
    for (int i = 0; i<9;i++) {
        [((NSMutableArray*)self.board) addObject:[NSNumber numberWithInt:blank]];
    }
    self.currentPlayer = (arc4random()%2==0 ? playerO : playerX);
    if (self.delegate) {
        [self.delegate gameDidReset];
    }
    [self saveGame];
}

- (void)saveGame
{
    // Save game data to app storage
    [[NSUserDefaults standardUserDefaults] setObject:self.board forKey:@"board"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.currentPlayer] forKey:@"currrentPlayer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadGame
{
    // Load game data from app storage
    NSMutableArray *pre_board = [[NSUserDefaults standardUserDefaults] objectForKey:@"board"];
    if ([pre_board isKindOfClass:[NSArray class]] && pre_board.count == 9) {
        self.board = [pre_board mutableCopy];
        self.currentPlayer = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currrentPlayer"] integerValue];
        if (self.delegate) {
            [self.delegate gameDidLoad];
        }
    } else {
        [self resetGame];
    }
}


-(void)dealloc
{
    self.board = nil;
    self.delegate = nil;
}


@end
