//
//  PathRenderer.swift
//  Astrocycle
//
//  Created by dbug on 1/19/25.
//

import SwiftUI

struct PathRenderer: View {
    var height: CGFloat = 200
    var width: CGFloat = 200
    @State private var scaleFactor: Double
    
    @ObservedObject private var state: PathState
    
    init(size: CGSize, state: PathState, scale: Double = 0.8) {
        self.state = state
        height = size.height
        width = size.width
        scaleFactor = scale
    }
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 0.016, paused: state.stopped)) { timeline in
                ZStack(alignment: .topTrailing) {
                    Canvas { context, size in
                        context.scaleBy(x: scaleFactor, y: scaleFactor)
                        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
                        
                        let offset = CGPoint(
                            x: (size.width - scaledSize.width) / 2,
                            y: (size.height - scaledSize.height) / 2
                        )
                        
                        context.translateBy(x: offset.x, y: offset.y)
                            
                        
                        if !state.isDrawing {
                            let transform = PathTransform(
                                config: $state.config,
                                canvasSize: size,
                                canvasContext: context,
                                pathManager: state.pathManager,
                                fourierComponents: state.pathManager.fourierComponents,
                                time: state.time
                            )
                            transform.generatePath()
                        } else {
                            // user touch/mouse movements
                            for line in state.lines {
                                var path = Path()
                                path.addLines(line.points)
                                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                            }
                        }
                    }
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            if !state.isDrawing{
                                state.startDrawing()
                            }
                            let newPoint = value.location
                            let viewFrame = geometry.frame(in: .local)
                            
                            if let last = state.lastPoint {
                                let distance = hypot(newPoint.x - last.x, newPoint.y - last.y)
                                if distance >= state.minimumDrawingDistance {
                                    let centerX = newPoint.x - (viewFrame.width / 2)
                                    let centerY = newPoint.y - (viewFrame.height / 2)
                                    
                                    state.xValues.append(centerX)
                                    state.yValues.append(centerY)
                                    state.lastPoint = newPoint
                                }
                            } else {
                                let centerX = newPoint.x - (viewFrame.width / 2)
                                let centerY = newPoint.y - (viewFrame.height / 2)
                                
                                state.xValues.append(centerX)
                                state.yValues.append(centerY)
                                state.lastPoint = newPoint
                            }
                            
                            state.currentLine.points.append(newPoint)
                            state.lines.append(state.currentLine)
                        }
                        .onEnded { _ in
                            if state.isDrawing {
                                state.isDrawing = false
                                state.currentLine = Line()
                                state.lastPoint = nil
                                state.updatePathFromDrawing()
                                state.time = 0
                            }
                        })
                }
                .onChange(of: timeline.date) {
                    guard !state.fourier.isEmpty else { return }
                    
                    state.time += (2.0 * .pi) / Double(state.fourier.count)
                    state.pathManager.updatePath(size: geometry.size, time: state.time)
                    if state.config.restart {
                        if state.time > 2 * .pi {
                            state.time = 0
                            state.pathManager.signalPath = []
                        }
                    }
                }
            }
        }
    }
}
