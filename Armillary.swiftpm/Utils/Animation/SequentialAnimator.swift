import SwiftUI

struct AnimationStep {
    let delay: Double
}

class SequentialAnimator: ObservableObject {
    @Published private(set) var currentStep = -1
    private var steps: [AnimationStep] = []
    private var autoPlayWorkItem: DispatchWorkItem?

    func configure(steps: [AnimationStep]) {
        self.steps = steps
        currentStep = -1
    }

    func isActive(step: Int) -> Bool {
        currentStep >= step
    }

    func restart() {
        stopAutoPlay()
        withAnimation {
            currentStep = 0
        }
    }

    func nextStep() {
        stopAutoPlay()
        withAnimation {
            currentStep = min(currentStep + 1, steps.count)
        }
    }
    
    func skip(totalSteps: Int) {
        stopAutoPlay()
        withAnimation {
            currentStep = totalSteps
        }
    }

    func previousStep() {
        stopAutoPlay()
        if currentStep != 0 {
            withAnimation {
                currentStep = min(currentStep - 1, steps.count)
            }
        }
    }

    func startAutoPlay() {
        stopAutoPlay()
        let workItem = DispatchWorkItem { [weak self] in
            withAnimation {
                self?.currentStep = 0
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + (steps.first?.delay ?? 0),
            execute: workItem
        )

        autoPlayWorkItem = workItem
    }

    func stopAutoPlay() {
        autoPlayWorkItem?.cancel()
        autoPlayWorkItem = nil
    }

    deinit {
        stopAutoPlay()
    }
}
