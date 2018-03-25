//
// Created by Ben Morrison on 11/2/18.
// Copyright (c) 2018 Benjamin C Morrison. All rights reserved.
//

import Foundation
/**
 Groups together `RadioButton`s to allow management of multiple radio buttons at once.
 */
public class RadioButtonGroup: RadioButtonDelegate {
    // MARK: - Instance Variables
    /// When `true` this will ensure at least one buttton stays pressed in the group, once a button has been pressed in the group.
    public var keepOnePressed = false
    /// The selection style for the group.
    public let selectionStyle: SelectionStyle
    public weak var delegate: RadioButtonGroupDelegate?
    /// All the buttons living in the group
    public var groupButtons: [RadioButton] { return Array(buttons) }
    /// Controls the group animation interval, when set the group will adher to this interval instead of each individual button animation interval. If set to nil, all buttons will be set to `.standard`.
    public var radioButtonGroupAnimationInterval: RadioButtonAnimationInterval? {
        didSet {  for b in groupButtons {  b.animationInterval = radioButtonGroupAnimationInterval ?? .standard } }
    }

    private var buttons: [RadioButton] = []

    public init(selectionStyle: SelectionStyle = .single) {
        self.selectionStyle = selectionStyle
    }

    deinit {
        buttons.removeAll()
        pressedButtonIndexes.removeAll()
    }

    // MARK: - Adding Buttons
    public func add(button: RadioButton) {
        guard !buttons.contains(button) else { return }
        buttons.append(button)
        button.delegate = self
    }

    public func add(buttons: [RadioButton]) {
        for b in buttons {
            add(button: b)
            if let animationInterval = radioButtonGroupAnimationInterval {
                b.animationInterval = animationInterval
            }
        }
    }

    // MARK: - Remove Buttons
    public func remove(button: RadioButton) {
        guard let index = buttons.index(where: { $0 == button }) else { return }
        buttons.remove(at: index)
    }

    public func remove(buttons: [RadioButton]) {
        for b in buttons {
            remove(button: b)
        }
    }

    // MARK: -
    public func setDefaultPressed(button: RadioButton) {
        press(button: button)
    }

    public func setDefaultPressed(buttons: [RadioButton]) {
        for b in buttons {
            setDefaultPressed(button: b)
        }
    }

    // MARK: - RadioButtonDelegate
    public func shouldChangeStateForRadioButton(_ button: RadioButton) -> Bool {
        let willBePressed = !button.pressed

        if willBePressed {
            return true
        }
        
        var shouldChange = true
        
        if keepOnePressed {
            queue.sync {
                if self.pressedButtonIndexes.count < 2 {
                    shouldChange = false
                }
            }
        }
        
        return shouldChange
    }

    public func radioButton(_ button: RadioButton, pressStateChangedTo pressed: Bool) {
        if pressed {
            press(button: button)
        }
        else {
            unpress(button: button)
        }
    }

    // MARK: -
    private var pressedButtonIndexes: [Int] = []
    private var queue = DispatchQueue(label: "com.bencmorrison.radiobuttongroup",
                                      qos: .userInteractive,
                                      attributes: .concurrent,
                                      autoreleaseFrequency: .inherit,
                                      target: nil)
    private func press(button: RadioButton) {
        guard let index = buttons.index(where: {$0 == button}) else { return }

        var toUnpress: [RadioButton] = []
        if selectionStyle == .single {
            queue.sync {
                for i in self.pressedButtonIndexes {
                    toUnpress.append(self.buttons[i])
                }
            }
        }

        
        queue.sync(flags: .barrier) {
            self.pressedButtonIndexes.append(index)
        }
        
        button.pressed = true
        delegate?.radioButtonGroup(self, didPressRadioButton: button)
        
        for b in toUnpress {
            b.pressed = false
        }
    }

    private func unpress(button: RadioButton) {
        guard let index = buttons.index(where: {$0 == button}) else { return }

        button.pressed = false
        delegate?.radioButtonGroup(self, didUnpressRadioButton: button)
        
        guard let pressedindex = pressedButtonIndexes.index(where: { $0 == index}) else { return }
        
        queue.sync(flags: .barrier) {
            self.pressedButtonIndexes.remove(at: pressedindex)
        }
    }
}
