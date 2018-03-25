//
// Created by Ben Morrison on 11/2/18.
// Copyright (c) 2018 Benjamin C Morrison. All rights reserved.
//

import Foundation

/**
 */
public protocol RadioButtonGroupDelegate: class {
    func radioButtonGroup(_ group: RadioButtonGroup, didPressRadioButton button: RadioButton)
    func radioButtonGroup(_ group: RadioButtonGroup, didUnpressRadioButton button: RadioButton)
}
