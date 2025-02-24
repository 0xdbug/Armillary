//
//  SquareWaveView.swift
//  Astrocycle
//
//  Created by dbug on 1/26/25.
//

import SwiftUI

// visual only
struct SquareEquation: View {
    let terms: Int
    
    private func buildEquation() -> AttributedString {
        var str = AttributedString("f(t) = ")
        str += AttributedString("4/π")
        str += AttributedString(" (")
        
        for i in 0..<terms {
            let n = 2 * i + 1
            
            if i > 0 {
                str += AttributedString(" + ")
            }
            
            if n > 1 {
                str += AttributedString("1/\(n)")
            }
            str += AttributedString("sin(\(n)t)")
        }
        
        str += AttributedString(")")
                
        return str
    }
    
    var body: some View {
        Text(buildEquation())
            .font(.system(.body, design: .serif))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .animation(.easeInOut(duration: 0.2), value: terms)
    }
}
