//
//  StringExtension.swift
//  PawWalker
//
//  Created by shagar on 05/02/25.
//

extension String {
    func addRupees() -> String {
        return TextResource.rupeesSymbol + self
    }
}

extension Double {
    func stringValue() -> String {
        return String(format: "%.2f", self)
    }
    
    func fullStingValue() -> String {
        return String(format: "%f", self)
    }
    
    func stringWithoutDecimal() -> String {
        let integer = Int(self)
        return String(integer)
    }
    
}
extension Int {
    func stringValue() -> String {
        return String(self)
    }
}

extension Collection {
    public var isNotEmpty : Bool {
        !isEmpty
    }
}
