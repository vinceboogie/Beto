//
//  Cube.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SceneKit

class Cube: SCNNode {
    
    init(name: String, position: SCNVector3, cubeMaterials: [SCNMaterial], size: CGFloat) {
        super.init()
        
        self.name = name
        self.position = position
        
        self.geometry = SCNBox(width: size, height: size, length: size, chamferRadius: size/6)
        self.eulerAngles = SCNVector3Make(Float(M_PI/2 * Double(arc4random()%4)), Float(M_PI/2 * Double(arc4random()%4)),Float(M_PI/2 * Double(arc4random()%4)))
        self.geometry!.materials = cubeMaterials
        
        self.physicsBody = SCNPhysicsBody.dynamicBody()
        self.physicsBody?.mass = CGFloat(10)
        self.physicsBody?.angularDamping = CGFloat(0.5)   //default 0.1
        self.physicsBody?.rollingFriction = CGFloat(1.0)  //default 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNodeTo(parentNode: SCNNode) {
        parentNode.addChildNode(self)
    }
}

