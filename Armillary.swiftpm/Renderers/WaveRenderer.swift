//
//  WaveRenderer.swift
//  Astrocycle
//
//  Created by dbug on 1/19/25.
//

import SwiftUI

struct WaveRenderer: View {
    var height: CGFloat = 200
    var width: CGFloat = 200

    @ObservedObject private var state: WaveState
    @StateObject private var waveManager = WaveManager()

    init(size: CGSize, state: WaveState) {
        self.state = state
        height = size.height
        width = size.width
    }

    var body: some View {
        GeometryReader { _ in
            TimelineView(.animation(minimumInterval: 0.016, paused: state.stopped)) { timeline in
                ZStack(alignment: .topTrailing) {
                    Canvas { context, size in
                        let transform = WaveTransform(
                            config: $state.config,
                            canvasSize: size,
                            canvasContext: context,
                            waveManager: waveManager,
                            fourierComponents: state.fourierComponents,
                            time: state.time
                        )
                        transform.generateWave()
                    }
                }
                .onChange(of: timeline.date) {
                    state.time += 0.03
                    waveManager.updateWave(components: state.fourierComponents, time: state.time, canvasHeight: height)
                }
            }
        }
        .allowsHitTesting(false)
    }
}
