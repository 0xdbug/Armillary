import SwiftUI

class WaveManager: ObservableObject {
    @Published var wave: [CGFloat] = []
    private let maxWavePoints: Int

    init(maxPoints: Int = 250) {
        maxWavePoints = maxPoints
    }

    func updateWave(components: [FourierComponent], time: Double, canvasHeight: CGFloat) {
        let newY = components
            .map { $0.wavePosition(at: time).y }
            .reduce(0, +)

        wave.insert(newY + canvasHeight / 2, at: 0)
        if wave.count > maxWavePoints {
            wave.removeLast()
        }
    }
}

struct WaveTransform {
    @Binding var config: EpicycleConfig
    let canvasSize: CGSize
    let canvasContext: GraphicsContext
    let waveManager: WaveManager
    let drawer: EpicyclesRenderer
    let fourierComponents: [FourierComponent]
    let time: Double

    init(
        config: Binding<EpicycleConfig>,
        canvasSize: CGSize,
        canvasContext: GraphicsContext,
        waveManager: WaveManager,
        fourierComponents: [FourierComponent],
        time: Double
    ) {
        _config = config
        self.canvasSize = canvasSize
        self.canvasContext = canvasContext
        self.waveManager = waveManager
        drawer = EpicyclesRenderer(mode: .wave, size: canvasSize, config: config)
        self.fourierComponents = fourierComponents
        self.time = time
    }

    public func generateWave() {
        let startingX = canvasSize.width / 4
        let center = CGPoint(x: startingX, y: canvasSize.height / 2)

        canvasContext.fill(Path(CGRect(origin: .zero, size: canvasSize)),
                           with: .color(.black.opacity(0.001)))

        let finalPos = drawFourierComponents(context: canvasContext, center: center)

        drawer.drawWave(
            context: canvasContext,
            lastPoint: finalPos,
            wave: waveManager.wave,
            radius: config.startingRadius,
            withConnector: config.showWaveConnector,
            visibleWave: config.showWave
        )
    }

    private func drawFourierComponents(context: GraphicsContext, center: CGPoint) -> CGPoint {
        var currentPos = CGPoint.zero

        for component in fourierComponents {
            let prevPos = currentPos
            let pos = component.wavePosition(at: time)
            currentPos.x += pos.x
            currentPos.y += pos.y

            let circleCenter = CGPoint(
                x: center.x + currentPos.x,
                y: center.y + currentPos.y
            )

            if config.showCircle {
                drawer.drawCircle(
                    context: context,
                    center: CGPoint(x: center.x + prevPos.x, y: center.y + prevPos.y),
                    radius: component.radius
                )
            }

            if config.showRadius {
                drawer.drawRadius(
                    context: context,
                    from: CGPoint(x: center.x + prevPos.x, y: center.y + prevPos.y),
                    to: circleCenter, radius: component.radius
                )
            }
            if config.showOrbiter {
                drawer.drawOrbiter(context: context, center: circleCenter, radius: component.radius)
            }
        }

        return CGPoint(x: center.x + currentPos.x, y: center.y + currentPos.y)
    }
}
