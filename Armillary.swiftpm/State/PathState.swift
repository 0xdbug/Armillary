//
//  PathState.swift
//  Astrocycle
//
//  Created by dbug on 1/20/25.
//

import SwiftUI

class PathState: ObservableObject {
    @Published var config: EpicycleConfig
    @Published var stopped: Bool = false
    @Published var time: Double = 0
    @Published var scale = 1
    
    @Published var pathManager: PathManager = .init()
    @Published var fourier: [ComplexEpicycle] = []

    @Published var xValues = [Double]()
    @Published var yValues = [Double]()

    // custom drawing
    let minimumDrawingDistance: CGFloat = 10 // pixels
    @Published var currentLine = Line()
    @Published var lines: [Line] = []
    @Published var isDrawing: Bool = false
    @Published var lastPoint: CGPoint?

    @Published private var currentPath = ""
    
    init(config: EpicycleConfig, stopped: Bool, epicycles _: Int = 1, scale: Int = 1, path: String) {
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
            .map { FourierComponent(rotation: 0.0, complex: fourierResult[$0]) }
            .sorted { $1.radius < $0.radius }

        pathManager = PathManager(fourierComponents: components)
    }

    public func updatePathFromDrawing() {
        let complexPoints = zip(xValues, yValues).map { x, y in
            ComplexNumber(real: Float(x), imaginary: Float(y))
        }
        let fourierResult = DFT.discreteFourierTransform(signal: complexPoints)

        fourier = fourierResult

        let components = (0 ..< fourierResult.count)
            .map { FourierComponent(rotation: 0.0, complex: fourierResult[$0]) }
            .sorted { $1.radius < $0.radius }

        pathManager = PathManager(fourierComponents: components)

        xValues.removeAll()
        yValues.removeAll()
    }

    func updateConfig(_ newConfig: EpicycleConfig) {
        config = newConfig
//        updatePath(currentPath)
    }

    public func startDrawing() {
        xValues.removeAll()
        yValues.removeAll()

        pathManager.signalPath = []
        time = 0
        isDrawing = true
        fourier = [ComplexEpicycle]()
        lines.removeAll()
    }

    public func stopDrawing() {
        pathManager.signalPath = []
        time = 0
        isDrawing = false
        updatePath(currentPath)
        lines.removeAll()
    }
}
