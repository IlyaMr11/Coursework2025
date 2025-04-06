//
//  DecodeLayer.swift
//  Coursework2025
//
//  Created by Илья Морозов on 06.04.2025.
//

import Foundation


class DecodeLayer {
    static func decode(url: URL) throws -> DataModel {
        
   
            let accessing = url.startAccessingSecurityScopedResource()
            
            if accessing {
                defer {
                    url.stopAccessingSecurityScopedResource()
                }
                
                
                do {
                    let fileContent = try String(contentsOf: url, encoding: .utf8)
                    print("File content: \(fileContent)")
                    
                    
                    if let jsonData = fileContent.data(using: .utf8) {
                        let data = try JSONDecoder().decode(DataModel.self, from: jsonData)
                        return data
                    } else {
                        throw AppErrors.invalidFile
                    }
                } catch {
                    print("Error reading file: \(error)")
                    throw error
                }
            } else {
                throw AppErrors.serverError
            }
    
    }
}
