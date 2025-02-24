import SwiftUI

struct ThirdPage: View, Page {
    let nextAction: () -> Void
    
    @StateObject private var animator = SequentialAnimator()
    
    private let totalSteps = 5
    
    @State private var config: EpicycleConfig
    @State var pathState: PathState
    
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
        
        pathState = PathState(config: .default, stopped: false, path: "heart")
        pathState.updateConfig(config)
    }
    
    private func dynamicText(step: Int) -> AttributedString {
        switch step {
                //            case 1:
                //                return try! AttributedString(
                //                    markdown: "Centuries before mathematicians discovered they could represent any wave as a sum of circles, ancient astronomers used epicycles to track the motion of planets in the night sky."
                //                )
                
            case 1...:
                return try! AttributedString(
                    markdown: "With just a few more steps, we can generate epicycles that trace out **any shape**."
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
                            if animator.currentStep == 2 {
                                pathState.startDrawing()
                            }
                        }
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            animator.nextStep()
                            if animator.currentStep == 2 {
                                pathState.startDrawing()
                            }
                        }
                }
                
                
                VStack {
                    HStack(alignment: .top, spacing: 5) {
                        VStack(alignment: .leading, spacing: 20) {
                            Group {
                                if !animator.isActive(step: 1) {
                                    Text("Paths")
                                        .fadeSlideIn(isActive: true, duration: 1)
                                        .font(.system(size: 40, weight: .bold))
                                    
                                    Text("Now lets ask another question. What if instead of tracking up-and-down motion, we track **both** horizontal and vertical movement?")
                                        .fadeSlideIn(isActive: animator.isActive(step: 0), duration: 1)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(.leading, 60)
                            
                            VStack(alignment: .center) {
                                if animator.currentStep >= 1 && animator.currentStep <= 4 {
                                    Text(dynamicText(step: animator.currentStep))
                                        .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 1)
                                        .padding(.top, 10)
                                        .font(.system(size: 20))
                                        .frame(width: (geometry.size.width / 1.5))
                                        .padding(.bottom, 50)
                                    
                                    HStack(spacing: 20) {
                                        VStack(alignment: .center) {
                                            Text("First, take a series of coordinates of a shape")
                                            PathView()
                                                .frame(height: 200)
                                        }
                                        .fadeSlideIn(isActive: animator.isActive(step: 2), duration: 1)
                                        Group {
                                            Image(systemName: "arrow.right")
                                                .font(.system(size: 24))
                                                .foregroundColor(.gray)
                                            VStack(alignment: .center) {
                                                Text("""
                                Then, apply **Discrete Fourier Transform** to generate components of each **Epicycle**
                                """)
                                                .frame(height: 50)
                                                DFTEquation()
                                                    .frame(height: 200)
                                            }
                                        }
                                        .fadeSlideIn(isActive: animator.isActive(step: 3), duration: 1)
                                        Group {
                                            Image(systemName: "arrow.right")
                                                .font(.system(size: 24))
                                                .foregroundColor(.gray)
                                            VStack(alignment: .center) {
                                                Text("Which will loook like this")
                                                EpicycleComponentsView()
                                                    .frame(height: 200)
                                            }
                                        }
                                        .fadeSlideIn(isActive: animator.isActive(step: 4), duration: 1)
                                    }
                                    .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 1)
                                    .padding(.top, 20)
                                }
                                
                                Text("Use the Canvas below to see for yourself")
                                    .fadeSlideIn(isActive: animator.isActive(step: 5), duration: 0.2)
                                    .padding(.top, 10)
                                    .font(.system(size: 18))
                                    .frame(width: (geometry.size.width))
                            }
                            
                        }
                        .frame(maxWidth: geometry.size.width / 1.1)
                        .padding(.top, 80)
                    }
                    VStack(alignment: .center) {
                        ZStack {
                            if pathState.isDrawing {
                                Image("infinity")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 800)
                                    .opacity(0.03)
                                
                                Text("""
                                     Doodle a (house, face, plant, etc.) using a 
                                     single continuous line.
                                     """)
                                
                            }
                            
                            if animator.currentStep == 5 {
                                let rendererWidth = RendererWidth.fullScreen
                                PathRenderer(
                                    size: CGSize(width: rendererWidth.width(in: geometry), height: 300),
                                    state: pathState, scale: 1
                                )
                                .fadeSlideIn(isActive: animator.isActive(step: 5), duration: 1)
                            }
                        }
                        .opacity(animator.currentStep == 5 ? 4 : 0)
                    }
                    .padding(.top, 40)
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
                    .init(delay: 0),
                    .init(delay: 0),
                ])
                animator.startAutoPlay()
            }
        }
    }
}
