import SceneKit
import SwiftUI

class PathManager: ObservableObject {
    @Published var fourierComponents: [FourierComponent]
    @Published var size: CGSize
    @Published var signalPath: [Vector]
    private let maxWavePoints: Int

    init(fourierComponents: [FourierComponent] = [],
         size: CGSize = CGSize(width: 100, height: 100),
         maxPoints: Int = 1100)
    {
        self.fourierComponents = fourierComponents
        self.size = size
        maxWavePoints = maxPoints
        signalPath = []
    }

    func updatePath(size: CGSize, time: Double) {
        self.size = size

        let point = fourierComponents.reduce((x: CGFloat(0), y: CGFloat(0))) { result, component in
            let pos = component.position(at: time)
            return (x: result.x + pos.x, y: result.y + pos.y)
        }

        let v = Vector(x: point.x + (size.width / 2), y: point.y + (size.height / 2))

        var newPath = signalPath
        newPath.insert(v, at: 0)
        if newPath.count > maxWavePoints {
            newPath.removeLast()
        }
        signalPath = newPath
    }
}

struct PathTransform {
    @Binding var config: EpicycleConfig
    let canvasSize: CGSize
    let canvasContext: GraphicsContext
    @ObservedObject var pathManager: PathManager
    let drawer: EpicyclesRenderer
    let fourierComponents: [FourierComponent]
    let time: Double

    init(config: Binding<EpicycleConfig>,
         canvasSize: CGSize,
         canvasContext: GraphicsContext,
         pathManager: PathManager,
         fourierComponents: [FourierComponent],
         time: Double)
    {
        _config = config
        self.canvasSize = canvasSize
        self.canvasContext = canvasContext
        self.pathManager = pathManager
        drawer = EpicyclesRenderer(mode: .path, size: canvasSize, config: config)
        self.fourierComponents = fourierComponents
        self.time = time
    }

    public func generatePath() {
        let v = drawer.drawEpicycles(context: canvasContext, components: fourierComponents, time: time)
        drawer.drawPath(context: canvasContext, position: CGPoint(x: v.x, y: v.y), signalPath: pathManager.signalPath)
    }
}

class PathManager3D {
    var fourierComponents: [FourierComponent]
    var signalPath: [SCNVector3]
    private let maxWavePoints: Int

    init(
        fourierComponents: [FourierComponent] = [],
        maxPoints: Int = 500
    ) {
        self.fourierComponents = fourierComponents
        maxWavePoints = maxPoints
        signalPath = []
    }

    func updatePath(time: Float) {
        let point = fourierComponents.reduce((x: Float(0), y: Float(0))) { result, component in
            let pos = component.position(at: Double(time))
            return (x: result.x + Float(pos.x), y: result.y + Float(pos.y))
        }

        let v = SCNVector3(
            x: point.x,
            y: point.y,
            z: 0
        )

        var newPath = signalPath
        newPath.insert(v, at: 0)
        if newPath.count > maxWavePoints {
            newPath.removeLast()
        }

        for (index, _) in newPath.enumerated() {
            newPath[index].z = Float(index) * 0.00005
        }

        signalPath = newPath
    }
}
