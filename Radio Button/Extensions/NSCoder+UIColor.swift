//
//  NSDecoder+UIColor.swift
//  RadioButton
//
//  Created by Ben Morrison on 25/3/18.
//  Copyright © 2018 Benjamin C Morrison. All rights reserved.
//

import Foundation
import UIKit

internal extension NSCoder {
    /**
     Encodes a `UIColor` without the need to manaually archive it every time.
     */
    func encode(_ color: UIColor, forKey key: String) {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        self.encode(colorData, forKey: key)
    }
    
    /**
     Decodes and returns a `UIColor` that was previously encoded with encode(_:forKey:) and associated with the string key.
     - Returns: A `UIColor` unless it is not found or unarchiving fails, then it returns `nil`.
     */
    func decodeUIColor(forKey key: String) -> UIColor? {
        guard let data = self.decodeObject(forKey: key) as? Data else { return nil }
        guard let color = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor else { return nil }
        return color
    }
}
