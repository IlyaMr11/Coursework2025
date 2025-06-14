//
//  MockDecoder.swift
//  Coursework2025
//
//  Created by Илья Морозов on 24.03.2025.
//

import Foundation

class MockDecoder {
    
    static let mockJSONstring = """
{
  "canvas": {
    "width": 800,
    "height": 600
  },
  "figures": [
    {
      "outCircuit": [
        {
          "segment": {
            "start": { "x": 50, "y": 50 },
            "end": { "x": 150, "y": 50 }
          }
        },
        {
          "arc": {
            "start": { "x": 150, "y": 50 },
            "end": { "x": 150, "y": 150 },
            "radius": 50,
            "center": { "x": 100, "y": 100 },
            "clockwise": true
          }
        }
      ],
      "inCircuit": [
        {
          "segment": {
            "start": { "x": 75, "y": 75 },
            "end": { "x": 125, "y": 75 }
          }
        }
      ]
    },
    {
      "outCircuit": [
        {
          "arc": {
            "start": { "x": 300, "y": 300 },
            "end": { "x": 400, "y": 400 },
            "radius": 75,
            "center": { "x": 350, "y": 350 },
            "clockwise": false
          }
        }
      ],
      "inCircuit": null
    }
  ]
}
"""
    
    static func mockDecode() async throws -> PackingInput {
        guard let jsonData = mockJSONstring.data(using: .utf8) else {
            throw NSError(domain: "Error", code: 1, userInfo: nil)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(PackingInput.self, from: jsonData)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
            throw error
        }
    }
}
