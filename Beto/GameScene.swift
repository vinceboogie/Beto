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
    
    func getUpSide(node: SCNNode) -> String {
        
        let rotation = node.presentationNode.rotation; //SCNVector4
        var invRotation = rotation; invRotation.w = -invRotation.w; //SCNVector4
        
        let up = SCNVector3Make(0,1,0);
        
        //rotate up by invRotation
        let transform = SCNMatrix4MakeRotation(invRotation.w, invRotation.x, invRotation.y, invRotation.z); //SCNMatrix4
        let glkTransform = SCNMatrix4ToGLKMatrix4(transform); //GLKMatrix4
        let glkUp = SCNVector3ToGLKVector3(up); //GLKVector3
        let rotatedUp = GLKMatrix4MultiplyVector3(glkTransform, glkUp); //GLKVector3
        
        //build box normals (arbitrary order here)
        
        var boxNormals: [GLKVector3] = [GLKVector3(v: (0,0,1)),
            GLKVector3(v: (1,0,0)),
            GLKVector3(v: (0,0,-1)),
            GLKVector3(v: (-1,0,0)),
            GLKVector3(v: (0,1,0)),
            GLKVector3(v: (0,-1,0))]
        
        var bestIndex: Int = 0;
        var maxDot: Float = -1;
        
        for  i in 0...5 {
            let dot: Float = GLKVector3DotProduct( boxNormals[i] , rotatedUp ) ;
            
            if(dot > maxDot){
                maxDot = dot;
                bestIndex = i;
            }
        }
        
        var colorUp = ["Green", "Red", "Yellow", "Blue","Purple", "Cyan"]
        
        print("NodeName=\(node.name) ; FaceUp=\(colorUp[bestIndex]) ") //; Rot=\(node.rotation) ; PresNd.Rot=\(node.presentationNode.rotation)")
        return colorUp[bestIndex];
    }
    
    
    func resetCubes() {
        
        // DELETE: Need to add cubes back to the cubesNode.
        var count = 0.0
    
        for node in geometryNodes.cubesNode.childNodes {
            node.physicsBody?.velocity = SCNVector3(0,0,0)
            node.physicsBody?.angularVelocity = SCNVector4(0,0,0,0)
            node.position = SCNVector3((-0.25*count+0.17),0.15,1.15)
            node.eulerAngles = SCNVector3Make(Float(M_PI/2 * Double(arc4random()%4)), Float(M_PI/2 * Double(arc4random()%4)),Float(M_PI/2 * Double(arc4random()%4)))

            count+=1
        }
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        if shouldCheckMovement {
            for node in geometryNodes.cubesNode.childNodes {
                if node.physicsBody!.isResting || nearlyAtRest(node) {
                    getUpSide(node)
                    node.removeFromParentNode()
                }
            }
            
            if geometryNodes.cubesNode.childNodes.count == 0 {
                shouldCheckMovement = false
                print("ALL 3 Cubes are gone")
                
            }
        }
    }
}
