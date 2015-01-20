//
//  GameViewController.m
//  XXO
//
//  Created by Paul Jacobs on 1/19/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    
    return scene;
}

@end

#pragma mark -

@implementation GameViewController : UIViewController
#pragma mark ViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.showDebugInfo = NO;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    if (self.showDebugInfo) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
    }
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    self.scene = [GameScene unarchiveFromFile:@"GameScene"];
    //    self.scene.scaleMode = SKSceneScaleModeResizeFill;
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    self.scene.vc = self; // **********
    
    // Present the scene.
    [skView presentScene:self.scene];
    
    
    // Load Game Model
    self.game = [[XXOGame alloc] initWithDelegate:self];
    [self.game loadGame];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark Game Actions

- (IBAction)resetGameButtonPressed
{
    [self.game resetGame];
}

- (void)currentPlayerPlayedAtSpace:(boardSpace)spaceNumber
{
    [self.game playAtSpace:spaceNumber];
}

#pragma mark Game Delegate Callbacks
- (void)player:(player)player didPlayAtSpace:(boardSpace)spaceNumber
{
    [((GameScene*)((SKView*)self.view).scene) setBoardSpace:spaceNumber to:player];
        self.turnIndicator.text = [NSString stringWithFormat:@"%@'s Turn",(self.game.currentPlayer==playerO ? @"O" : @"X")];

}

- (void)gameDidReset
{
    [self gameDidLoad];
    
    [self.scene resetBoard];
    
}

- (void)gameDidLoad
{
    if (self.game.currentPlayer == blank) {
        self.turnIndicator.text = @"Tap to Start (O's Turn)";
    } else {
        self.turnIndicator.text = [NSString stringWithFormat:@"%@'s Turn",(self.game.currentPlayer==playerO ? @"O" : @"X")];
    }
    
}

- (void)gameOverWithWinner:(player)winningPlayer
{
    if (winningPlayer == Tie) {
        self.turnIndicator.text = [NSString stringWithFormat:@"Tie, Everyone Wins/Loses!"];        
    } else {
        self.turnIndicator.text = [NSString stringWithFormat:@"%@ Wins!",(winningPlayer==playerO ? @"O" : @"X")];
    }
    self.game.currentPlayer = blank;
}

@end
