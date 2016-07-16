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
        
        /*** Determine cube face ***/
        
        GameData.setPayBonusStatus()
        
        if GameData.shouldPayBonus {
            yellowFace = "doubleYellowFace"
            cyanFace = "doubleCyanFace"
            purpleFace = "doublePurpleFace"
            blueFace = "doubleBlueFace"
            redFace = "doubleRedFace"
            greenFace = "doubleGreenFace"
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
        
        /*** Determine cube count ***/
        
        let count = 3 + GameData.getBonusDice()
        var cubeSize: CGFloat = 0.33
        
        if count == 6 {
            cubeSize = 0.28
        }
    
        for num in 1...count {
            let xoffset = CGFloat(num % 3)
            let xposition: CGFloat = -0.2 + (0.2 * xoffset)
                        
            var yposition: CGFloat = 0.15
            
            if num > 3 {
                yposition = 1.15
            }
            
            let position = SCNVector3(xposition, yposition, 1.15)
            let cube = Cube(name: "cube\(num)", position: position, cubeMaterials: cubeMaterials, size: cubeSize)
            
            cube.addNodeTo(cubesNode)
        }
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
