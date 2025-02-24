//
//  SixthPage.swift
//  Armillary
//
//  Created by dbug on 2/6/25.
//

import SwiftUI
import SceneKit

struct SixthPage: View, Page {
    let nextAction: () -> Void
    
    @StateObject private var animator = SequentialAnimator()
    private let totalSteps = 5
    
    private let hintHeight = 60.0
    
    @State private var selection = "Mercury"
    let planets = ["Mercury", "Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
        
    @State private var selectedPlanet: Planets = .mercuryWhite
    
    init(nextAction: @escaping () -> Void) {
        self.nextAction = nextAction
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("starry1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
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
                    ZStack {
                        SceneRenderer(width: geometry.size.width, height: geometry.size.height, selectedPlanet: $selectedPlanet, animation: false, cameraVariation: 2)
                            .frame(height: geometry.size.height)
                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                                Text("Select a Planet:")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                Picker("select a planet", selection: $selection) {
                                    ForEach(planets, id: \.self) {
                                        Text($0)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 200)
                                .onChange(of: selection) { _, newValue in
                                    switch newValue {
                                            // this can be made so much better..
                                        case planets[0]:
                                            selectedPlanet = Planets.mercuryWhite
                                        case planets[1]:
                                            selectedPlanet = Planets.venusWhite
                                        case planets[2]:
                                            selectedPlanet = Planets.marsWhite
                                        case planets[3]:
                                            selectedPlanet = Planets.jupiterWhite
                                        case planets[4]:
                                            selectedPlanet = Planets.saturnWhite
                                        case planets[5]:
                                            selectedPlanet = Planets.uranusWhite
                                        case planets[6]:
                                            selectedPlanet = Planets.neptuneWhite
                                            
                                        default:
                                            selectedPlanet = Planets.mercuryWhite
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 50)
                    }

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

