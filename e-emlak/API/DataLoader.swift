//
//  DataLoader.swift
//  e-emlak
//
//  Created by Hakan Or on 24.10.2022.
//

import Foundation
public class DataLoader {
    @Published var cityData = [City]()
    
    init() {
        load()
    }
    
    func load (){
    
        guard let fileLocation = Bundle.main.url(forResource: "data", withExtension: "json") else {
            fatalError("Couldn't load data")
        }
        guard let data = try? Data(contentsOf: fileLocation) else {
            fatalError("Couldn't cover data")
        }
        
        let decoder = JSONDecoder()
        guard let dataFromJson = try? decoder.decode([City].self, from: data ) else {
            fatalError("There was a problem decoding data")
        }
        self.cityData = dataFromJson
    }
}
