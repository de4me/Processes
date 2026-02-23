//
//  KeyedDecodingContainer+Utils.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//


extension KeyedDecodingContainer {
    
    @discardableResult
    func tryDecodeIfPresent<T>(_ value: inout T, of type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) -> Bool where T : Decodable {
        do {
            value = try self.decode(type, forKey: key);
            return true;
        }
        catch {
            #if DEBUG
            print("default: \(type) = \(value)");
            #endif
            return false;
        }
    }
    
}
