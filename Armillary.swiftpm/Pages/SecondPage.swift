import SwiftUI

struct EpicyclePage: View, Page {
    let nextAction: () -> Void
    
    @StateObject private var animator = SequentialAnimator()
    private let totalSteps = 7
    
    @State var waveState = WaveState(config: .default, stopped: false, waveType: .square)
    @State var waveStateSecret = WaveState(config: .default, stopped: false, waveType: .square)
    @State var waveState2 = WaveState(config: .default, stopped: false, waveType: .square)
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
            showOrbiter: true,
            showWave: false,
            showRadius: false,
            showCircle: true,
            showWaveConnector: false,
            epicycles: 1
        ))
        
        _secretConfig = State(initialValue: EpicycleConfig(
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
            showRadius: false,
            showCircle: false,
            showWaveConnector: false,
            epicycles: 1,
            waveTranslate: -100
        ))
        waveStateSecret = WaveState(config: secretConfig, stopped: false, waveType: .square)
        
        waveState = WaveState(config: config, stopped: false, waveType: .square)
        waveState2 = WaveState(config: config, stopped: false, waveType: .square)
        
    }
    
    private func dynamicText(step: Int) -> AttributedString {
        switch step {
            case 1:
                return try! AttributedString(
                    markdown: "Watch this circle spin – notice how the **dot** moves up and down as it rotates. Can you spot a familiar **wave pattern** forming?"
                )
                
            case 2:
                return try! AttributedString(
                    markdown: "A single spinning circle traces out a smooth, wavy motion – called a **sine wave** when we track it's **Vertical Movement**. It's the simplest kind of periodic wave. Its Fourier Series is as simple as this:"
                )
                
            case 3:
                return try! AttributedString(
                    markdown: "Now, let's add more circles. Each new circle spins faster (a higher frequency) and is smaller (a lower amplitude). These circles combine their motions to 'stack up' on the original sine wave."
                )
                
            case 4...5:
                return try! AttributedString(
                    markdown: "As we add more circles, the resulting wave starts to take on sharper turns and edges. These edges form because higher-frequency circles add detail."
                )
                
            case 6:
                return try! AttributedString(
                    markdown: "When we add **enough terms** (n=1,3,5,7...), each represented by a circle, the wave better approximates a **square wave**! This is because each term in the Fourier series adds a specific frequency that helps shape our signal."
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
                            Text("Fourier Analysis")
                                .fadeSlideIn(isActive: true, duration: 1)
                                .font(.system(size: 40, weight: .bold))
                            
                            Text("Lets ask ourselves this: **Can any signal be made up of a mix of spinning circles?**")
                                .fadeSlideIn(isActive: animator.isActive(step: 0), duration: 1)
                                .font(.system(size: 20))
                            
                            Text(dynamicText(step: animator.currentStep))
                                .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 1)
                                .padding(.top, 30)
                                .font(.system(size: 20))
                                .frame(maxWidth: (geometry.size.width - 10) / 2)
                            
                            SquareEquation(terms: equationTerms)
                                .fadeSlideIn(isActive: animator.isActive(step: 2), duration: 1)
                                .scaleEffect(animator.isActive(step: 2) ? 1 : 0.8)
                                .padding(5)
                            
                            Spacer()
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                        .padding(.top, 70)
                        .padding(.leading, 60)
                        
                        VStack {
                            let rendererWidth = RendererWidth.forStep(animator.currentStep)
                            WaveRenderer(size: CGSize(width: rendererWidth.width(in: geometry),
                                                      height: 300), state: waveState)
                            .frame(width: rendererWidth.width(in: geometry), height: 300)
                            .fadeSlideIn(isActive: animator.isActive(step: 1), duration: 1)
                            
                            Spacer()
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                        .padding(.top, 140)
                    }
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
                var updatedConfig = config
                updatedConfig.showRadius = newStep > 1
                updatedConfig.showWave = newStep > 1
                
                let newTerms = (newStep > 3 && newStep <= 4) ? 5 : newStep > 4 ? 20 : 1
                updatedConfig.epicycles = newTerms
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    equationTerms = newTerms
                }
                waveState.updateConfig(updatedConfig)
            }
            .onAppear {
                animator.configure(steps: [
                    .init(delay: 0),
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
