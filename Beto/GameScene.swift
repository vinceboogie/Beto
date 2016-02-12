//
//  GameScene.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var board: Board!
    
    let SquareSize: CGFloat = 100.0
    let gameLayer = SKNode()
    let boardLayer = SKNode()
    let placeBetSound = SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: false)
    let clearBetSound = SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)
    let winSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let lostSound = SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
    
    var placeBetHandler: ((Bet) -> ())?
    var clearBetsHandler: ((Bet) -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Beto")
        background.position = CGPoint(x: 0.0, y: 160)
        addChild(background)
        
        let betoGray = UIColor(red: 250, green: 250, blue: 250)
        self.backgroundColor = betoGray
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint( x: -SquareSize * CGFloat(Columns) / 2, y: -SquareSize * 1.3)

        boardLayer.position = layerPosition
        gameLayer.addChild(boardLayer)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(boardLayer)
            
        let (success, column, row) = convertPoint(location)
        
        if success {
            let square = board.squareAtColumn(column, row: row)
            let bet = Bet(square: square, betValue: NSUserDefaults().betValue)
            placeBetHandler!(bet)
        }
    }
    
    func addSpritesForSquares(squares: Array2D<Square>) {
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = board.squareAtColumn(column, row: row)
            
                let sprite = SKSpriteNode(imageNamed: square.color.squareSpriteName)
                sprite.position = pointForColumn(column, row: row)
                boardLayer.addChild(sprite)
                square.sprite = sprite
            }
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint( x: CGFloat(column)*SquareSize + SquareSize/2,
            y: CGFloat(row)*SquareSize + SquareSize/2)
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(Columns)*SquareSize && point.y >= 0 && point.y < CGFloat(Rows)*SquareSize {
            return (true, Int(point.x / SquareSize), Int(point.y / SquareSize))
        } else {
            return (false, 0, 0) // invalid location
        }
    }
    
    func animatePlaceBet(bet: Bet, completion: () -> ()) {
        let square = bet.square
        runAction(placeBetSound)
        
        let label = SKLabelNode()
        label.text = "\(square.wager)"
        
        square.sprite?.removeAllChildren()
        square.sprite?.addChild(label)
    }
    
    func animateClearBet(board: Board, completion: () -> ()) {
        
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = board.squareAtColumn(column, row: row)
                square.sprite?.removeAllChildren()
            }
        }
    
        runAction(clearBetSound)
    }
    
    func animateWin(square: Square) {
        runAction(winSound)
    }
    
    func animateLost(square: Square) {
        runAction(lostSound)
        
        let scaleAction = SKAction.scaleTo(0.1, duration: 0.3)
        scaleAction.timingMode = .EaseOut
        
        if let children = square.sprite?.children {
            for child in children {
                child.runAction(SKAction.sequence([scaleAction, SKAction.removeFromParent()]))
            }
        }
    }
}
