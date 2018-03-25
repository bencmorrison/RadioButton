//
// Created by Ben Morrison on 4/2/18.
// Copyright (c) 2018 Benjamin C Morrison. All rights reserved.
//

import Foundation

/**
 Allows fine control of the state of a `RadioButton`. You can prevent changes of the `pressed` state of the button and recieve updates when a button has changed it's state.
 */
public protocol RadioButtonDelegate: class {
    /**
     Allows the prevention of state change for a button. State change is defined as going from pressed to unpressed or vis a versa. If the method is not implemented the button will change state.

     - Parameter button: The button that is asking if it should change state.

     - Returns YES if the button should change state, and NO if the button should not change state.
     */
    func shouldChangeStateForRadioButton(_ button: RadioButton) -> Bool
    
    /**
     When a radio button has changed its pressed state this is called.
     
     - Parameters:
     - button: The radio button the made the change.
     - pressStateChangedTo: When true the button is pressed, when false the button is not pressed.
     */
    func radioButton(_ button: RadioButton, pressStateChangedTo: Bool)
}
