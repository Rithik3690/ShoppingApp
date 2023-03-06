//
//  String.swift
//  

import Foundation

extension String {
    func equalsIgnoreCase(_ string: String) -> Bool {
        return self.lowercased() == string.lowercased()
    }
    
    func containsIgnoresCase(_ string: String) -> Bool {
        return self.lowercased().contains(string.lowercased())
    }
}
