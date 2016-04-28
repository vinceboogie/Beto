//
//  GeometryNodes.swift
//  Beto
//
//  Created by Joseph Pelina on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SceneKit

class GeometryNodes {
    private let boundary: Boundary
    private let cameraNode: SCNNode
    let floorNode: SCNNode
    let cubesNode: SCNNode

    init () {
        cubesNode = SCNNode()
        boundary = Boundary()
        
//        let floorMaterial = SCNMaterial()
//        floorMaterial.diffuse.contents = UIImage(named: "background")!
//        floorMaterial.locksAmbientWithDiffuse = false
        
        // DELETE: Is name needed? Is it referred to?
        floorNode = SCNNode()
        floorNode.name = "Floor"
        floorNode.geometry = SCNBox(width: 2.25, height: 0.5, length: 4, chamferRadius: 0)
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        floorNode.opacity = 0.0
//        floorNode.geometry?.materials = [floorMaterial]
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.eulerAngles = SCNVector3Make(Float(-M_PI/2), 0, 0)
        
        let blueSide = SCNMaterial()
        blueSide.diffuse.contents = UIImage(named: "blueCube")
        blueSide.locksAmbientWithDiffuse = false
        
        let redSide = SCNMaterial()
        redSide.diffuse.contents = UIImage(named: "redCube")
        redSide.locksAmbientWithDiffuse = false
        
        let yellowSide = SCNMaterial()
        yellowSide.diffuse.contents = UIImage(named: "yellowCube")
        yellowSide.locksAmbientWithDiffuse = false
        
        let greenSide = SCNMaterial()
        greenSide.diffuse.contents = UIImage(named: "greenCube")
        greenSide.locksAmbientWithDiffuse = false
        
        let purpleSide = SCNMaterial()
        purpleSide.diffuse.contents = UIImage(named: "purpleCube")
        purpleSide.locksAmbientWithDiffuse = false
        
        let cyanSide = SCNMaterial()
        cyanSide.diffuse.contents = UIImage(named: "cyanCube")
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
        // DELETE: What's the difference between the two?
        floorNode.position = SCNVector3(0, 0, 0)
        cameraNode.position = SCNVector3Make(0, 3.7, 0)

        parentNode.addChildNode(cameraNode)
        parentNode.addChildNode(floorNode)
        parentNode.addChildNode(cubesNode)
     
        boundary.addNodesTo(parentNode)
    }
}
