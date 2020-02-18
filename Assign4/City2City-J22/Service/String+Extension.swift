//
//  String+Extension.swift
//  City2City-J22
//
//  Created by mac on 1/29/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

fileprivate struct FormatterStruct {
    //use static to safe object memory and use only one object
    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal //add commas to numbers
        return formatter
    }()
}

extension String {
    
    var addCommas: String? {
        let formatter = FormatterStruct.numberFormatter
        guard let number = formatter.number(from: self) else { return nil}
        return formatter.string(from: number)
    }
    
    
}
