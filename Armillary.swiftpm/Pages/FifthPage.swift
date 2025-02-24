//
//  FifthPage.swift
//  Astrocycles
//
//  Created by dbug on 2/3/25.
//

import SwiftUI

struct FifthPage: View, Page {
    let nextAction: () -> Void

    @StateObject private var animator = SequentialAnimator()

    private let totalSteps = 6

    @State private var config: EpicycleConfig
    @State var pathState: PathState
    
    @State private var selection = "Mercury"
    let planets = ["Mercury", "Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]

    init(nextAction: @escaping () -> Void) {
        self.nextAction = nextAction
        
        _config = State(initialValue: EpicycleConfig(
            circleOpacity: 0.2,
            orbiterSize: 8,
            lineWidth: 2,
            circleColor: .black,
            orbiterColor: .black,
            firstOrbiterColor: .blue,
            lastOrbiterColor: .yellow,
            waveColor: .black,
            radiusColor: .black,
            pathColor: .black,
            showOrbiter: true,
            showWave: true,
            showRadius: true,
            showCircle: true,
            showWaveConnector: false,
            restart: false
        ))
        
        pathState = PathState(config: .default, stopped: false, path: "mercury_dance")
        pathState.updateConfig(config)
    }
    
    private func dynamicText(step: Int) -> AttributedString {
        switch step {
            case 1:
                return try! AttributedString(
                    markdown: "At that time, astronomers believed in the **Geocentric Model**, where Earth was at the center of the universe."
                )
            case 2:
                return try! AttributedString(
                    markdown: "They observed that planets sometimes appeared to slow down, stop, and even move backward. It was known as **retrograde motion**. To explain this they imagined that planets traveled along small circular paths that themselves moved along larger circular routes."
                )
            case 3:
                return try! AttributedString(
                    markdown: "**Ptolemy** refined this idea by arranging these circles to match what was observed in the sky. His model was able to predict paths of the planets as seen from Earth and explain the **retrograde motion**, and it remained the standard explanation for over a thousand years."
                )
            case 4:
                return try! AttributedString(
                    markdown: "Now, we can replicate the same kinds of circles by applying the **Fourier Transform** algorithm on a series of captured coordinates of planet movements."
                )
            case 5:
                return try! AttributedString(
                    markdown: "Select a Planet to see it for yourself"
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
                    HStack(alignment: .top, spacing: 5) {
                        VStack(alignment: .leading, spacing: 20) {
                            Group {
                                if animator.currentStep > 5 {
                                    HStack {
                                        Spacer()
                                        Text("Thank You!")
                                            .fadeSlideIn(isActive: true, duration: 1)
                                            .font(.system(size: 35, weight: .bold))
                                        Spacer()
                                    }
                                }else {
                                    Text("Epicycles")
                                        .fadeSlideIn(isActive: true, duration: 1)
                                        .font(.system(size: 35, weight: .bold))
                                }
                                if animator.currentStep <= 5 {
                                    Text("Thousands of years ago, ancient astronomers could explain the complex motions of planets using only simple circles. We can generate something simillar!")
                                        .fadeSlideIn(isActive: animator.isActive(step: 0), duration: 1)
                                        .font(.system(size: 20))
                                }else {
                                        Text("Before you go there is one last cool visual you **must** see! If we render it in 3D we can visualize how a geocentric model of the solar system **might** have looked like.")
                                            .fadeSlideIn(isActive: animator.isActive(step: 0), duration: 1)
                                            .font(.system(size: 20))
                                            .multilineTextAlignment(.center)
                                }
                                HStack {
                                    Text(dynamicText(step: animator.currentStep))
                                        .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 1)
                                        .padding(.top, 10)
                                        .font(.system(size: 20))
                                    
                                    if animator.currentStep == 5 {
                                        Picker("select a planet", selection: $selection) {
                                            ForEach(planets, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(width: 200)
                                        .onChange(of: selection) { _, newValue in
                                            pathState.updatePath("\(newValue.lowercased())_dance")
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(width: (geometry.size.width / 1.2))
                            }
                            .padding([.leading, .trailing], 60)
                            
                        }
                        .padding(.top, 80)
                    }
                    VStack(alignment: .center) {
                        if animator.currentStep == 5 {
                            let rendererWidth = RendererWidth.medium
                            PathRenderer(
                                size: CGSize(width: rendererWidth.width(in: geometry), height: 300),
                                state: pathState
                            )
                            .allowsHitTesting(false)
                            .fadeSlideIn(isActive: animator.isActive(step: 4), duration: 1)
                        }
                        if animator.currentStep > 5 {
                            Button(action: nextAction) {
                                Text("Render in 3D")
                            }
                            .buttonStyle(DefaultButton())
                            .fadeSlideIn(duration: 0.5)
                        }
                    }
                    .padding(.top, 20)
                    Spacer()
                    
                    // Bottom controls
                    HStack {
                        Spacer()
                        if animator.isActive(step: totalSteps) {
                            Button(action: {
                                pathState.time = 0
                                animator.restart()
                            }) {
                                Text("Repeat")
                            }
                            .buttonStyle(DefaultButton(color: .systemGray, opacity: 1))
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
                    .init(delay: 0),
                    .init(delay: 0),
                    .init(delay: 0),
                ])
                animator.startAutoPlay()
            }
        }
    }
}
