//
//  SceneRenderer.swift
//  Astrocycle
//
//  Created by dbug on 1/19/25.
//

import SceneKit
import SwiftUI

struct SceneRenderer: UIViewRepresentable {
    var height: CGFloat
    var width: CGFloat
    
    @Binding var selectedPlanet: Planets
    @StateObject private var renderer: SceneFourierRenderer
    
    private var animation: Bool
    private var cameraVariation: Int
    
    init(width: CGFloat, height: CGFloat, selectedPlanet: Binding<Planets>, animation: Bool = true, cameraVariation: Int = 1) {
        self.height = height
        self.width = width
        self.animation = animation
        self.cameraVariation = cameraVariation
        
        self._selectedPlanet = selectedPlanet
        _renderer = StateObject(wrappedValue: SceneFourierRenderer(
            state: selectedPlanet.wrappedValue.state,
            texture: selectedPlanet.wrappedValue.texture,
            animation: animation,
            cameraVariation: cameraVariation
        ))
    }
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        scnView.scene = renderer.scene
        scnView.backgroundColor = .clear
        scnView.allowsCameraControl = true
        scnView.antialiasingMode = .multisampling2X
        
        scnView.isPlaying = true
        scnView.loops = true
        scnView.delegate = renderer
        scnView.preferredFramesPerSecond = 20
        
        return scnView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        if scnView.scene !== renderer.scene {
            scnView.scene = renderer.scene
        }
        scnView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        renderer.updateState(state: selectedPlanet.state, texture: selectedPlanet.texture)
    }
}


