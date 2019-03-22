//
//  Parser.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/12/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import Foundation

protocol ParseData: AnyObject {
    func getDataFromFile(completion: @escaping (_ charts: [ChartData]) -> Void)
}

class Parser: ParseData {
    
    func getDataFromFile(completion: @escaping ([ChartData]) -> Void) {
        var charts = [ChartData]()
        
        if let path = Bundle.main.path(forResource: Constants.jsonFile.name, ofType: Constants.jsonFile.type) {
            let task = URLSession.shared.dataTask(with: URL(fileURLWithPath: path)) { (data, response, error) in
                guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    charts = try decoder.decode([ChartData].self, from: dataResponse)
                    completion(charts)
                    
                } catch let parsingError {
                    print("Error:", parsingError)
                }
            }
            
            task.resume()
        }
    }
    
}
