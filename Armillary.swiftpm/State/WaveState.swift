//
//  WaveState.swift
//  Astrocycle
//
//  Created by dbug on 1/20/25.
//

import SwiftUI

class WaveState: ObservableObject {
    @Published var config: EpicycleConfig
    @Published var stopped: Bool = false
    @Published var time: Double = 0
    @Published var scale = 1

    @Published var waveType: WaveType = .square
    @Published var fourierComponents: [FourierComponent] = [FourierComponent(index: 0)]

    init(config: EpicycleConfig, stopped: Bool, scale: Int = 1, waveType: WaveType) {
        self.config = config
        self.stopped = stopped
        self.scale = scale
        self.waveType = waveType
        
        updateFourierComponents()
    }

    func updateFourierComponents() {
        fourierComponents = (0 ..< config.epicycles).map { index -> FourierComponent in
            var component = FourierComponent(index: index, waveType: self.waveType)
            component.scaleRadius(by: CGFloat(self.scale))
            return component
        }
    }

    func updateConfig(_ newConfig: EpicycleConfig) {
        config = newConfig
        updateFourierComponents()
    }
    
    func renderNewWave(type: WaveType) {
        self.waveType = type
        updateFourierComponents()
    }
    
}
