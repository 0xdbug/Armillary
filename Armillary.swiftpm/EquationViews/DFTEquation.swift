//
//  DFTEquation.swift
//  Armillary
//
//  Created by dbug on 2/10/25.
//

import SwiftUI

// visual only
struct DFTEquation: View {
    var body: some View {
        Image("dft")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 150)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
    }
}
