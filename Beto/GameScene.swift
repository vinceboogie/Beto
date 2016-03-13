//
//  GameScene.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import SceneKit

class GameScene: SCNScene, SCNSceneRendererDelegate {
    var geometryNodes = GeometryNodes()
    var shouldCheckMovement = false
    
    override init() {
        super.init()
        
        geometryNodes.addNodesTo(rootNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nearlyAtRest(node: SCNNode) -> Bool {
        let dx = Float((node.physicsBody?.velocity.x)!)
        let dy = Float((node.physicsBody?.velocity.y)!)
        let dz = Float((node.physicsBody?.velocity.z)!)

        let speed = sqrtf(dx*dx+dy*dy+dz*dz)
        
        let x = Float((node.physicsBody?.angularVelocity.x)!)
        let y = Float((node.physicsBody?.angularVelocity.y)!)
        let z = Float((node.physicsBody?.angularVelocity.z)!)
        
        let angularSpeed = sqrtf(x*x+y*y+z*z)

        return (speed < 0.01 && angularSpeed < 0.5)
    }
    
    func getUpSide(node: SCNNode) {
        //            var rotation = node.rotation; //SCNVector4
        //            var invRotation = rotation; invRotation.w = -invRotation.w; //SCNVector4
        //
        //            var up = SCNVector3Make(0,1,0);
        //
        //            //rotate up by invRotation
        //            var transform = SCNMatrix4MakeRotation(invRotation.w, invRotation.x, invRotation.y, invRotation.z); //SCNMatrix4
        //            var glkTransform = SCNMatrix4ToGLKMatrix4(transform); //GLKMatrix4
        //            var glkUp = SCNVector3ToGLKVector3(up); //GLKVector3
        //            var rotatedUp = GLKMatrix4MultiplyVector3(glkTransform, glkUp); //GLKVector3
        //
        //            //build box normals (arbitrary order here)
        //            var boxNormals =    [ [[0,0,1]],
        //                                  [[1,0,0]],
        //                                  [[0,0,-1]],
        //                                  [[-1,0,0]],
        //                                  [[0,1,0]],
        //                                  [[0,-1,0]] ] //GLKVector3
        //
        //        var bestIndex: Int = 0;
        //        var maxDot: Float = -1;
        
        
        //This section is not working - need to understand whats going on here
        //            for  i in 0...5 {
        //                var dot: Float = GLKVector3DotProduct(boxNormals[i], rotatedUp);
        //                if(dot > maxDot){
        //                    maxDot = dot;
        //                    bestIndex = i;
        //                }
        //            }
        //
        //            return bestIndex;
    }
    
    
    func resetCubes() {
        // DELETE: Need to add cubes back to the cubesNode.
    
        var count = 0.0
    
        for node in geometryNodes.cubesNode.childNodes {
            node.physicsBody?.velocity = SCNVector3(0,0,0)
            node.physicsBody?.angularVelocity = SCNVector4(0,0,0,0)
            node.position = SCNVector3((-0.25*count+0.17),0.15,1.15)
            node.rotation = SCNVector4(Float(arc4random()%20),Float(arc4random()%20),Float(arc4random()%20),Float(arc4random()%20))
                
            count++
        }
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        if shouldCheckMovement {
            for node in geometryNodes.cubesNode.childNodes {
                if node.physicsBody!.isResting || nearlyAtRest(node) {
                    node.removeFromParentNode()
                }
            }
            
            if geometryNodes.cubesNode.childNodes.count == 0 {
                shouldCheckMovement = false
            }
        }
    }
}
