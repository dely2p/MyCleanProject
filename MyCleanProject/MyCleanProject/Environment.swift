//
//  Environment.swift
//  MyCleanProject
//
//  Created by elly on 11/4/24.
//

import Foundation

import Foundation

struct Environment {
    static func value(for key: String) -> String? {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            print("`.env` file not found in bundle")
            return nil
        }
        
        do {
            let contents = try String(contentsOfFile: path)
            let lines = contents.split(separator: "\n")
            for line in lines {
                let parts = line.split(separator: "=", maxSplits: 1)
                if parts.count == 2 {
                    let keyPart = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let valuePart = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    if keyPart == key {
                        return valuePart
                    }
                }
            }
        } catch {
            print("Could not read .env file from bundle")
        }
        return nil
    }
}
