//
//  Cube.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class Cube {
    let cube = SCNNode()
    let cubeSize: CGFloat = 0.33
    
    init(name: String, position: CGFloat) {
        cube.name = name
        cube.position = SCNVector3(position, 0.15, 1.15)
        
        cube.geometry = SCNBox (width: cubeSize, height: cubeSize, length: cubeSize, chamferRadius: cubeSize/5)
        cube.eulerAngles = SCNVector3Make(Float(M_PI/2 * Double(arc4random()%4)), Float(M_PI/2 * Double(arc4random()%4)),Float(M_PI/2 * Double(arc4random()%4)))
        cube.categoryBitMask = 2
        
        let blueSide = SCNMaterial()
        blueSide.diffuse.contents = UIImage(named: "BlueCubeFace")
        blueSide.locksAmbientWithDiffuse = false
        
        let redSide = SCNMaterial()
        redSide.diffuse.contents = UIImage(named: "RedCubeFace")
        redSide.locksAmbientWithDiffuse = false
        
        let yellowSide = SCNMaterial()
        yellowSide.diffuse.contents = UIImage(named: "YellowCubeFace")
        yellowSide.locksAmbientWithDiffuse = false
        
        let greenSide = SCNMaterial()
        greenSide.diffuse.contents = UIImage(named: "GreenCubeFace")
        greenSide.locksAmbientWithDiffuse = false
        
        let purpleSide = SCNMaterial()
        purpleSide.diffuse.contents = UIImage(named: "PurpleCubeFace")
        purpleSide.locksAmbientWithDiffuse = false
        
        let cyanSide = SCNMaterial()
        cyanSide.diffuse.contents = UIImage(named: "CyanCubeFace")
        cyanSide.locksAmbientWithDiffuse = false
        
        cube.geometry!.materials = [greenSide, redSide, yellowSide, blueSide, purpleSide, cyanSide]
        cube.physicsBody = SCNPhysicsBody.dynamicBody()
        cube.physicsBody?.affectedByGravity = true
        cube.physicsBody?.mass = CGFloat(10)
        cube.physicsBody?.restitution = CGFloat(0.5)      //default 0.5
        cube.physicsBody?.angularDamping = CGFloat(0.5)   //default 0.1
        cube.physicsBody?.rollingFriction = CGFloat(1.0)  //default 0.0
        cube.physicsBody?.friction = CGFloat(0.5)         //default 0.0
    }
    
    func addNodesTo(parentNode:SCNNode) {
        parentNode.addChildNode(cube)
    }
}
