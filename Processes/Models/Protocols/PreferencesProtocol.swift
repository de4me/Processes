//
//  LoadAndSaveProtocol.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//

import Cocoa;


protocol PreferncesInfoProtocol where Self: AnyObject & Codable {
    func preferenceKeys() -> [CodingKey];
    func preferenceName() -> String;
}


extension PreferncesInfoProtocol {
    
    func preferenceName() -> String {
        NSStringFromClass(type(of: self));
    }
    
}


protocol PreferenceAssigningProtocol where Self: PreferncesInfoProtocol {
    static func << (lhs: Self, rhs: Self);
}


extension PreferenceAssigningProtocol {
    
    static func << (lhs: Self, rhs: Self) {
        let keys = rhs.preferenceKeys();
        let paths = keys.map(\.stringValue);
        guard let source = rhs as? NSObject,
              let target = lhs as? NSObject
        else {
            return;
        }
        let dict = source.dictionaryWithValues(forKeys: paths);
        target.setValuesForKeys(dict);
    }
    
}


protocol PreferencesProtocol: NSObject where Self: PreferenceAssigningProtocol {
    func load();
    func save();
}


extension PreferencesProtocol {
    
    func load() {
        do {
            guard let data = UserDefaults.standard.data(forKey: self.preferenceName()) else {
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
            let name = self.preferenceName();
            let encoder = JSONEncoder();
            let data = try encoder.encode(self);
            UserDefaults.standard.set(data, forKey: name);
        }
        catch {
            print(error);
        }
    }
    
}
