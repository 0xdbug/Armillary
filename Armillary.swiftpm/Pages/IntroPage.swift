import SwiftUI

struct Intro: View, Page {
    let nextAction: () -> Void
    
    @StateObject private var animator = SequentialAnimator()
    private let totalSteps = 5
    
    private let hintHeight = 60.0
    
    @State private var selectedPlanet: Planets = .mercury
    
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
                
                VStack(spacing: 0) {
                    if !animator.isActive(step: 1) {
                        VStack(alignment: .leading, spacing: 4) {
                            Group {
                                Text("Hello,")
                                Text("Welcome to my SSC25 Entry.")
                            }
                            .font(.system(.largeTitle, weight: .bold))
                            Text("(Please use in Landscape mode)")
                                .font(.system(.caption, weight: .light))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal], 40)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    ZStack {
                        SceneRenderer(width: geometry.size.width, height: 350, selectedPlanet: $selectedPlanet)
                            .frame(height: 350)
                            .allowsHitTesting(true)
                        if animator.currentStep < 4 {
                            HStack {
                                Spacer(minLength: 10)
                                Image("pinch_swipe")
                                    .resizable()
                                    .frame(width: hintHeight * 3.6, height: hintHeight)
                                    .rotationEffect(.degrees(-20))
                            }
                            .padding(.bottom, 120)
                            .padding(.trailing, 20)
                            .fadeSlideIn(isActive: animator.isActive(step: 2), duration: 2.5)
                        }

                    }
                    
                    VStack(spacing: 15) {
                        Text("This is called **Geocentric Planetary Motion**")
                            .font(.system(size: 20, weight: .medium))
                            .multilineTextAlignment(.center)
                            .fadeSlideIn(isActive: animator.isActive(step: 0), duration: 1)
                        
                        Text("(or **Planetary Harmonics**)")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .fadeSlideIn(isActive: animator.isActive(step: 0), duration: 1.1)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("These patterns are formed when we trace the movement of planets as they revolve around the Earth.")
                                .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 0.5)
                            
                            Text("You'll **discover** how the movement of planets were traced in ancient times using **Epicycles**!")
                                .fadeSlideIn(isActive: animator.isActive(step: 2), duration: 0.5)
                            
                            Text("Together, We will blend **ancient astronomical concepts** with modern **signal processing** to break down a planet’s motion into epicycles.")
                                .fadeSlideIn(isActive: animator.isActive(step: 3), duration: 0.5)
                            
                            Text("You'll also get to experiment with it and design your own unique tracings!")
                                .fadeSlideIn(isActive: animator.isActive(step: 4), duration: 0.5)
                        }
                        .font(.system(size: 18))
                        .multilineTextAlignment(.leading)
                        .padding(20)
                        .allowsHitTesting(false)
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        if animator.isActive(step: totalSteps) {
                            Button(action: nextAction) {
                                Text("Continue")
                            }
                            .buttonStyle(DefaultButton())
                            .fadeSlideIn(duration: 0.5)
                        } else {
                            TapHint()
                                .allowsHitTesting(false)
                                .fadeSlideIn(duration: 1.0)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                .foregroundStyle(.black)
                .padding(20)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .onAppear {
            animator.configure(steps: [
                .init(delay: 0),
                .init(delay: 1),
                .init(delay: 1),
                .init(delay: 1),
                .init(delay: 1),
                .init(delay: 1),
            ])
            animator.startAutoPlay()
        }
    }
}
