import SceneKit
import SwiftUI

struct EpicyclesRenderer {
    
    @Binding private var config: EpicycleConfig
    private let mode: Render
    
    private let size: CGSize
    private let center: CGPoint
    
    init(mode: Render, size: CGSize, config: Binding<EpicycleConfig>) {
        self.mode = mode
        self.size = size
        _config = config
        
        switch mode {
            case .wave:
                center = CGPoint(x: size.width / 4, y: size.height / 2)
            case .path:
                center = CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }
    
    func drawCircle(context: GraphicsContext, center: CGPoint, radius: CGFloat) {
        let lineWidth = min(sqrt(radius) * 0.15, config.lineWidth)
        context.stroke(
            Path(ellipseIn: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            )),
            with: .color(config.circleColor.opacity(config.circleOpacity)),
            lineWidth: lineWidth
        )
    }
    
    func drawOrbiter(context: GraphicsContext,
                     center: CGPoint,
                     radius: CGFloat,
                     color: Color = .clear) {
        
        var orbiterColor = color
        if orbiterColor == .clear {
            orbiterColor = config.orbiterColor
        }
        
        let orbiterSize = sqrt(radius) * 1.6
        context.fill(
            Path(ellipseIn: CGRect(
                x: center.x - orbiterSize / 2,
                y: center.y - orbiterSize / 2,
                width: orbiterSize,
                height: orbiterSize
            )),
            with: .color(orbiterColor)
        )
    }
    
    
    func drawRadius(context: GraphicsContext, from: CGPoint, to: CGPoint, radius: CGFloat) {
        let lineWidth = min(sqrt(radius) * 0.15, config.lineWidth)
        context.stroke(
            Path { path in
                path.move(to: from)
                path.addLine(to: to)
            },
            with: .color(config.radiusColor),
            lineWidth: lineWidth
        )
    }
    
    func drawWave(
        context: GraphicsContext,
        lastPoint: CGPoint,
        wave: [CGFloat],
        radius: CGFloat,
        withConnector: Bool = true,
        visibleWave: Bool = true
    ) {
        let translate: CGFloat = config.waveTranslate
        let circleLayer = center.x + radius
        
        let wavePath = Path { path in
            if withConnector {
                path.move(to: lastPoint)
            }
            
            let firstPoint = CGPoint(
                x: circleLayer + translate,
                y: wave.first ?? lastPoint.y
            )
            path.addLine(to: firstPoint)
            
            for (index, y) in wave.enumerated() {
                let point = CGPoint(
                    x: (circleLayer + translate) + CGFloat(index),
                    y: y
                )
                path.addLine(to: point)
            }
        }
        
        context.stroke(
            wavePath,
            with: .color(config.waveColor.opacity(visibleWave ? 1 : 0)),
            lineWidth: config.lineWidth
        )
    }
    
    func drawEpicycles(
        context: GraphicsContext,
        components: [FourierComponent],
        time: Double,
        startingPos: CGPoint = .zero
    ) -> Vector {
        var currentPos = startingPos
        
        for (index, component) in components.enumerated() {
            let prevPos = currentPos
            let pos = component.position(at: time)
            currentPos.x += pos.x
            currentPos.y += pos.y
            
            let circleCenter = CGPoint(
                x: center.x + currentPos.x,
                y: center.y + currentPos.y
            )
            
            if config.showCircle {
                drawCircle(
                    context: context,
                    center: CGPoint(x: center.x + prevPos.x, y: center.y + prevPos.y),
                    radius: component.radius
                )
            }
            
            if config.showRadius {
                drawRadius(
                    context: context,
                    from: CGPoint(x: center.x + prevPos.x, y: center.y + prevPos.y),
                    to: circleCenter, radius: component.radius
                )
            }
            
            if config.showOrbiter {
                if index == 0 {
                    drawOrbiter(
                        context: context,
                        center: CGPoint(x: center.x + prevPos.x, y: center.y + prevPos.y),
                        radius: component.radius,
                        color: config.firstOrbiterColor
                    )
                }
                if index == components.count - 1 {
                    drawOrbiter(
                        context: context,
                        center: circleCenter,
                        radius: 50, // fixed value so its visible
                        color: config.lastOrbiterColor
                    )
                }
            }
        }
        
        return Vector(x: currentPos.x, y: currentPos.y)
    }
    
    func drawPath(context: GraphicsContext, position: CGPoint, signalPath: [Vector]) {
        let wavePath = Path { path in
            path.move(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
            
            for vector in signalPath {
                let point = CGPoint(
                    x: vector.x,
                    y: vector.y
                )
                path.addLine(to: point)
            }
        }
        
        context.stroke(
            wavePath,
            with: .color(config.pathColor),
            lineWidth: config.lineWidth
        )
    }
}

class EpicyclesRenderer3D {
    private let config: EpicycleConfig3D
    private let scene: SCNScene
    private var pathNode: SCNNode
    private let center: SCNVector3
    
    init(config: EpicycleConfig3D) {
        self.config = config
        scene = SCNScene()
        pathNode = SCNNode()
        center = SCNVector3(x: 0, y: 0, z: 0)
        
        scene.rootNode.addChildNode(pathNode)
    }
    
    func drawCircle(radius: Float) -> SCNNode {
        let circleGeometry = SCNTorus(
            ringRadius: CGFloat(radius),
            pipeRadius: CGFloat(config.lineWidth)
        )
        circleGeometry.firstMaterial = config.circleColor
        circleGeometry.firstMaterial?.transparency = CGFloat(config.circleOpacity)
        
        let circleNode = SCNNode(geometry: circleGeometry)
        return circleNode
    }
    
    func drawOrbiter(at position: SCNVector3) -> SCNNode {
        let orbiterGeometry = SCNSphere(radius: CGFloat(config.orbiterSize / 2))
        orbiterGeometry.firstMaterial = config.orbiterColor
        
        let orbiterNode = SCNNode(geometry: orbiterGeometry)
        orbiterNode.position = position
        return orbiterNode
    }
    
    func createPathGeometry(from points: [SCNVector3]) -> SCNGeometry? {
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
        geometry.firstMaterial = config.pathColor
        
        return geometry
    }
    
    func drawEpicycles(components: [FourierComponent], time: Float) -> SCNVector3 {
        var currentPos = SCNVector3Zero
        let rootNode = SCNNode()
        
        for (index, component) in components.enumerated() {
            let prevPos = currentPos
            let pos = component.position(at: Double(time))
            currentPos.x += Float(pos.x)
            currentPos.y += Float(pos.y)
            
            let circleCenter = SCNVector3(
                x: center.x + currentPos.x,
                y: center.y + currentPos.y,
                z: center.z
            )
            
            if config.showCircle {
                let circle = drawCircle(radius: Float(component.radius))
                circle.position = SCNVector3(
                    x: center.x + prevPos.x,
                    y: center.y + prevPos.y,
                    z: center.z
                )
                rootNode.addChildNode(circle)
            }
            
            if config.showOrbiter {
                if index == components.count - 1 || index == 0 {
                    let orbiter = drawOrbiter(at: circleCenter)
                    rootNode.addChildNode(orbiter)
                }
            }
        }
        
        scene.rootNode.addChildNode(rootNode)
        return currentPos
    }
    
    func updatePath(position: SCNVector3, signalPath: [SCNVector3]) {
        pathNode.removeFromParentNode()
        
        if let pathGeometry = createPathGeometry(from: signalPath) {
            pathNode = SCNNode(geometry: pathGeometry)
            scene.rootNode.addChildNode(pathNode)
        }
    }
    
    func getScene() -> SCNScene {
        return scene
    }
}
