//
//  Task.swift
//  Astrocycle
//
//  Created by dbug on 1/26/25.
//

import SwiftUI

struct TaskPage: View, Page {
    let nextAction: () -> Void
    
    @StateObject private var animator = SequentialAnimator()
    private let totalSteps = 2
    
    @State var waveStateSecret = WaveState(config: .default, stopped: false, waveType: .square)
    @State var waveState = WaveState(config: .default, stopped: false, waveType: .square)
    @State private var config: EpicycleConfig
    @State private var secretConfig: EpicycleConfig
    
    @State private var equationTerms: Int = 1
    
    init(nextAction: @escaping () -> Void) {
        self.nextAction = nextAction
        
        _config = State(initialValue: EpicycleConfig(
            circleOpacity: 0.5,
            orbiterSize: 8,
            lineWidth: 2,
            circleColor: .black.opacity(0.3),
            orbiterColor: .red,
            waveColor: .red,
            radiusColor: .red.opacity(0.5),
            pathColor: .red,
            showOrbiter: false,
            showWave: true,
            showRadius: true,
            showCircle: true,
            showWaveConnector: true,
            epicycles: 1,
            waveTranslate: 100
        ))
        
        _secretConfig = State(initialValue: EpicycleConfig(
            circleOpacity: 0.5,
            orbiterSize: 8,
            lineWidth: 2,
            circleColor: .black.opacity(0.3),
            orbiterColor: .cyan,
            waveColor: .cyan,
            radiusColor: .cyan.opacity(0.5),
            pathColor: .cyan,
            showOrbiter: false,
            showWave: true,
            showRadius: false,
            showCircle: false,
            showWaveConnector: false,
            epicycles: 10,
            waveTranslate: -50
        ))
        waveState = WaveState(config: config, stopped: false, waveType: .square)
        waveStateSecret = WaveState(config: secretConfig, stopped: false, waveType: .square)
        waveStateSecret.updateConfig(secretConfig)
    }
    
    private func dynamicText(step: Int) -> AttributedString {
        switch step {
            case 0...:
                return try! AttributedString(
                    markdown: "Can you guess how many terms (or epicycles) are used to create this wave pattern?"
                )
                
            default:
                return try! AttributedString(markdown: "")
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
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 20) {
                            Text("Task 1")
                                .fadeSlideIn(isActive: true, duration: 0.6)
                                .font(.system(size: 30, weight: .bold))
                            Text(dynamicText(step: animator.currentStep))
                                .fadeSlideIn(isActive: true, duration: 1)
                                .font(.system(size: 20))
                            
                        }
                        Spacer()
                    }
                    .padding(.top, 35)
                    
                    HStack(alignment: .center, spacing: 5) {
                        let rendererWidth = RendererWidth.large
                        WaveRenderer(size: CGSize(width: rendererWidth.width(in: geometry),
                                                  height: 200), state: waveStateSecret)
                        .frame(width: rendererWidth.width(in: geometry), height: 200)
                        .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 1)
                    }
                    
                    HStack(alignment: .top, spacing: 5) {
                        VStack(alignment: .leading, spacing: 20) {
                            Spacer()
                            Stepper(label: {
                                Text("\(equationTerms)")
                            }, onIncrement: {
                                if equationTerms < 50 {
                                    equationTerms += 1
                                    var updatedConfig = config
                                    updatedConfig.epicycles = equationTerms
                                    waveState.updateConfig(updatedConfig)
                                }
                            }, onDecrement: {
                                if equationTerms > 0 {
                                    equationTerms -= 1
                                    var updatedConfig = config
                                    updatedConfig.epicycles = equationTerms
                                    waveState.updateConfig(updatedConfig)
                                }
                            })
                            .onChange(of: equationTerms) { oldValue, newValue in
                                if equationTerms == 10 {
                                    var updatedConfig = config
                                    updatedConfig.waveColor = .cyan
                                    updatedConfig.orbiterColor = .cyan
                                    updatedConfig.radiusColor = .cyan
                                    updatedConfig.epicycles = equationTerms
                                    waveState.updateConfig(updatedConfig)
                                    
                                    animator.skip(totalSteps: totalSteps)
                                }
                            }
                            SquareEquation(terms: equationTerms)
                                .padding(.top, 5)
                            Spacer()
                            Spacer()
                        }
                        .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 1)
                        .padding(.leading, 60)
                        
                        VStack {
                            let rendererWidth = RendererWidth.large
                            WaveRenderer(size: CGSize(
                                width: rendererWidth.width(in: geometry),
                                height: 300
                            ), state: waveState)
                            .frame(width: rendererWidth.width(in: geometry), height: 300)
                            .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 1)
                            
                            Spacer()
                        }
                        
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        if animator.isActive(step: totalSteps) {                            
                            Button(action: {
                                equationTerms = 1
                                animator.restart()
                            }) {
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
        }
        .onChange(of: animator.currentStep) { _, newStep in
            if newStep == 1 {
                waveState.updateConfig(config)
            }
        }
        .onAppear {
            animator.configure(steps: [
                .init(delay: 0),
                .init(delay: 0),
            ])
            animator.startAutoPlay()
        }
    }
}
