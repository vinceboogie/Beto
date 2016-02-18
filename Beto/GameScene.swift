//
//  GameScene.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import SceneKit

class GameScene: SCNScene {
    var camera = SCNNode()
    
    
    override init() {
        super.init()
        
        camera.camera = SCNCamera()
        camera.position = SCNVector3Make(0, 3, 0)
        camera.eulerAngles = SCNVector3Make(Float(-M_PI/2), 0, 0)
        camera.light = SCNLight()
        camera.light?.type = SCNLightTypeAmbient
        
        rootNode.addChildNode(camera)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
