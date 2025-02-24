//
//  PathState3D.swift
//  Astrocycle
//
//  Created by dbug on 1/22/25.
//

import SwiftUI
import SceneKit

class PathState3D: ObservableObject {
    @Published var config: EpicycleConfig3D
    @Published var stopped: Bool = false
    @Published var time: Double = 0
    @Published var scale: Float = 0.01

    @Published var pathManager: PathManager3D = .init()
    @Published var fourier: [ComplexEpicycle] = []

    @Published var xValues = [Double]()
    @Published var yValues = [Double]()

    // custom drawing
    let minimumDrawingDistance: CGFloat = 500 // pixels
    @Published var currentLine = Line()
    @Published var lines: [Line] = []
    @Published var isDrawing: Bool = false
    @Published var lastPoint: CGPoint?

    @Published private var currentPath = ""


    init(config: EpicycleConfig3D, stopped: Bool, epicycles _: Int = 1, scale: Float = 0.01, path: String) {
        self.config = config
        self.stopped = stopped
        self.scale = scale
        currentPath = path
        updatePath(path)
    }

    public func updatePath(_ path: String) {
        time = 0
        let result = PathDataHandler.loadPathData(from: path) ?? ([], [])
        xValues = result.0
        yValues = result.1

        let complexPoints = zip(result.0, result.1).map { ComplexNumber(real: Float($0), imaginary: Float($1)) }
        let fourierResult = DFT.discreteFourierTransform(signal: complexPoints)

        fourier = fourierResult

        let components = (0 ..< fourierResult.count)
            .map { FourierComponent(rotation: Double.pi, complex: fourierResult[$0]) }
            .sorted { $1.radius < $0.radius }

        pathManager = PathManager3D(fourierComponents: components)
    }
    
    func updateConfig(_ newConfig: EpicycleConfig3D) {
        config = newConfig
    }
}
