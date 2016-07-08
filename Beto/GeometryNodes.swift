//
//  GeometryNodes.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SceneKit
import UIKit

class GeometryNodes {
    private let boundary: Boundary
    private let cameraNode: SCNNode
    let floorNode: SCNNode
    let cubesNode: SCNNode
    
    var yellowFace = "defaultYellowFace"
    var cyanFace = "defaultCyanFace"
    var purpleFace = "defaultPurpleFace"
    var blueFace = "defaultBlueFace"
    var redFace = "defaultRedFace"
    var greenFace = "defaultGreenFace"
    
    init () {
        cubesNode = SCNNode()
        boundary = Boundary()
        
        floorNode = SCNNode()
        floorNode.geometry = SCNBox(width: 2.25, height: 0.5, length: 4, chamferRadius: 0)
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        floorNode.opacity = 0.0
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.eulerAngles = SCNVector3Make(Float(-M_PI/2), 0, 0)
        
        if GameData.bonusPayoutEnabled() {
            yellowFace = "doubleYellowFace"
            cyanFace = "doubleCyanFace"
            purpleFace = "doublePurpleFace"
            blueFace = "doubleBlueFace"
            redFace = "doubleRedFace"
            greenFace = "doubleGreenFace"
            
            GameData.shouldPayBonus = true
        } else {
            GameData.shouldPayBonus = false
        }
        
        
        let blueSide = SCNMaterial()
        blueSide.diffuse.contents = UIImage(named: blueFace)
        blueSide.locksAmbientWithDiffuse = false
        
        let redSide = SCNMaterial()
        redSide.diffuse.contents = UIImage(named: redFace)
        redSide.locksAmbientWithDiffuse = false
        
        let yellowSide = SCNMaterial()
        yellowSide.diffuse.contents = UIImage(named: yellowFace)
        yellowSide.locksAmbientWithDiffuse = false
        
        let greenSide = SCNMaterial()
        greenSide.diffuse.contents = UIImage(named: greenFace)
        greenSide.locksAmbientWithDiffuse = false
        
        let purpleSide = SCNMaterial()
        purpleSide.diffuse.contents = UIImage(named: purpleFace)
        purpleSide.locksAmbientWithDiffuse = false
        
        let cyanSide = SCNMaterial()
        cyanSide.diffuse.contents = UIImage(named: cyanFace)
        cyanSide.locksAmbientWithDiffuse = false
        
        let cubeMaterials = [yellowSide, cyanSide, purpleSide, blueSide, redSide, greenSide]
        
        let cube1 = Cube(name: "cube1", position: -0.2, cubeMaterials: cubeMaterials)
        let cube2 = Cube(name: "cube2", position: 0.0, cubeMaterials: cubeMaterials)
        let cube3 = Cube(name: "cube3", position: 0.2, cubeMaterials: cubeMaterials)
        
        cube1.addNodesTo(cubesNode)
        cube2.addNodesTo(cubesNode)
        cube3.addNodesTo(cubesNode)
    }
    
    func addNodesTo(parentNode:SCNNode) {
        floorNode.position = SCNVector3(0, 0, 0)
        cameraNode.position = SCNVector3(0, 3.7, 0)

        parentNode.addChildNode(cameraNode)
        parentNode.addChildNode(floorNode)
        parentNode.addChildNode(cubesNode)
     
        boundary.addNodesTo(parentNode)
    }
}
