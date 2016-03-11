//
//  Boundary.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class Boundary {
    
    var planeScalar: CGFloat = 2
    
    let invisiPlaneFront = SCNNode()
    let invisiPlaneLeft = SCNNode()
    let invisiPlaneRight = SCNNode()
    let invisiPlaneBack = SCNNode()
    let invisiPlaneTop = SCNNode()
    let boundary = SCNNode()
    
    init() {
        let planePositionScalar = Float(planeScalar)

        invisiPlaneFront.position = SCNVector3(0, 0, 0.9 * planePositionScalar)
        invisiPlaneFront.name = "invisiPlaneFront"
        setProperties(invisiPlaneFront)
        
        invisiPlaneLeft.position = SCNVector3(-planePositionScalar/2, 0, 0)
        invisiPlaneLeft.rotation = SCNVector4(0, 1, 0, Float(M_PI_2))
        invisiPlaneLeft.name = "invisiPlaneLeft"
        setProperties(invisiPlaneLeft)
        
        invisiPlaneRight.position = SCNVector3(planePositionScalar/2, 0, 0)
        invisiPlaneRight.rotation = SCNVector4(0, 1 , 0, Float(-M_PI_2))
        invisiPlaneRight.name = "invisiPlaneRight"
        setProperties(invisiPlaneRight)
        
        invisiPlaneBack.position = SCNVector3(0, 0, -0.80*planePositionScalar)
        invisiPlaneBack.name = "invisiPlaneBack"
        setProperties(invisiPlaneBack)
        
        invisiPlaneTop.position = SCNVector3(0, planePositionScalar, 0)
        invisiPlaneTop.rotation = SCNVector4(1, 0, 0, Float(M_PI_2))
        invisiPlaneTop.name = "invisiPlaneTop"
        setProperties(invisiPlaneTop)
        
    }
    
    func setProperties(plane: SCNNode) {
        let planeOpacity:CGFloat = 0.0
        
        plane.geometry = SCNBox(width: planeScalar * 2, height: planeScalar * 2, length: 0.05, chamferRadius: 0)
        plane.opacity = planeOpacity
        plane.physicsBody = SCNPhysicsBody.staticBody()
    }

    func addNodesTo(parentNode:SCNNode) {
        boundary.addChildNode(invisiPlaneBack)
        boundary.addChildNode(invisiPlaneFront)
        boundary.addChildNode(invisiPlaneLeft)
        boundary.addChildNode(invisiPlaneRight)
        boundary.addChildNode(invisiPlaneTop)
        
        parentNode.addChildNode(boundary)
        
    }
}
