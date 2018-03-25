//
//  RadioButtonFilledView.swift
//  Radio Button
//
//  Created by Ben Morrison on 17/2/18.
//  Copyright © 2018 Benjamin C Morrison. All rights reserved.
//

import UIKit

extension RadioButton {
    internal final class FilledView: UIView {
        convenience init(parent: UIView) {
            let rect = RadioButtonFilledView.getRect(fromParentFrame: parent.frame)
            self.init(frame: rect)
            
            setup(parent: parent)
        }
        
        private override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func setup(parent: UIView) {
            backgroundColor = parent.tintColor
            isHidden = true
            isUserInteractionEnabled = false
            translatesAutoresizingMaskIntoConstraints = false
            
            let width = NSLayoutConstraint(item: self,
                                           attribute: .width,
                                           relatedBy: .equal,
                                           toItem: nil,
                                           attribute: .notAnAttribute,
                                           multiplier: 1.0,
                                           constant: frame.width)
            
            let height = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: frame.height)
            
            addConstraints([width, height])
            
            if frame.width > frame.height {
                layer.cornerRadius = frame.height / 2.0
            }
            else {
                layer.cornerRadius = frame.width / 2.0
            }
        }
        
        private static func getRect(fromParentFrame frame: CGRect) -> CGRect {
            let size = CGSize(width: frame.width - 8.0, height: frame.height - 8.0)
            let origin = CGPoint(x: frame.origin.x + 4.0, y: frame.origin.y + 4.0)
            
            return CGRect(origin: origin, size: size)
        }
    }
}
