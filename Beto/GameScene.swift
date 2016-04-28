//
//  GameScene.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import SceneKit

class GameScene: SCNScene, SCNSceneRendererDelegate {
    var geometryNodes: GeometryNodes!
    var shouldCheckMovement = false
    
    var cubeRestHandler: ((Color)->())?
    var endGameplayHandler: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        geometryNodes = GeometryNodes()
        geometryNodes.addNodesTo(rootNode)
    }
    
    func nearlyAtRest(node: SCNNode) -> Bool {
        if node.physicsBody!.isResting {
            return true
        }
        
        let dx = Float((node.physicsBody?.velocity.x)!)
        let dy = Float((node.physicsBody?.velocity.y)!)
        let dz = Float((node.physicsBody?.velocity.z)!)

        let speed = sqrtf(dx*dx+dy*dy+dz*dz)
        
        let x = Float((node.physicsBody?.angularVelocity.x)!)
        let y = Float((node.physicsBody?.angularVelocity.y)!)
        let z = Float((node.physicsBody?.angularVelocity.z)!)
        
        let angularSpeed = sqrtf(x*x+y*y+z*z)

        return (speed < 0.001 || angularSpeed < 0.9)
    }
    
    func getWinningColor(node: SCNNode) -> Color {
        let rotation: SCNVector4 = node.presentationNode.rotation
        var invRotation: SCNVector4 = rotation
        invRotation.w = -invRotation.w
        
        let up = SCNVector3Make(0,1,0)
        
        let transform: SCNMatrix4 = SCNMatrix4MakeRotation(invRotation.w, invRotation.x, invRotation.y, invRotation.z)
        let glkTransform: GLKMatrix4 = SCNMatrix4ToGLKMatrix4(transform)
        let glkUp: GLKVector3 = SCNVector3ToGLKVector3(up)
        let rotatedUp: GLKVector3 = GLKMatrix4MultiplyVector3(glkTransform, glkUp)
        
        var boxNormals: [GLKVector3] = [GLKVector3(v: (0,0,1)),
                                        GLKVector3(v: (1,0,0)),
                                        GLKVector3(v: (0,0,-1)),
                                        GLKVector3(v: (-1,0,0)),
                                        GLKVector3(v: (0,1,0)),
                                        GLKVector3(v: (0,-1,0))]
        
        var winningIndex: Int = 0
        var maxDot: Float = -1
        
        for  i in 0...5 {
            let dot: Float = GLKVector3DotProduct( boxNormals[i] , rotatedUp )
            
            if (dot > maxDot) {
                maxDot = dot
                winningIndex = i
            }
        }
        
        var colors = [Color.Yellow, Color.Cyan, Color.Purple, Color.Blue, Color.Red, Color.Green]
        
        return colors[winningIndex]
    }
    
    func renderer(renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: NSTimeInterval) {
        if shouldCheckMovement {
            shouldCheckMovement = false
            
            for node in geometryNodes.cubesNode.childNodes {
                if nearlyAtRest(node) && !node.hasActions && !node.hidden {
                    let winningColor = getWinningColor(node)
                    cubeRestHandler!(winningColor)
                    
                    let sequence = SCNAction.sequence([SCNAction.fadeOutWithDuration(0.75),
                        SCNAction.hide()])
                    node.runAction(sequence)
                }
                
                if !node.hidden {
                    shouldCheckMovement = true
                }
            }
            
            if !shouldCheckMovement {
                endGameplayHandler!()
            }
        }
    }
}
