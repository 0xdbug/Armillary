//
//  RendererWidth.swift
//  Astrocycle
//
//  Created by dbug on 1/2/25.
//

import SwiftUI

enum RendererWidth {
    case initial
    case medium
    case large
    case fullScreen
    
    func width(in geometry: GeometryProxy) -> CGFloat {
        switch self {
            case .initial: return 300
            case .medium: return 500
            case .large: return 600
            case .fullScreen: return geometry.size.width - 80
        }
    }
    
    static func forStep(_ step: Int) -> RendererWidth {
        switch step {
            case 0 ... 2: return .initial
            case 3 ... 4: return .medium
            case 5 ... 8: return .medium
            default: return .fullScreen
        }
    }
}
