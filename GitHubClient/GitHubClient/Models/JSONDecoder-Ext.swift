//
//  JSONDecoder-Ext.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 11.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, fromURL url: String, completion: @escaping (T) -> Void){
        
        
        guard let url = URL(string: url) else{
            fatalError("Invalid URL.")
        }
        
        do{
            let data = try Data(contentsOf: url)
            
            let jsonDecoder = JSONDecoder()
            let downloadedData = try jsonDecoder.decode(type, from: data)
            completion(downloadedData)
            
            
        }catch{
            print(error.localizedDescription)
        }
        
    }
}
