//
//  GameViewController.m
//  XXO
//
//  Created by Paul Jacobs on 1/19/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

#import "GameViewController.h"
#import "GameBoard.h"

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
    self.soundsEnabled = NO;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    if (self.showDebugInfo) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
    }
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    self.board = [GameBoard unarchiveFromFile:@"GameScene"];
    self.board.scaleMode = SKSceneScaleModeAspectFill;
    self.board.vc = self;
    
    // Present the scene.
    [skView presentScene:self.board];
    
    
    // Load Game Model
    self.game = [[XXOGame alloc] initWithDelegate:self];
    [self.game loadGame];
    self.soundsEnabled = YES;
    
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
    if (self.game.currentPlayer != blank) {
        [self.game playAtSpace:spaceNumber];
    }
}

- (void)playSoundWithOfThisFile:(NSString*)fileNameWithExtension {
    if (self.soundsEnabled) {
        NSString *filePath;
        
        filePath= [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] resourcePath]];
        
        if(!self.audioPlayerObj)
            self.audioPlayerObj = [AVAudioPlayer alloc];
        
        NSURL *acutualFilePath= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",filePath,fileNameWithExtension]];
        
        NSError *error;
        
        self.audioPlayerObj = [self.audioPlayerObj initWithContentsOfURL:acutualFilePath error:&error];
        
        [self.audioPlayerObj play];
    }
}

#pragma mark Game Delegate Callbacks

- (void)player:(player)player didPlayAtSpace:(boardSpace)spaceNumber
{
    [self.board setBoardSpace:spaceNumber to:player];
        self.turnIndicator.text = [NSString stringWithFormat:@"%@'s Turn",
                                   (self.game.currentPlayer==playerO ? @"O" : @"X")];

    switch (arc4random()%2) {
        case 0:
            [self playSoundWithOfThisFile:@"Hit_Hurt12.wav"];
            break;
        case 1:
            [self playSoundWithOfThisFile:@"Hit_Hurt13.wav"];
            break;
        default:
            break;
    }

}

- (void)gameDidReset
{
    if (self.game.currentPlayer == blank) {
        self.turnIndicator.text = @"Tap to Start (O's Turn)";
    } else {
        self.turnIndicator.text = [NSString stringWithFormat:@"%@'s Turn",
                                   (self.game.currentPlayer==playerO ? @"O" : @"X")];
    }
    
    [self.board resetBoard];
    switch (arc4random()%2) {
        case 0:
            [self playSoundWithOfThisFile:@"Reset58.wav"];
            break;
        case 1:
            [self playSoundWithOfThisFile:@"Reset64.wav"];
            break;
        default:
            break;
    }

    
}

- (void)gameDidLoad
{
    if (self.game.currentPlayer == blank) {
        self.turnIndicator.text = @"Tap to Start (O's Turn)";
    } else {
        self.turnIndicator.text = [NSString stringWithFormat:@"%@'s Turn",
                                   (self.game.currentPlayer==playerO ? @"O" : @"X")];
    }
    
    for (int i = 0; i<self.game.board.count; i++) {
        NSNumber *space = self.game.board[i];
        [self.board setBoardSpace:i to:[space integerValue]];
    }
}

- (void)gameOverWithWinner:(player)winningPlayer
{
    if (winningPlayer == Tie) {
        self.turnIndicator.text = [NSString stringWithFormat:@"Tie, Everyone Wins/Loses!"];        
        [self.board destroyBoard];
        [self playSoundWithOfThisFile:@"Win60_louder.wav"];
    } else {
        self.turnIndicator.text = [NSString stringWithFormat:@"%@ Wins!",(winningPlayer==playerO ? @"O" : @"X")];
        [self playSoundWithOfThisFile:@"Win23.wav"];
    }
    self.game.currentPlayer = blank;
}

@end
