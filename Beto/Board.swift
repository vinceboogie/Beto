//
//  Board.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class Board {
    private let squareSize: CGFloat = 92.0
    
    private let layer: SKNode
    private let scene: BoardScene
    private let boardNode: SKSpriteNode
    private let playButton: ButtonNode
    private let clearButton: ButtonNode
    private let replayButton: ButtonNode
    private let coinVaultButton: ButtonNode
    
    private var squares: [Square]
    private var winningSquares: [Square]
    private var previousBets: [(color: Color, wager: Int)]
    
    init(scene: BoardScene) {
        self.scene = scene
        
        squares = []
        winningSquares = []
        previousBets = []
        
        layer = SKNode()
        
        if UIScreen.mainScreen().bounds.height == 480 {
            layer.setScale(0.84507042) // Custom board scale for iPhone 4 (Screen size: 320 x 480)
        } else {
            layer.setScale(Constant.ScaleFactor)
        }
        
        boardNode = SKSpriteNode(imageNamed: "board")
        boardNode.size = CGSize(width: 300, height: 280)
        
        playButton = ButtonNode(defaultButtonImage: "playButton", activeButtonImage: "playButton_active")
        playButton.size = CGSize(width: 130, height: 40)
        
        clearButton = ButtonNode(defaultButtonImage: "clearButton", activeButtonImage: "clearButton_active")
        clearButton.size = CGSize(width: 130, height: 40)
        
        replayButton = ButtonNode(defaultButtonImage: "replayButton")
        replayButton.size = CGSize(width: 38, height: 39)
        
        coinVaultButton = ButtonNode(defaultButtonImage: "coin\(GameData.betDenomination)")
        coinVaultButton.size = CGSize(width: 38, height: 39)
        
        // Initialize the squares
        
        
        for color in Color.allValues {
            let square = Square(color: color)
            square.size = CGSize(width: squareSize, height: squareSize)
            
            squares.append(square)
        }
    }
    
    func createLayer() -> SKNode {
        // Assign actions
        playButton.action = playButtonPressed
        clearButton.action = clearButtonPressed
        replayButton.action = replayButtonPressed
        coinVaultButton.action = coinVaultButtonPressed
        
        // Designate positions
        boardNode.position = CGPoint(x: 0, y: -80)
        playButton.position = CGPoint(x: (-boardNode.size.width + playButton.size.width) / 2 + Constant.Margin,
                                      y: (-boardNode.size.height + playButton.size.height) / 2 + Constant.Margin)
        clearButton.position = CGPoint(x: (boardNode.size.width - clearButton.size.width) / 2 - Constant.Margin,
                                       y: (-boardNode.size.height + clearButton.size.height) / 2 + Constant.Margin)
        coinVaultButton.position = CGPoint(x: (boardNode.size.width - coinVaultButton.size.width) / 2,
                                           y: (boardNode.size.height + coinVaultButton.size.height + Constant.Margin) / 2)
        replayButton.position = CGPoint(x: (-boardNode.size.width + replayButton.size.width) / 2,
                                        y: (boardNode.size.height + replayButton.size.height + Constant.Margin) / 2)
        
        // Add nodes to boardNode
        boardNode.addChild(playButton)
        boardNode.addChild(clearButton)
        boardNode.addChild(replayButton)
        boardNode.addChild(coinVaultButton)
        
        // Add action to square and add each square to boardNode
        for square in squares {
            square.placeBetHandler = handlePlaceBet
            square.position = pointForPosition(squares.indexOf(square)!)
            boardNode.addChild(square)
        }
        
        // Add boardNode to the layer node
        layer.addChild(boardNode)
        
        return layer
    }
    
    func handlePlaceBet(square: Square) {
        let coinsAvailable = GameData.coins - getWagers()
        
        // Limit selected squares to 3 colors
        if !square.selected && maxColorsSelected() {
            let testNode = SKLabelNode(text: "SELECT UP TO 3 COLORS!")
            testNode.fontSize = 16
            testNode.color = SKColor.blueColor()
            testNode.colorBlendFactor = 1
            testNode.fontName = Constant.FontName
            testNode.blendMode = SKBlendMode.Multiply
            testNode.colorBlendFactor = 0.6
            testNode.position = CGPoint(x: (0), y: (boardNode.size.height) / 2 + Constant.Margin * 2)
            boardNode.addChild(testNode)
            
            let fade = SKAction.fadeOutWithDuration(1.0)
            testNode.runAction(fade)
            
            return
        }
        
        // Check if there are coins available to wager
        if GameData.betDenomination <= coinsAvailable  {
            square.wager += GameData.betDenomination
            
            // In order to safe guard from crashes, we don't subtract the coins
            // from the GameData until after we roll the cubes
            let coins = GameData.coins - getWagers()
            scene.gameHUD.coinsLabel.text = "\(coins)"
            scene.runAction(Audio.placeBetSound)
            
            square.label.hidden = false
            square.label.text = "\(square.wager)"
            square.selected = true
            
        } else {
            scene.runAction(Audio.lostSound)
            
            let testNode = SKLabelNode(text: "NOT ENOUGH COINS!")
            testNode.fontSize = 16
            testNode.color = SKColor.blueColor()
            testNode.colorBlendFactor = 1
            testNode.fontName = Constant.FontName
            testNode.blendMode = SKBlendMode.Multiply
            testNode.colorBlendFactor = 0.6
            testNode.position = CGPoint(x: (0), y: (boardNode.size.height) / 2 + Constant.Margin * 2)
            boardNode.addChild(testNode)
            
            let fade = SKAction.fadeOutWithDuration(1.0)
            testNode.runAction(fade)
        }
    }
    
    func playButtonPressed() {
        if getWagers() > 0 {
            // Reset previousBets
            previousBets = []
            
            // Save bets for the replay button
            for square in squares {
                if square.selected {
                    previousBets.append((color: square.color, wager: square.wager))
                }
            }
            
            scene.presentGameScene()
        }
    }
    
    func replayButtonPressed() {
        for previousBet in previousBets {
            if let index = squares.indexOf(squareWithColor(previousBet.color)) {
                squares[index].wager = previousBet.wager
                squares[index].label.hidden = false
                squares[index].label.text = "\(squares[index].wager)"
                squares[index].selected = true
            }
        }
        
        // In order to safe guard from crashes, we don't subtract the coins
        // from the GameData until after we roll the cubes
        let coins = GameData.coins - getWagers()
        scene.gameHUD.coinsLabel.text = "\(coins)"
    }
    
    func payout(winningColor: Color) -> Bool {
        var winningSquare: Square!
        var didWin = false
        
        // Keep track of winning squares
        for square in squares {
            if square.color == winningColor {
                winningSquare = square
                
                if !winningSquares.contains(winningSquare) {
                    winningSquares.append(winningSquare)
                }
                
                break
            }
        }
        
        // Add winnings
        if winningSquare.wager > 0 {
            GameData.addCoins(winningSquare.wager)
            scene.runAction(Audio.winSound)
            
            didWin = true
            
            // Update labels
            scene.gameHUD.coinsLabel.text = "\(GameData.coins)"
            scene.gameHUD.highscoreLabel.text = "\(GameData.highscore)"
        }
        
        return didWin
    }
    
    func resolveWagers() {
        // Add winning wagers back to GameData.coins, clear the board
        for square in squares {
            if winningSquares.contains(square) {
                GameData.addCoins(square.wager)
            }
            
            let scaleAction = SKAction.scaleTo(0.0, duration: 0.3)
            scaleAction.timingMode = .EaseOut
            square.label.runAction(scaleAction)
            square.label.hidden = true
            
            let restore = SKAction.scaleTo(1.0, duration: 0.3)
            square.label.runAction(restore)
            square.wager = 0
            square.selected = false
            
            // Update labels
            scene.gameHUD.coinsLabel.text = "\(GameData.coins)"
            scene.gameHUD.highscoreLabel.text = "\(GameData.highscore)"
        }
        
        // Reset winning squares
        winningSquares = []
    }
    
    func clearButtonPressed() {
        // reset each square
        for square in squares {
            square.wager = 0
            square.label.hidden = true
            square.selected = false
        }
        
        scene.runAction(Audio.clearBetSound)
        scene.gameHUD.coinsLabel.text = "\(GameData.coins )"
    }
    
    func coinVaultButtonPressed() {
        let coinVault = CoinVault()
        coinVault.changeDenominationHandler = { self.coinVaultButton.changeTexture("coin\(GameData.betDenomination)") }
        
        let vaultLayer = coinVault.createLayer()
        scene.addChild(vaultLayer)
    }
    
    func squareWithColor(color: Color) -> Square! {
        for square in squares {
            if square.color == color {
                return square
            }
        }
        
        // Return nil if square is not found. This code should never execute
        return nil
    }
    
    func pointForPosition(position: Int) -> CGPoint {
        var column = 0
        var row = 0
        
        // Position squares based on a 2x3 grid
        if position <= 2 {
            column = position
        } else  {
            row = 1
            column = position - 3
        }
        
        let squareMargin: CGFloat = 6
        let squareWithMargin = squareSize + squareMargin
        
        let offsetX = -squareWithMargin + (squareWithMargin * CGFloat(column))
        let offsetY = -squareMargin + (squareWithMargin * CGFloat(row))
        
        return CGPoint(x: offsetX, y: -Constant.Margin + offsetY)
    }
    
    func getWagers() -> Int {
        var wagers = 0
        
        for square in squares {
            wagers += square.wager
        }
        
        return wagers
    }
    
    func maxColorsSelected() -> Bool {
        var total = 0
        
        for square in squares {
            if square.selected {
                total += 1
            }
        }
        
        // Max color is 3
        return (total >= 3)
    }
    
    func toggleReplayButton() {
        var wagers = 0
        
        for previousBet in previousBets {
            wagers += previousBet.wager
        }
        
        let coinsAvailable = GameData.coins - wagers
        
        if previousBets.isEmpty || coinsAvailable < 0 {
            replayButton.hidden = true
        } else {
            replayButton.hidden = false
        }
    }
}