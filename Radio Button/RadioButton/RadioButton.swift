//
//  RadioButton.swift
//  Radio Button
//
//  Created by Ben Morrison on 4/2/18.
//  Copyright © 2018 Benjamin C Morrison. All rights reserved.
//

import UIKit
/**
 A simple solution for a simple radio button. This can be used on it's own or in a `RadioButtonGroup`.
 */
@IBDesignable
public final class RadioButton: UIView {
    public weak var delegate: RadioButtonDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private enum CodingKeys {
        private static let prefix = "RadioButton:"
        static let pressed = "\(prefix)Pressed"
        static let borderColor = "\(prefix)BorderColor"
        static let fillColor = "\(prefix)fillColor"
        static let shouldDecodeValues = "\(prefix)shouldDecodeValues"
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
        guard aDecoder.decodeBool(forKey: CodingKeys.shouldDecodeValues) else { return }
        
        let animationInterval = self.animationInterval
        self.animationInterval = .none
        
        pressed = aDecoder.decodeBool(forKey: CodingKeys.pressed)
        if let borderColor = aDecoder.decodeUIColor(forKey: CodingKeys.borderColor) {
            self.borderColor = borderColor
        }
        
        if let fillColor = aDecoder.decodeUIColor(forKey: CodingKeys.fillColor) {
            self.fillColor = fillColor
        }
        
        self.animationInterval = animationInterval
    }

    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(true, forKey: CodingKeys.shouldDecodeValues)
        aCoder.encode(_pressed, forKey: CodingKeys.pressed)
        
        if let bColor = _borderColor {
            aCoder.encode(bColor, forKey: CodingKeys.borderColor)
        }
        
        if let fColor = _fillColor {
            aCoder.encode(fColor, forKey: CodingKeys.borderColor)
        }
    }

    public override var frame: CGRect {
        get {  return super.frame }
        set {
            let longSide: CGFloat
            if newValue.width > newValue.height {
                longSide = newValue.height
            }
            else {
                longSide = newValue.width
            }
            
            super.frame = newValue
            layer.cornerRadius = longSide / 2.0
        }
    }
    
    private var filledView: FilledView!

    private var _pressed = false {
        didSet {
            if _pressed {
                fillRadioButton()
            }
            else {
                unFillRadioButton()
            }
        }
    }

    /**
     Determins the state of the button, if it has been pressed (filled in) or not.
     */
    @IBInspectable var pressed: Bool {
        get { return _pressed }
        set {
            guard newValue != pressed else { return }
            if let delegate = delegate {
                guard delegate.shouldChangeStateForRadioButton(self) else { return }
            }
            
            _pressed = newValue
            delegate?.radioButton(self, pressStateChangedTo: newValue)
        }
    }
    
    private var _borderColor: UIColor? {
        didSet {
            let color: UIColor = _borderColor ?? tintColor
            layer.borderColor = color.cgColor
        }
    }
    
    /**
     The color of the 'ring' around the button. Default color is the `tintColor`.
     */
    @IBInspectable public var borderColor: UIColor {
        get { return _borderColor ?? tintColor }
        set { _borderColor = newValue }
    }
    
    private var _fillColor: UIColor? {
        didSet {
            let color: UIColor = _fillColor ?? tintColor
            filledView.backgroundColor = color
        }
    }
    
    /**
     The color of the button fill. Default color is the `tintColor`.
     */
    @IBInspectable public var fillColor: UIColor {
        get { return _fillColor ?? tintColor }
        set { _fillColor = newValue }
    }

    /// The animation time the fill and unfill takes to animate.
    var animationInterval: RadioButtonAnimationInterval = .standard

    private func setupView() {
        backgroundColor = UIColor.clear
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 2.0
        isUserInteractionEnabled = true

        filledView = FilledView(parent: self)
        filledView.backgroundColor = fillColor
        
        addSubview(filledView)
        
        let centerX = NSLayoutConstraint(item: filledView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: filledView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0.0)
        
        
        
        addConstraints([centerX, centerY])

        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(RadioButton.tapGestureWasTriggered(_:)))
        addGestureRecognizer(tap)
    }

    // MARK: - Tapping
    @objc private func tapGestureWasTriggered(_ sender: UITapGestureRecognizer) {
        pressed = !pressed
    }


    // MARK: - Filling
    private func fillRadioButton() {
        guard filledView.isHidden else { return }
        
        filledView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animate(withDuration: animationInterval.value,
                       animations: {
                        self.filledView.isHidden = false
                        self.filledView.transform = CGAffineTransform.identity
                       })
    }

    private func unFillRadioButton() {
        guard !filledView.isHidden else { return }
        
        UIView.animate(withDuration: animationInterval.value,
                       animations: {
                        self.filledView.transform = CGAffineTransform(scaleX: 0.0001,
                                                                      y: 0.0001)
                       },
                       completion: { _ in
                        self.filledView.isHidden = true
                       })
    }
}
