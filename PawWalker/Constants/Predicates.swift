//
//  Predicates.swift
//  PawWalker
//
//  Created by shagar on 06/03/25.
//

import Foundation

struct Predicates {
        static let containsSpacePredicate: () -> NSPredicate = {
        return NSPredicate(format: "SELF MATCHES %@", "^S+$")
    }
    static let emailPredicate: () -> NSPredicate = {
        return NSPredicate(format: "SELF MATCHES[c] %@", "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$")
    }
}
