//
//  Components.swift
//  Astrocycle
//
//  Created by dbug on 1/1/25.
//

import SceneKit
import SwiftUI

struct Line {
    var points = [CGPoint]()
    var color: Color = .yellow
    var lineWidth: Double = 1.0
}

enum Render {
    case wave
    case path
}

enum WaveType {
    case square
    case sawtooth
}

struct EpicycleConfig {
    let startingRadius: CGFloat = 100 * (4 / .pi)
    let circleOpacity: Double
    let orbiterSize: CGFloat
    let lineWidth: CGFloat

    let circleColor: Color
    var orbiterColor: Color
    
    var firstOrbiterColor: Color = Color(.clear)
    var lastOrbiterColor: Color = Color(.clear)
    
    var waveColor: Color
    var radiusColor: Color
    let pathColor: Color

    var showOrbiter: Bool = false
    var showWave: Bool = true
    var showRadius: Bool = false
    var showCircle: Bool = false
    var showWaveConnector: Bool = false
    var showPath: Bool = true
    
    var epicycles: Int = 1

    var isDrawing: Bool = false

    var waveTranslate: Double = 0.0
    
    var restart: Bool = true

    var animatableData: Double {
        get { waveTranslate }
        set { waveTranslate = newValue }
    }

    static let `default` = EpicycleConfig(
        circleOpacity: 0.3,
        orbiterSize: 8,
        lineWidth: 1.5,
        circleColor: Color(.red),
        orbiterColor: Color(.green),
        firstOrbiterColor: Color(.white),
        lastOrbiterColor: Color(.white),
        waveColor: Color(.blue),
        radiusColor: Color(.green),
        pathColor: Color(.yellow)
    )
}

struct ComplexEpicycle {
    let real: Float
    let imaginary: Float
    let frequency: Float
    let amplitude: Float
    let phase: Float
}

struct ComplexNumber {
    var real: Float
    var imaginary: Float

    func multiply(with other: ComplexNumber) -> ComplexNumber {
        let resultReal = real * other.real - imaginary * other.imaginary
        let resultImaginary = real * other.imaginary + imaginary * other.real
        return ComplexNumber(real: resultReal, imaginary: resultImaginary)
    }

    mutating func add(_ other: ComplexNumber) {
        real += other.real
        imaginary += other.imaginary
    }
}

enum DFT {
    static func discreteFourierTransform(signal: [ComplexNumber]) -> [ComplexEpicycle] {
        let N = signal.count
        var fourierComponents = [ComplexEpicycle](
            repeating: ComplexEpicycle(
                real: 0,
                imaginary: 0,
                frequency: 0,
                amplitude: 0,
                phase: 0
            ),
            count: N
        )

        for k in 0 ..< N {
            var sum = ComplexNumber(real: 0.0, imaginary: 0.0)

            for n in 0 ..< N {
                let phi = (2.0 * .pi * Double(k * n)) / Double(N)
                let rotationFactor = ComplexNumber(
                    real: cos(Float(phi)),
                    imaginary: -Float(sin(phi))
                )
                sum.add(signal[n].multiply(with: rotationFactor))
            }

            sum.real /= Float(Double(N))
            sum.imaginary /= Float(Double(N))

            let frequency = Double(k)
            let amplitude = sqrt(sum.real * sum.real + sum.imaginary * sum.imaginary)
            let phase = atan2(sum.imaginary, sum.real)

            fourierComponents[k] = ComplexEpicycle(
                real: Float(sum.real),
                imaginary: Float(sum.imaginary),
                frequency: Float(frequency),
                amplitude: Float(amplitude),
                phase: Float(phase)
            )
        }

        return fourierComponents
    }
}

struct EpicycleConfig3D: Equatable {
    let startingRadius: Float = 50 * (4 / .pi)
    let circleOpacity: Float
    let orbiterSize: Float
    let lineWidth: Float

    let circleColor: SCNMaterial
    let orbiterColor: SCNMaterial
    let pathColor: SCNMaterial

    var showOrbiter: Bool = true
    var showWave: Bool = true
    var showPath: Bool = true
    var showRadius: Bool = false
    var showCircle: Bool = true

    static let `default` = EpicycleConfig3D(
        circleOpacity: 0.5,
        orbiterSize: 8,
        lineWidth: 1.5,
        circleColor: {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.black.withAlphaComponent(0.4)
            return material
        }(),
        orbiterColor: {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.green
            return material
        }(),
        pathColor: {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.black.withAlphaComponent(0.8)
            return material
        }()
    )
    
    static let defaultWhite = EpicycleConfig3D(
        circleOpacity: 0.5,
        orbiterSize: 8,
        lineWidth: 1.5,
        circleColor: {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white.withAlphaComponent(0.4)
            return material
        }(),
        orbiterColor: {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.green
            return material
        }(),
        pathColor: {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
            //            material.lightingModel = .physicallyBased
            return material
        }()
    )
    
}
