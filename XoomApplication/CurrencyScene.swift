//
//  CurrencyScene.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import SceneKit

public final class CurrencyScene: SCNScene, SCNSceneRendererDelegate {
    private let currencyRate: Double
    public private(set) var cameraNode: SCNNode!
    
    var cameraPosition = SCNVector3Make(0, 50, 150)
    var lightPosition =  SCNVector3Make(0, 100, 100)
    
    public init(rate: Double) {
        currencyRate = rate
        super.init()
        
        setup()
    }
    
    private func setup() {
        physicsWorld.speed = 2
        physicsWorld.gravity = SCNVector3(0, -18, 0)
        
        let ground = createGround()
        ground.position = SCNVector3(0, 0, 0)
        
        let wall = createWall()
        
        let camera = createCameraNode()
        camera.position = cameraPosition
        
        let ambientLightNode = createAmbientLight()
        
        let lightNode = createLight()
        lightNode.position = lightPosition
        
        rootNode.addChildNode(ground)
        rootNode.addChildNode(wall)
        rootNode.addChildNode(ambientLightNode)
        rootNode.addChildNode(lightNode)
        rootNode.addChildNode(camera)
        
        let constraint = SCNLookAtConstraint(target: rootNode)
        constraint.isGimbalLockEnabled = true
        lightNode.constraints = [constraint]
        
        cameraNode = camera
        
        let leftCoins = 1
        let rightCoins = min(100,max(1,Int(currencyRate)))
        
        let yRange:UInt32 = UInt32.init(truncatingBitPattern: rightCoins)*2
        let xRange:UInt32 = 10
        let zRange:UInt32 = 40
        
        for _ in 0..<leftCoins {
            let coin = createCoin()
            
            let yRand = arc4random() % yRange
            let xRand = arc4random() % xRange
            coin.position = SCNVector3(-26 - Int(xRand), 30 + Int(yRand), 0)
            
            rootNode.addChildNode(coin)
            coin.physicsBody?.applyForce(SCNVector3(0, -20, 0), asImpulse: true)
        }
        
        for _ in 0..<rightCoins {
            let coin = createCoin()
            let yRand = arc4random() % yRange
            let xRand = arc4random() % xRange
            let zRand = arc4random() % zRange
            coin.position = SCNVector3(26 + Int(xRand), 30 + Int(yRand), -Int(zRange/2) + Int(zRand))
            
            rootNode.addChildNode(coin)
            coin.physicsBody?.applyForce(SCNVector3(0, -20, 0), asImpulse: true)
        }
    }
    
    private func createWall() -> SCNNode {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        
        let geometry = SCNPlane()
        geometry.firstMaterial = material
        geometry.width = 50
        geometry.height = 100
        
        let physicsBody = SCNPhysicsBody.static()
        physicsBody.physicsShape = SCNPhysicsShape(geometry: geometry)
        physicsBody.restitution = 0
        
        let node = SCNNode(geometry: geometry)
        node.physicsBody = physicsBody
        node.rotation = SCNVector4(x: 0, y: 1, z: 0, w: 3.14/2)
        return node
    }
    
    private func createGround() -> SCNNode {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        
        let geometry = SCNFloor()
        geometry.firstMaterial = material
        geometry.reflectivity = 0.0
        
        let physicsBody = SCNPhysicsBody.static()
        physicsBody.physicsShape = SCNPhysicsShape(geometry: geometry)
        physicsBody.restitution = 0
        
        let node = SCNNode(geometry: geometry)
        node.physicsBody = physicsBody
        return node
    }
    
    func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.zFar = 1000
        return cameraNode
    }
    
    private func createCoin() -> SCNNode {
        let geometry = SCNCylinder(radius: 8, height: 1)
        
        let material = SCNMaterial()
        material.fresnelExponent = 4
        material.diffuse.contents = UIColor.yellow
        material.locksAmbientWithDiffuse = true
        //material.normal.contents = normalMap
        //material.roughness.contents = normalMap
        material.reflective.contents = UIColor.white
        material.reflective.intensity = 0.1
        material.isDoubleSided = true
        //material.multiply.contents = UIColor(white: 0.9, alpha: 0.6)
        //material.metalness.contents = UIColor.yellow
        geometry.firstMaterial = material
        
        let node = SCNNode(geometry: geometry)
        node.physicsBody = SCNPhysicsBody.dynamic()
        node.physicsBody?.physicsShape = SCNPhysicsShape(geometry: geometry)
        node.physicsBody!.restitution = 0.7
        node.physicsBody!.mass = 150
        node.physicsBody!.friction = 0.8
        node.physicsBody!.damping = 0.1
        
        return node
    }
    
    func createAmbientLight() -> SCNNode {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.temperature = 6000
        ambientLightNode.light!.intensity = 500
        return ambientLightNode
    }
    
    func createLight() -> SCNNode {
        let lightNode = SCNNode()
        //lightNode.orientation = SCNQuaternion(x: 0, y: 0, z: 1, w: 0)
        lightNode.light = SCNLight()
        lightNode.light!.type = .spot
        lightNode.light!.spotInnerAngle = 45
        lightNode.light!.spotOuterAngle = 90
        lightNode.light!.zNear = 0
        lightNode.light!.zFar = 10000
        lightNode.light!.attenuationStartDistance = 50
        lightNode.light!.attenuationEndDistance = 600
        lightNode.light!.shadowRadius = 2
        lightNode.light!.shadowMode = .forward
        lightNode.light!.shadowMapSize = CGSize(width: 5000, height: 5000)
        
        lightNode.light!.shadowColor = UIColor.darkGray.withAlphaComponent(0.7)
        //lightNode.light!.shadowBias = 2
        //lightNode.light!.shadowSampleCount = 2
        lightNode.light!.intensity = 700
        //lightNode.light!.shadowMode = .forward
        lightNode.light!.temperature = 6000
        lightNode.light!.castsShadow = true
        return lightNode
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
