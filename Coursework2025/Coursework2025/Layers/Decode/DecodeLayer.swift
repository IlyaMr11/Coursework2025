//
//  DecodeLayer.swift
//  Coursework2025
//
//  Created by Илья Морозов on 06.04.2025.
//

import Foundation


class DecodeLayer {
  static func decode(url: URL) throws -> PackingInput {
    let accessing = url.startAccessingSecurityScopedResource()
    
    if accessing {
      defer {
        url.stopAccessingSecurityScopedResource()
      }
      do {
        let jsonData = try Data(contentsOf: url)
        return try decodeData(jsonData)
      } catch {
        print("Error reading file: \(error)")
        throw error
      }
    } else {
      throw AppErrors.serverError
    }
  }
  
  static func decodeTestFile(name: String? = nil) throws -> PackingInput {
    let fileName = name ?? Constants.fileName
    let resourceName: String
    let fileExtension: String
    
    // Определяем имя ресурса и расширение
    if let dotIndex = fileName.lastIndex(of: ".") {
      resourceName = String(fileName[..<dotIndex])
      fileExtension = String(fileName[fileName.index(after: dotIndex)...])
    } else {
      resourceName = fileName
      fileExtension = "json"
    }
    
    guard let url = Bundle.main.url(forResource: resourceName, withExtension: fileExtension) else {
      throw AppErrors.invalidFile
    }
    
    return try decode(url: url)
  }
  
  private static func decodeData(_ data: Data) throws -> PackingInput {
    do {
      return try JSONDecoder().decode(PackingInput.self, from: data)
    } catch {
      print("JSON decoding error: \(error)")
      throw AppErrors.invalidFile
    }
  }
}
