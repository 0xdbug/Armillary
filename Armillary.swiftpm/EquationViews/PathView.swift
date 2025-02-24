//
//  PathView.swift
//  Armillary
//
//  Created by dbug on 2/10/25.
//

import SwiftUI

struct PathView: View {
    var body: some View {
        Text("""
(x: -4.408, y: 255), (x: -0.00023, y: 254.9767),  
(x: -0.00191, y: 254.90701), (x: -0.00647, y: 254.79084),  
(x: -0.01534, y: 254.62829), (x: -0.02996, y: 254.41947),  
(x: -0.05174, y: 254.16451), (x: -0.08211, y: 253.86354),
(x: -0.12248, y: 253.51677), (x: -0.17425, y: 253.12438), 
(x: -0.23880, y: 252.68662)  
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
