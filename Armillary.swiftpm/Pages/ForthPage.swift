//
//  ForthPage.swift
//  Astrocycle
//
//  Created by dbug on 2/1/25.
//

import SwiftUI

struct ForthPage: View, Page {
    let nextAction: () -> Void
    
    @StateObject private var animator = SequentialAnimator()
    
    private let totalSteps = 3
    
    @State private var config: EpicycleConfig
    @State var pathState: PathState
    @State var pathState2: PathState
    @State var pathState3: PathState
    @State var pathState4: PathState
    
    @State var didStartDrawing = false
    
    init(nextAction: @escaping () -> Void) {
        self.nextAction = nextAction
        
        _config = State(initialValue: EpicycleConfig(
            circleOpacity: 0.2,
            orbiterSize: 8,
            lineWidth: 2,
            circleColor: .black,
            orbiterColor: .black,
            waveColor: .black,
            radiusColor: .black,
            pathColor: .black,
            showOrbiter: false,
            showWave: true,
            showRadius: true,
            showCircle: true,
            showWaveConnector: false
        ))
        
        pathState = PathState(config: .default, stopped: false, path: "fourier")
        pathState2 = PathState(config: .default, stopped: false, path: "heart")
        pathState3 = PathState(config: .default, stopped: false, path: "swift")
        pathState4 = PathState(config: .default, stopped: false, path: "helloworld")
        pathState.updateConfig(config)
        pathState2.updateConfig(config)
        pathState3.updateConfig(config)
        pathState4.updateConfig(config)
    }
    
    private func pathForStep(step: Int) -> PathState {
        switch step {
            case 0:
                return pathState
            case 1:
                return pathState2
            case 2:
                return pathState3
            case 3:
                return pathState4
            default:
                return pathState
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            animator.previousStep()
                        }
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            animator.nextStep()
                        }
                }
                
                VStack {
                    // zoom?
                    VStack(alignment: .center) {
                        Text("These are some more paths we can make our 'machine' draw")
                            .fadeSlideIn(isActive: animator.isActive(step: 0), duration: 1)
                            .font(.system(size: 18))
                            .frame(width: (geometry.size.width))
                        
                        let rendererWidth = RendererWidth.fullScreen
                        PathRenderer(
                            size: CGSize(width: rendererWidth.width(in: geometry), height: 50),
                            state: pathForStep(step: animator.currentStep)
                        )
                        .fadeSlideIn(isActive: animator.isActive(step: 0), duration: 1)
                        .allowsHitTesting(false)
                    }
                    .frame(width: (geometry.size.width))
                    .padding(.top, 60)
                    Spacer()
                    
                    // Bottom controls
                    HStack {
                        Spacer()
                        if animator.isActive(step: totalSteps) {
                            Button(action: { animator.restart() }) {
                                Text("Repeat")
                            }
                            .buttonStyle(DefaultButton(color: .systemGray, opacity: 1))
                            .fadeSlideIn(duration: 0.5)
                            
                            Button(action: nextAction) {
                                Text("Continue")
                            }
                            .buttonStyle(DefaultButton())
                            .fadeSlideIn(duration: 0.5)
                        } else {
                            TapHint()
                                .fadeSlideIn(duration: 1.0)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
            .onChange(of: animator.currentStep) { _, newStep in
                
            }
            .onAppear {
                animator.configure(steps: [
                    .init(delay: 0),
                    .init(delay: 0),
                    .init(delay: 0),
                ])
                animator.startAutoPlay()
            }
        }
    }
}
