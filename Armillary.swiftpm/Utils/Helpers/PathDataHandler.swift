//
//  PathDataHandler.swift
//  My App
//
//  Created by dbug on 11/1/24.
//

import Foundation

struct PathPoint: Codable {
    let x: Double
    let y: Double
}

class PathDataHandler {
    public init() {}

    static func loadPathData(from filename: String) -> ([Double], [Double])? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            print("Error: Cannot find or load JSON file")
            return nil
        }

        do {
            let points = try JSONDecoder().decode([PathPoint].self, from: data)

            let skipFactor = 5
            let optimizedPoints = stride(from: 0, to: points.count, by: skipFactor).map { points[$0] }

            let xValues = optimizedPoints.map { $0.x }
            let yValues = optimizedPoints.map { $0.y }

            return (xValues, yValues)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
