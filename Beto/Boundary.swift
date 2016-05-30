//
//  Boundary.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SceneKit

class Boundary {
    private let planeScalar: CGFloat = 2

    private let invisiPlaneFront: SCNNode
    private let invisiPlaneBack: SCNNode
    private let invisiPlaneLeft: SCNNode
    private let invisiPlaneRight: SCNNode
    private let invisiPlaneTop: SCNNode
    private let boundary: SCNNode
    
    init() {
        invisiPlaneFront = SCNNode()
        invisiPlaneBack = SCNNode()
        invisiPlaneLeft = SCNNode()
        invisiPlaneRight = SCNNode()
        invisiPlaneTop = SCNNode()
        boundary = SCNNode()
        
        setProperties(invisiPlaneFront)
        setProperties(invisiPlaneBack)

        invisiPlaneLeft.rotation = SCNVector4(0, 1, 0, Float(M_PI_2))
        setProperties(invisiPlaneLeft)

        invisiPlaneRight.rotation = SCNVector4(0, 1 , 0, Float(-M_PI_2))
        setProperties(invisiPlaneRight)
        
        invisiPlaneTop.rotation = SCNVector4(1, 0, 0, Float(M_PI_2))
        setProperties(invisiPlaneTop)
    }
    
    func setProperties(plane: SCNNode) {
        let planeOpacity:CGFloat = 0.0
        
        plane.geometry = SCNBox(width: planeScalar * 2, height: planeScalar * 2, length: 0.05, chamferRadius: 0)
        plane.opacity = planeOpacity
        plane.physicsBody = SCNPhysicsBody.staticBody()
    }

    func addNodesTo(parentNode:SCNNode) {
        let planePositionScalar: Float = Float(planeScalar)
        
        invisiPlaneFront.position = SCNVector3(0, 0, 0.9 * planePositionScalar)
        invisiPlaneBack.position = SCNVector3(0, 0, -0.80 * planePositionScalar)
        invisiPlaneLeft.position = SCNVector3(-planePositionScalar / 2, 0, 0)
        invisiPlaneRight.position = SCNVector3(planePositionScalar / 2, 0, 0)
        invisiPlaneTop.position = SCNVector3(0, planePositionScalar, 0)

        boundary.addChildNode(invisiPlaneFront)
        boundary.addChildNode(invisiPlaneBack)
        boundary.addChildNode(invisiPlaneLeft)
        boundary.addChildNode(invisiPlaneRight)
        boundary.addChildNode(invisiPlaneTop)
        
        parentNode.addChildNode(boundary)
        
    }
}
