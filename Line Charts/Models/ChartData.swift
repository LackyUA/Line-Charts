//
//  Parser.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/12/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import Foundation

protocol ChartValues: AnyObject {
    var columns: [String : [Int]] { get }
    var types: [String: String] { get }
    var names: [String: String] { get }
    var colors: [String: String] { get }
}

final class ChartData: NSObject, Decodable, ChartValues {
    var types: [String : String] = [:]
    var names: [String : String] = [:]
    var colors: [String : String] = [:]
    var columns: [String : [Int]] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case types
        case names
        case colors
        case columns
    }
    
    private enum ArrayValue: Decodable {
        case string(String)
        case int(Int)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let value = try? container.decode(String.self) {
                self = .string(value)
            } else if let value = try? container.decode(Int.self) {
                self = .int(value)
            } else {
                let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unknown type")
                throw DecodingError.dataCorrupted(context)
            }
        }
        
        func getValue() -> Any {
            switch self {
            case .int(let date):
                return date
            case .string(let line):
                return line
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decode([String: String].self, forKey: .types) {
            self.types = value
        }
        
        if let value = try? container.decode([String: String].self, forKey: .names) {
            self.names = value
        }
        
        if let value = try? container.decode([String: String].self, forKey: .colors) {
            self.colors = value
        }
        
        if let valuesArrays = try? container.decode([[ArrayValue]].self, forKey: .columns) {
            var key = String()
            var values = [Int]()
            
            valuesArrays.forEach { [weak self] valuesArray in
                for column in valuesArray {
                    if let result = column.getValue() as? Int {
                        values.append(result)
                    } else if let result = column.getValue() as? String {
                        key = result
                    }
                }
                
                self?.columns[key] = values
                values = []
            }
        }
    }
    
}
