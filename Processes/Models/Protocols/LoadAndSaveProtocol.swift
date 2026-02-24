//
//  LoadAndSaveProtocol.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;


protocol LoadAndSaveProtocol {
    func load();
    func save();
}


extension LoadAndSaveProtocol where Self: NSObject & Codable & CodingNameProtocol & ObjectAssigningProtocol {

    func load() {
        do {
            guard let data = UserDefaults.standard.data(forKey: self.codingName()) else {
                return;
            }
            let decoder = JSONDecoder();
            let object = try decoder.decode(type(of: self), from: data);
            self << object;
        }
        catch {
            print(error);
        }
    }
    
    func save() {
        do {
            let name = self.codingName();
            let encoder = JSONEncoder();
            let data = try encoder.encode(self);
            UserDefaults.standard.set(data, forKey: name);
        }
        catch {
            print(error);
        }
    }
    
}
