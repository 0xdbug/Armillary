//
//  Planets.swift
//  Armillary
//
//  Created by dbug on 2/7/25.
//

import SwiftUI

// possibly the worst thing ive written in this project
enum Planets {
    case mercury
    case mars
    case venus
    case jupiter
    case earth
    case saturn
    case uranus
    case neptune
    
    // not the smartest
    case mercuryWhite
    case marsWhite
    case venusWhite
    case jupiterWhite
    case earthWhite
    case saturnWhite
    case uranusWhite
    case neptuneWhite
    
    var state: PathState3D {
        switch self {
            case .mercury:
                return PathState3D(config: .default, stopped: false, scale: 0.008, path: "mercury_dance")
            case .mars:
                return PathState3D(config: .default, stopped: false, scale: 0.008, path: "mars_dance")
            case .venus:
                return PathState3D(config: .default, stopped: false, scale: 0.008, path: "venus_dance")
            case .jupiter:
                return PathState3D(config: .default, stopped: false, scale: 0.008, path: "jupiter_dance")
            case .earth:
                return PathState3D(config: .default, stopped: false, scale: 0.008, path: "")
            case .saturn:
                return PathState3D(config: .default, stopped: false, scale: 0.008, path: "saturn_dance")
            case .uranus:
                return PathState3D(config: .default, stopped: false, scale: 0.008, path: "uranus_dance")
            case .neptune:
                return PathState3D(config: .default, stopped: false, scale: 0.008, path: "neptune_dance")
            case .mercuryWhite:
                return PathState3D(config: .defaultWhite, stopped: false, scale: 0.008, path: "mercury_dance")
            case .marsWhite:
                return PathState3D(config: .defaultWhite, stopped: false, scale: 0.008, path: "mars_dance")
            case .venusWhite:
                return PathState3D(config: .defaultWhite, stopped: false, scale: 0.008, path: "venus_dance")
            case .jupiterWhite:
                return PathState3D(config: .defaultWhite, stopped: false, scale: 0.008, path: "jupiter_dance")
            case .earthWhite:
                return PathState3D(config: .defaultWhite, stopped: false, scale: 0.008, path: "")
            case .saturnWhite:
                return PathState3D(config: .defaultWhite, stopped: false, scale: 0.008, path: "saturn_dance")
            case .uranusWhite:
                return PathState3D(config: .defaultWhite, stopped: false, scale: 0.008, path: "uranus_dance")
            case .neptuneWhite:
                return PathState3D(config: .defaultWhite, stopped: false, scale: 0.008, path: "neptune_dance")
        }
    }
    
    var texture: String {
        switch self {
            case .mars:
                return "2k_mars.jpg"
            case .mercury:
                return "2k_mercury.jpg"
            case .venus:
                return "2k_venus_atmosphere.jpg"
            case .jupiter:
                return "2k_jupiter.jpg"
            case .earth:
                return "2k_earth_daymap.jpg"
            case .saturn:
                return "2k_saturn.jpg"
            case .uranus:
                return "2k_uranus.jpg"
            case .neptune:
                return "2k_neptune.jpg"
            case .mercuryWhite:
                return "2k_mercury.jpg"
            case .marsWhite:
                return "2k_mars.jpg"
            case .venusWhite:
                return "2k_venus_atmosphere.jpg"
            case .jupiterWhite:
                return "2k_jupiter.jpg"
            case .earthWhite:
                return "2k_earth_daymap.jpg"
            case .saturnWhite:
                return "2k_saturn.jpg"
            case .uranusWhite:
                return "2k_uranus.jpg"
            case .neptuneWhite:
                return "2k_neptune.jpg"
        }
    }
}
