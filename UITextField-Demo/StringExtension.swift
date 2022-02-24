//
//  StringExtension.swift
//  UITextField-Demo
//
//  Created by Alan Liu on 2022/02/24.
//

import UIKit

extension String {
    
    func lengthOfBytes() -> Int {
        return lengthOfBytes(using: String.Encoding.shiftJIS)
    }
}
