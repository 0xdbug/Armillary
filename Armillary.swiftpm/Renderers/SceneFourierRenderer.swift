//
//  SceneFourierRenderer.swift
//  Armillary
//
//  Created by dbug on 2/7/25.
//

import SceneKit
import SwiftUI

class SceneFourierRenderer: NSObject, ObservableObject, SCNSceneRendererDelegate {
    @ObservedObject private var state: PathState3D
    
    let scene: SCNScene = .init()
    
    private var epicyclesNode: SCNNode = .init()
    private var lineGeometries: [SCNGeometry] = []
    private var lineNodes: [SCNNode] = []
    private var orbiterNode: SCNNode?
    private var pathNode: SCNNode = .init()
    private var circleNodes: [SCNNode] = []
    
    private var texture = ""
    private var animation: Bool
    private var cameraVariation: Int
    
    init(state: PathState3D, texture: String, animation: Bool = true, cameraVariation: Int = 1) {
        self.state = state
        self.texture = texture
        self.animation = animation
        self.cameraVariation = cameraVariation
        super.init()
        setupScene()
    }
    
    func updateState(state: PathState3D, texture: String) {
        self.state = state
        self.texture = texture
        updateOrbiterTexture()
    }
    
    private func updateOrbiterTexture() {
        if let orbiter = orbiterNode?.geometry as? SCNSphere {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: texture)
            material.roughness.contents = 0.6
            material.metalness.contents = 0.0
            material.ambient.contents = UIColor.white.withAlphaComponent(0.3)
            orbiter.materials = [material]
        }
    }
    
    private func createLineGeometry(from points: [SCNVector3], radius: CGFloat = 0.001, edges: Int = 8) -> SCNGeometry? {
        guard points.count >= 2 else { return nil }
        
        let vertices = points.map { SCNVector3(x: $0.x, y: $0.y, z: $0.z) }
        let vertexSource = SCNGeometrySource(vertices: vertices)
        
        var indices: [Int32] = []
        for i in 0..<(vertices.count - 1) {
            indices.append(Int32(i))
            indices.append(Int32(i + 1))
        }
        
        let element = SCNGeometryElement(
            indices: indices,
            primitiveType: .line
        )
        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
        
        return geometry
    }
    
    private func setupScene() {
        scene.rootNode.addChildNode(epicyclesNode)
        
        setupCamera()
        
        let earth = SCNSphere(radius: 0.12)
        let earthMaterial = SCNMaterial()
        earthMaterial.diffuse.contents = UIImage(named: "2k_earth_daymap.jpg")
        earthMaterial.roughness.contents = 0.5
        earthMaterial.metalness.contents = 0.1
        earthMaterial.ambient.contents = UIColor.white.withAlphaComponent(0.3)
        earth.materials = [earthMaterial]
        let earthNode = SCNNode(geometry: earth)
        earthNode.position = SCNVector3(0, 0, 0)
        
        let clouds = SCNSphere(radius: 0.1205)
        let cloudMaterial = SCNMaterial()
        cloudMaterial.diffuse.contents = UIImage(named: "2k_earth_clouds.jpg")
        cloudMaterial.transparent.contents = UIImage(named: "2k_earth_clouds.jpg")
        cloudMaterial.transparency = 0.5
        cloudMaterial.blendMode = .add
        clouds.materials = [cloudMaterial]
        let cloudNode = SCNNode(geometry: clouds)
        earthNode.addChildNode(cloudNode)
        
        earthNode.eulerAngles = SCNVector3(
            x: Float.pi / 2,
            y: Float.pi / 12,
            z: 0
        )
        
        let earthRotation = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(2.0 * Double.pi), duration: 10.0)
        let repeatEarthRotation = SCNAction.repeatForever(earthRotation)
        earthNode.runAction(repeatEarthRotation)
        
        scene.rootNode.addChildNode(earthNode)
        
        if state.config.showCircle {
            circleNodes = state.pathManager.fourierComponents.map { component in
                let circle = SCNTorus(
                    ringRadius: CGFloat(component.radius * CGFloat(state.scale)),
                    pipeRadius: 0.006
                )
                circle.firstMaterial = state.config.circleColor
                
                let node = SCNNode(geometry: circle)
                node.eulerAngles.x = .pi / 2
                epicyclesNode.addChildNode(node)
                return node
            }
        }
        
        let orbiter = SCNSphere(radius: 0.08)
        let orbiterMaterial = SCNMaterial()
        orbiterMaterial.diffuse.contents = UIImage(named: texture)
        orbiterMaterial.roughness.contents = 0.6
        orbiterMaterial.metalness.contents = 0.0
        orbiterMaterial.ambient.contents = UIColor.white.withAlphaComponent(0.3)
        orbiter.materials = [orbiterMaterial]
        orbiterNode = SCNNode(geometry: orbiter)
        orbiterNode?.name = "orbiter"
        
        orbiterNode?.eulerAngles = SCNVector3(
            x: Float.pi / 2,
            y: Float.pi / 12,
            z: 0
        )
        
        let rotationAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(2.0 * Double.pi), duration: 2.0)
        let repeatRotation = SCNAction.repeatForever(rotationAction)
        orbiterNode?.runAction(repeatRotation)
        
        epicyclesNode.addChildNode(orbiterNode!)
        epicyclesNode.addChildNode(pathNode)
    }
    
    private func setupCamera() {
        let camera = SCNCamera()
        camera.wantsDepthOfField = false
        camera.wantsHDR = false
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        camera.fieldOfView = 40
        
        switch cameraVariation {
            case 1:
                cameraNode.position = SCNVector3(x: 0, y: -4, z: 0.5)
                cameraNode.eulerAngles = SCNVector3(x: Float.pi/2.2, y: 0, z: 0)
                
            case 2:
                cameraNode.position = SCNVector3(x: 0, y: -5.3, z: 1.8)
                cameraNode.eulerAngles = SCNVector3(x: Float.pi/2.5, y: 0, z: 0)
                
            default:
                cameraNode.position = SCNVector3(x: 0, y: -4, z: 0.5)
                cameraNode.eulerAngles = SCNVector3(x: Float.pi/2.2, y: 0, z: 0)
        }
        
        if animation {
            let positionAnimation = CABasicAnimation(keyPath: "position")
            positionAnimation.fromValue = NSValue(scnVector3: cameraNode.position)
            positionAnimation.toValue = NSValue(scnVector3: SCNVector3(x: 0, y: 0, z: 5))
            positionAnimation.duration = 30
            positionAnimation.fillMode = .forwards
            positionAnimation.isRemovedOnCompletion = false
            positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            let rotationAnimation = CABasicAnimation(keyPath: "eulerAngles")
            rotationAnimation.fromValue = NSValue(scnVector3: cameraNode.eulerAngles)
            rotationAnimation.toValue = NSValue(scnVector3: SCNVector3(x: 0, y: 0, z: 0))
            rotationAnimation.duration = 30
            rotationAnimation.fillMode = .forwards
            rotationAnimation.isRemovedOnCompletion = false
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            cameraNode.addAnimation(positionAnimation, forKey: "position")
            cameraNode.addAnimation(rotationAnimation, forKey: "rotation")
        }
        
        scene.rootNode.addChildNode(cameraNode)
    }
    
    
    func updateSceneForConfig(_ config: EpicycleConfig3D) {
        if config.showCircle && circleNodes.isEmpty {
            circleNodes = state.pathManager.fourierComponents.map { component in
                let circle = SCNTorus(
                    ringRadius: CGFloat(component.radius * CGFloat(state.scale)),
                    pipeRadius: 0.006
                )
                circle.firstMaterial = config.circleColor
                
                let node = SCNNode(geometry: circle)
                node.eulerAngles.x = .pi / 2
                epicyclesNode.addChildNode(node)
                return node
            }
        } else if !config.showCircle {
            circleNodes.forEach { $0.removeFromParentNode() }
            circleNodes.removeAll()
        }
        
        lineNodes.forEach { $0.isHidden = !config.showRadius }
        
        orbiterNode?.isHidden = !config.showOrbiter
        if config.showOrbiter {
            if let geometry = orbiterNode?.geometry as? SCNSphere {
                geometry.radius = CGFloat(config.orbiterSize * 0.01)
            }
        }
        
        pathNode.isHidden = !config.showPath
        if config.showPath {
            pathNode.geometry?.firstMaterial = config.pathColor
        }
    }
}

extension SceneFourierRenderer {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        state.time += (2.0 * .pi) / Double(state.fourier.count)
        
        var currentPos = SCNVector3Zero
        
        for (index, component) in state.pathManager.fourierComponents.enumerated() {
            let prevPos = currentPos
            let pos = component.position(at: Double(state.time))
            currentPos = SCNVector3(
                x: prevPos.x + Float(pos.x) * Float(state.scale),
                y: prevPos.y + Float(pos.y) * Float(state.scale),
                z: 0
            )
            
            if state.config.showCircle && index < circleNodes.count {
                circleNodes[index].position = prevPos
            }
            
            if state.config.showRadius {
                if index >= lineNodes.count {
                    let lineGeometry = createLineGeometry(from: [prevPos, currentPos], radius: 0.001)
                    let lineNode = SCNNode(geometry: lineGeometry)
                    lineGeometry?.firstMaterial = state.config.pathColor
                    lineNodes.append(lineNode)
                    epicyclesNode.addChildNode(lineNode)
                } else {
                    let lineGeometry = createLineGeometry(from: [prevPos, currentPos], radius: 0.001)
                    lineNodes[index].geometry = lineGeometry
                }
            }
        }
        
        orbiterNode?.position = currentPos
        
        state.pathManager.updatePath(time: Float(state.time))
        if !state.pathManager.signalPath.isEmpty {
            let scaledPath = state.pathManager.signalPath.map {
                SCNVector3(x: $0.x * Float(state.scale), y: $0.y * Float(state.scale), z: -$0.z)
            }
            
            if state.config.showPath {
                pathNode.isHidden = false
                if let pathGeometry = createLineGeometry(from: scaledPath, radius: 0.007, edges: 12) {
                    pathGeometry.firstMaterial = state.config.pathColor
                    pathNode.geometry = pathGeometry
                }
            } else {
                pathNode.isHidden = true
            }
        }
    }
}
