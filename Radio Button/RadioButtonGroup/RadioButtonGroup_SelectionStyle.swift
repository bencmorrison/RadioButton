//
// Created by Ben Morrison on 11/2/18.
// Copyright (c) 2018 Benjamin C Morrison. All rights reserved.
//

import Foundation

public extension RadioButtonGroup {
    /**
     In a `RadioButtonGroup` you can have only one selected or many selected (including all).
     */
    public enum SelectionStyle {
        /// Only one `RadioButton` can be selected at any one time.
        case single
        /// Any number of `RadioButton`s can be selected at any one time.
        case multiple
    }
}
