//
//  XXOGame.swift
//  XXO
//
//  Created by Paul Jacobs on 1/23/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

import Foundation

enum player : Int {
    case blank = 0
    case playerX = 1
    case playerO = 2
    case Tie = 3
}

enum boardSpace : Int {
    case upperLeft  = 0
    case upperMid   = 1
    case upperRight = 2
    case centerLeft = 3
    case centerMid  = 4
    case centerRight = 5
    case lowerLeft  = 6
    case lowerMid   = 7
    case lowerRight = 8
}

protocol XXOGameDelegate {
    func playerDidPlayAtSpace(p:player, space:boardSpace)
    func gameDidReset()
    func gameDidLoad()
    func gameOverWithWinner(p:player)
}

@objc class XXOGame
{
    var board : Array<player> = []
    var currentPlayer : player = .blank
    var delegate : XXOGameDelegate
    
    init(d:XXOGameDelegate)
    {
        delegate = d
        resetGame()
    }
    
    func playAtSpace(space:boardSpace) -> player
    {
        if (space.rawValue <= 8 &&
            board[space.rawValue] == .blank &&
            currentPlayer != .blank) {
            
            switch (currentPlayer) {
                case .playerX, .playerO:
                    board[space.rawValue] = currentPlayer;
                    currentPlayer = (currentPlayer == .playerX ? .playerO : .playerX);
                    delegate.playerDidPlayAtSpace(currentPlayer, space: space)
            default:
                // ignore attempts to play when game is not being played
                break
            }
        }
        
        let winningPlayer = checkForWin()
        if (winningPlayer != .blank) {
            delegate.gameOverWithWinner(winningPlayer)
        }
        saveGame()
        return winningPlayer;
    }
    
    
    
    func checkForWin() -> player
    {
        var winningPlayer = player.blank
        
        if (board[boardSpace.upperLeft.rawValue] == board[boardSpace.upperMid.rawValue] &&
            board[boardSpace.upperLeft.rawValue] == board[boardSpace.upperRight.rawValue] &&
            board[boardSpace.upperLeft.rawValue] != player.blank)
        {   // Upper row winner
            winningPlayer = self.board[boardSpace.upperLeft.rawValue]
        } else
        if (board[boardSpace.centerLeft.rawValue] == board[boardSpace.centerMid.rawValue] &&
            board[boardSpace.centerLeft.rawValue] == board[boardSpace.centerRight.rawValue] &&
            board[boardSpace.centerLeft.rawValue] != player.blank)
        {   // Center row winner
            winningPlayer = self.board[boardSpace.centerLeft.rawValue]
        } else
        if (board[boardSpace.lowerLeft.rawValue] == board[boardSpace.lowerMid.rawValue] &&
            board[boardSpace.lowerLeft.rawValue] == board[boardSpace.lowerRight.rawValue] &&
            board[boardSpace.lowerLeft.rawValue] != player.blank)
        {   // Lower row winner
            winningPlayer = self.board[boardSpace.lowerLeft.rawValue]
        } else
        if (board[boardSpace.upperLeft.rawValue] == board[boardSpace.lowerLeft.rawValue] &&
            board[boardSpace.upperLeft.rawValue] == board[boardSpace.centerLeft.rawValue] &&
            board[boardSpace.upperLeft.rawValue] != player.blank)
        {   // Left Col winner
            winningPlayer = self.board[boardSpace.upperLeft.rawValue]
        } else
        if (board[boardSpace.upperMid.rawValue] == board[boardSpace.centerMid.rawValue] &&
            board[boardSpace.upperMid.rawValue] == board[boardSpace.lowerMid.rawValue] &&
            board[boardSpace.upperMid.rawValue] != player.blank)
        {   // Middle Col winner
            winningPlayer = self.board[boardSpace.upperMid.rawValue]
        } else
        if (board[boardSpace.upperRight.rawValue] == board[boardSpace.lowerRight.rawValue] &&
            board[boardSpace.upperRight.rawValue] == board[boardSpace.centerRight.rawValue] &&
            board[boardSpace.upperRight.rawValue] != player.blank)
        {   // Right Col winner
            winningPlayer = self.board[boardSpace.upperRight.rawValue]
        } else
        if (board[boardSpace.upperLeft.rawValue] == board[boardSpace.lowerRight.rawValue] &&
            board[boardSpace.upperLeft.rawValue] == board[boardSpace.centerMid.rawValue] &&
            board[boardSpace.upperLeft.rawValue] != player.blank)
        {   // Diagonal Upper Left <-> Lower Right Winner
            winningPlayer = self.board[boardSpace.upperLeft.rawValue]
        } else
        if (board[boardSpace.upperRight.rawValue] == board[boardSpace.lowerLeft.rawValue] &&
            board[boardSpace.upperRight.rawValue] == board[boardSpace.centerMid.rawValue] &&
            board[boardSpace.upperRight.rawValue] != player.blank)
        {   // Diagonal Upper Right <-> Lower Left Winner
            winningPlayer = self.board[boardSpace.upperRight.rawValue]
        } else if (( // had to break up this expression because swift can't handle it as one piece yet.
            board[0] != player.blank &&
            board[1] != player.blank ) && (
            board[2] != player.blank &&
            board[3] != player.blank ) && (
            board[4] != player.blank &&
            board[5] != player.blank ))
        {
            if (board[6] != player.blank &&
                board[7] != player.blank &&
                board[8] != player.blank )
            { // Tie
                winningPlayer = player.Tie
            }
        } else {
            winningPlayer = player.blank
        }
        
        return winningPlayer
    }
    
    func resetGame()
    {
        board = [   .blank, .blank, .blank,
                    .blank, .blank, .blank,
                    .blank, .blank, .blank, ];
        currentPlayer = ( arc4random()%2==0 ? player.playerO : player.playerX);
        delegate.gameDidReset()
        saveGame()
    }
    
    func saveGame()
    {
        var saveBoard : [Int] = []
        let def = NSUserDefaults.standardUserDefaults()

        for index in 0..<9 {
            saveBoard.append(board[index].rawValue)
        }
        
        def.setObject(saveBoard, forKey: "board")
        def.setInteger(currentPlayer.rawValue, forKey: "currentPlayer")
        def.synchronize()
    }
    
    func loadGame()
    {
        var pre_board : [Int] = []
        let def = NSUserDefaults.standardUserDefaults()
        pre_board = def.objectForKey("board") as [Int]
        if (pre_board.count == 9) {
            for index in 0..<9 {
                board[index] = player(rawValue: index)!
            }
            currentPlayer = player(rawValue: def.integerForKey("currentPlayer"))!
        } else {
            resetGame()
        }
        delegate.gameDidLoad()
    }
    
}