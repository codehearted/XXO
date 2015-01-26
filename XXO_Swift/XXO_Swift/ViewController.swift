//
//  ViewController.swift
//  XXO_Swift
//
//  Created by Paul Jacobs on 1/25/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, XXOGameDelegate {

    // UI Views
    @IBOutlet var turnIndicator: UILabel!
    @IBOutlet var resetButton: UIButton!
    
    @IBOutlet var A0: UIButton!
    @IBOutlet var A1: UIButton!
    @IBOutlet var A2: UIButton!

    @IBOutlet var B0: UIButton!
    @IBOutlet var B1: UIButton!
    @IBOutlet var B2: UIButton!

    @IBOutlet var C0: UIButton!
    @IBOutlet var C1: UIButton!
    @IBOutlet var C2: UIButton!
    
    var tiles : [UIButton!]

    var blankImage  : UIImage//(named: "blank")
    var xImage      : UIImage//(named: "X")
    var oImage      : UIImage//(named: "O")
    
    // Game Model
    var game: XXOGame!;

    // Settings
    var soundsEnabled : Bool;
    var audioPlayer : AVAudioPlayer?;
    var resetSounds = ["Reset58.wav","Reset64.wav"]
    var playSounds  = ["Hit_Hurt12.wav","Hit_Hurt13.wav"]
    var destroySounds = ["Win60.wav"]
    var winSounds = ["Win23.wav"]
    
    
    
    // Init
    required init(coder aDecoder: NSCoder)
    {
        blankImage = UIImage(named: "blank")!
        xImage = UIImage(named: "X")!
        oImage = UIImage(named: "O")!
        soundsEnabled = true
        tiles = []
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tiles = [A0, A1, A2, B0, B1, B2, C0, C1, C2]
        game = XXOGame(delegate: self)
        game.loadGame()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    @IBAction func resetButtonPressed()
    {
        game.resetGame()
    }
    
    @IBAction func currentPlayerPlayedAtTile(sender:NSObject)
    {
        switch sender {
        case A0:
            currentPlayerPlayedAt(XXOGame.boardSpace.upperLeft)
        case A1:
            currentPlayerPlayedAt(XXOGame.boardSpace.upperMid)
        case A1:
            currentPlayerPlayedAt(XXOGame.boardSpace.upperRight)
        case B0:
            currentPlayerPlayedAt(XXOGame.boardSpace.centerLeft)
        case B1:
            currentPlayerPlayedAt(XXOGame.boardSpace.centerMid)
        case B1:
            currentPlayerPlayedAt(XXOGame.boardSpace.centerRight)
        case C0:
            currentPlayerPlayedAt(XXOGame.boardSpace.lowerLeft)
        case C1:
            currentPlayerPlayedAt(XXOGame.boardSpace.lowerMid)
        case C2:
            currentPlayerPlayedAt(XXOGame.boardSpace.lowerRight)
        default:
            println("Unrecognized tile played upon: \(sender.description)")
            break
        }
    }
    
    
    func currentPlayerPlayedAt(space:XXOGame.boardSpace)
    {
        if (game.currentPlayer != .blank) {
            game.playAtSpace(space)
        }
    }
    
    func playSound(file:NSString)
    {
        if (soundsEnabled) {
            var error : NSError?
            let session = AVAudioSession.sharedInstance()
            
            if !session.setCategory(AVAudioSessionCategoryPlayback, error: &error) {
                println("Could not set session category")
                if let e = error {
                    println("An error occured trying to set AVAudioSession category:\(e.localizedDescription)")
                }
            }

            if !session.setActive(true, error: &error) {
                println("Could not set session active")
                if let e = error {
                    println("An error occured trying to set AVAudioSession active:\(e.localizedDescription)")
                }
            }
            var path = NSBundle.mainBundle().resourcePath
            var soundURL = NSURL(fileURLWithPath:"\(path)/\(file)")
            if let checkedURL = soundURL {
                    var error: NSError?
                    audioPlayer = AVAudioPlayer(contentsOfURL: soundURL, error: &error)
                    if let actualErr = error {
                        println("An error occured trying to play sound \(soundURL):\(error)")
                    } else {
                        audioPlayer!.play()
                    }
            }
            
        }
    }
    
    // Board Control -- these methods used to be in GameBoardViewController
    func setBoardSpace(space:XXOGame.boardSpace, newPlayer:XXOGame.player)
    {
        let spaceNum = space.rawValue
        
        switch newPlayer {
            case .blank:
                tiles[spaceNum].setImage(blankImage, forState: UIControlState.Normal)
            case .playerO:
                tiles[spaceNum].setImage(oImage, forState: UIControlState.Normal)
            case .playerX:
                tiles[spaceNum].setImage(xImage, forState: UIControlState.Normal)
            default:
                break
        }
    }
    
    func resetBoard()
    {
        for spaceNum in 0..<9 {
            setBoardSpace(XXOGame.boardSpace(rawValue:spaceNum)!, newPlayer:XXOGame.player.blank)
        }
    }
    
    func destroyBoard()
    {
        
    }
    
    
    
    // XXOGameDelegate Callbacks
    
    func playerDidPlayAtSpace(player:XXOGame.player, space:XXOGame.boardSpace)
    {
        setBoardSpace(space, newPlayer: player)
        turnIndicator.text = (player == XXOGame.player.playerX ? "O" : "X") + "'s Turn"
        
        let soundNum = Int(arc4random() % UInt32(playSounds.count))
        playSound(playSounds[soundNum])
    }

    func gameDidReset()
    {
        
        if game == nil || game.getCurrentPlayer() == XXOGame.player.blank {
            turnIndicator.text = "Tap to Start (O's Turn)"
        } else {
            let plr = (game.getCurrentPlayer() == XXOGame.player.playerX ? "O" : "X")
            turnIndicator.text = "\(plr)'s Turn"
        }
        
    }

    func gameDidLoad()
    {
        
    }
    
    func gameOverWithWinner(winningPlayer:XXOGame.player) {
        if winningPlayer == .Tie {
            turnIndicator.text = "Tie, Everybody Wins/Loses!"
            destroyBoard()
            
            let soundNum = Int(arc4random() % UInt32(destroySounds.count))
            playSound(destroySounds[soundNum])
        } else {
            let plr = (winningPlayer == XXOGame.player.playerO ? "O" : "X")
            turnIndicator.text = "\(plr) Wins!"

            let soundNum = Int(arc4random() % UInt32(winSounds.count))
            playSound(winSounds[soundNum])
        }
        game.setCurrentPlayer(winningPlayer)
    }


}

