//
//  Cube.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SceneKit

class Cube {
    let cube = SCNNode()
    let cubeSize: CGFloat = 0.33
    
    init(name: String, position: CGFloat, cubeMaterials: [SCNMaterial]) {
        cube.name = name
        cube.position = SCNVector3(position, 0.15, 1.15)
        
        cube.geometry = SCNBox (width: cubeSize, height: cubeSize, length: cubeSize, chamferRadius: cubeSize/6)
        cube.eulerAngles = SCNVector3Make(Float(M_PI/2 * Double(arc4random()%4)), Float(M_PI/2 * Double(arc4random()%4)),Float(M_PI/2 * Double(arc4random()%4)))
        cube.opacity = 1.0
        cube.geometry!.materials = cubeMaterials
        
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
