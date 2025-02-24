import SwiftUI

struct Vector {
    let x: Double
    let y: Double
}

struct FourierComponent: Equatable {
    var n: Int

    var freq: Double = 0
    var radius: CGFloat
    var phase: Double = 0
    var rotation: Double = 0

    init(index: Int, waveType: WaveType = .square) {
        switch waveType {
        case .square:
            n = index * 2 + 1
            freq = Double(2 * index + 1) // coefficient = (2*n) + 1
            radius = 50 * (4 / (Double.pi * Double(2 * index + 1)))

        case .sawtooth:
            n = index + 1
            freq = -Double(n)
            radius = 50 * (2 / (CGFloat(n) * .pi))
        }

        phase = 0.0
        rotation = 0.0
    }

    init(rotation: Double, complex: ComplexEpicycle) {
        n = 0
        freq = Double(complex.frequency)
        phase = Double(complex.phase)
        radius = CGFloat(complex.amplitude)
        self.rotation = rotation
    }

    func position(at time: Double) -> (x: CGFloat, y: CGFloat) {
        let x = radius * cos(freq * time + phase + rotation)
        let y = radius * sin(freq * time + phase + rotation)
        return (x, y)
    }

    func wavePosition(at time: Double) -> (x: CGFloat, y: CGFloat) {
        let x = radius * cos(freq * time)
        let y = radius * sin(freq * time)
        return (CGFloat(x), CGFloat(y))
    }

    mutating func scaleRadius(by factor: CGFloat) {
        radius *= factor
    }
}
