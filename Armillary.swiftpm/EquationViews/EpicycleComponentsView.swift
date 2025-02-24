//
//  EpicycleComponentsView.swift
//  Armillary
//
//  Created by dbug on 2/10/25.
//

import SwiftUI

// visual only
struct EpicycleComponentsView: View {
    var body: some View {
        Text("""
(real: 7.472858e-06, imaginary: 0.6805368, frequency: 0.0,
 amplitude: 0.6805368, phase: 1.5707854),
(real: -1.5735544, imaginary: 187.6604, frequency: 1.0, 
amplitude: 187.66699, phase: 1.5791812),
(real: -0.6166061, imaginary: 36.76565, frequency: 2.0, 
amplitude: 36.77082, phase: 1.587566),
(real: 1.1391809, imaginary: -45.277916, frequency: 3.0, 
amplitude: 45.292244, phase: -1.5456419), ...
""")
        .font(.system(.body, design: .serif))
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

