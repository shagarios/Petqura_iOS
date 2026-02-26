//
//  DateExtension.swift
//  PawWalker
//
//  Created by shagar on 29/01/25.
//

import SwiftUI

extension Date {
    
    func toString(format : String = DateFormats.ddMMyyyy.rawValue) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
