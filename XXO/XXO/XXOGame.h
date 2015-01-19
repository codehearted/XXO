//
//  XXOGame.h
//  XXO
//
//  Created by Paul Jacobs on 1/19/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XXOGameDelegate <NSObject>
@optional


@end

@interface XXOGame : NSObject

@property (strong, nonatomic)   NSArray *board;
@property (assign)              NSNumber *currentPlayer; // 0 for Os, 1 for X.
@property (weak, nonatomic)     id<XXOGameDelegate> delegate;

@end
