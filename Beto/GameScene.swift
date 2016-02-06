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
    let betSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)

    
    var betHandler: ((Bet) -> ())?
    
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
        
        // DELETE: Adjust position?
        let layerPosition = CGPoint( x: -SquareSize * CGFloat(Columns) / 2, y: -SquareSize * 1.3)

        boardLayer.position = layerPosition
        gameLayer.addChild(boardLayer)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touch = touches.first!
        let location = touch.locationInNode(boardLayer)
            
        let (success, column, row) = convertPoint(location)
        
        if success {
            if let square = board.squareAtColumn(column, row: row) {
                square.bet++
                
                // DELETE: Create function for label update
                runAction(betSound)
                square.label!.hidden = false
                square.label!.text = "\(square.bet)"

            }
        }
        
    }
    
    func addSpritesForSquares(squares: Array2D<Square>) {
        for row in 0..<Rows {
            for column in 0..<Columns {
                let sprite = SKSpriteNode(imageNamed: squares[column, row]!.squareColor.squareColor)
                sprite.position = pointForColumn(squares[column, row]!.column, row: squares[column, row]!.row)
                boardLayer.addChild(sprite)
                squares[column, row]?.sprite = sprite
                
                let label = SKLabelNode()
                label.text = "0"
                label.hidden = true
                sprite.addChild(label)
                squares[column, row]?.label = label
                
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
}
