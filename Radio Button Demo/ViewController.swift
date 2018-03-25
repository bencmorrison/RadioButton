//
//  ViewController.swift
//  Radio Button Demo
//
//  Created by Ben Morrison on 4/2/18.
//  Copyright © 2018 Benjamin C Morrison. All rights reserved.
//

import UIKit
import RadioButton

class ViewController: UIViewController {
    @IBOutlet var singleGroup: [RadioButton]!
    @IBOutlet var multiGroup: [RadioButton]!
    @IBOutlet var allButtons: [RadioButton]!
    
    @IBOutlet var singleKeepOnePressed: UISwitch!
    @IBOutlet var multiKeepOnePressed: UISwitch!
    
    var singleSelectionGroup = RadioButtonGroup()
    var multipleSectionGroup = RadioButtonGroup(selectionStyle: .multiple)
    
    @IBOutlet var borderRedSlider: UISlider!
    @IBOutlet var borderGreenSlider: UISlider!
    @IBOutlet var borderBlueSlider: UISlider!
    
    @IBOutlet var fillRedSlider: UISlider!
    @IBOutlet var fillGreenSlider: UISlider!
    @IBOutlet var fillBlueSlider: UISlider!
    
    @IBOutlet var backgroundSlider: UISlider!
    @IBOutlet var keepSelectedTextGroup: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleSelectionGroup.keepOnePressed = singleKeepOnePressed.isOn
        singleSelectionGroup.add(buttons: singleGroup)
        
        multipleSectionGroup.keepOnePressed = multiKeepOnePressed.isOn
        multipleSectionGroup.add(buttons: multiGroup)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let button = singleGroup.first!
        setBorderSliders(toColor: button.borderColor)
        setFillSilders(toColor: button.fillColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchDidChangeValue(_ sender: UISwitch) {
        if sender == singleKeepOnePressed {
            singleSelectionGroup.keepOnePressed = sender.isOn
        }
        else if sender == multiKeepOnePressed {
            multipleSectionGroup.keepOnePressed = sender.isOn
        }
    }
    
    private func setBorderSliders(toColor: UIColor) {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        
        toColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        borderRedSlider.value = Float(red)
        borderGreenSlider.value = Float(green)
        borderBlueSlider.value = Float(blue)
        
        updateBorderSliderThumb(withColor: toColor)
    }
    
    private func setFillSilders(toColor: UIColor) {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        
        toColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        fillRedSlider.value = Float(red)
        fillGreenSlider.value = Float(green)
        fillBlueSlider.value = Float(blue)
        
        updateFillSliderThumb(withColor: toColor)
    }
    
    @IBAction func borderSliderChanged(_ sender: UISlider) {
        let red = borderRedSlider.value
        let green = borderGreenSlider.value
        let blue = borderBlueSlider.value
        
        let color = UIColor(red: CGFloat(red),
                            green: CGFloat(green),
                            blue: CGFloat(blue),
                            alpha: 1.0)
        
        for b in allButtons {
            b.borderColor = color
        }
        
        updateBorderSliderThumb(withColor: color)
    }
    
    @IBAction func fillSliderChanged(_ sender: UISlider) {
        let red = fillRedSlider.value
        let green = fillGreenSlider.value
        let blue = fillBlueSlider.value
        
        let color = UIColor(red: CGFloat(red),
                            green: CGFloat(green),
                            blue: CGFloat(blue),
                            alpha: 1.0)
        
        for b in allButtons {
            b.fillColor = color
        }
        
        updateFillSliderThumb(withColor: color)
    }
    
    @IBAction func backgroundSliderChanged(_ sender: UISlider) {
        let whiteLevel = CGFloat(sender.value)
        view.backgroundColor = UIColor(white: whiteLevel, alpha: 1.0)
        
        if whiteLevel < 0.5 {
            for l in keepSelectedTextGroup {
                l.textColor = UIColor.white
            }
        }
        else {
            for l in keepSelectedTextGroup {
                l.textColor = UIColor.black
            }
        }
    }
    
    private func updateBorderSliderThumb(withColor: UIColor) {
        let thumbValues = adjustColorsForSliderThumb(forColor: withColor,
                                                     sliderValues: (borderRedSlider.value, borderGreenSlider.value, borderBlueSlider.value))
        borderRedSlider.thumbTintColor = UIColor(red: thumbValues.0, green: 0.0, blue: 0.0, alpha: 1.0)
        borderGreenSlider.thumbTintColor = UIColor(red: 0.0, green: thumbValues.1, blue: 0.0, alpha: 1.0)
        borderBlueSlider.thumbTintColor = UIColor(red: 0.0, green: 0.0, blue: thumbValues.2, alpha: 1.0)
    }
    
    private func updateFillSliderThumb(withColor: UIColor) {
        let thumbValues = adjustColorsForSliderThumb(forColor: withColor,
                                                     sliderValues: (fillRedSlider.value, fillGreenSlider.value, fillBlueSlider.value))
        fillRedSlider.thumbTintColor = UIColor(red: thumbValues.0, green: 0.0, blue: 0.0, alpha: 1.0)
        fillGreenSlider.thumbTintColor = UIColor(red: 0.0, green: thumbValues.1, blue: 0.0, alpha: 1.0)
        fillBlueSlider.thumbTintColor = UIColor(red: 0.0, green: 0.0, blue: thumbValues.2, alpha: 1.0)
    }
    
    typealias SilderPositions = (Float, Float, Float)
    private func adjustColorsForSliderThumb(forColor color: UIColor, sliderValues: SilderPositions) -> (CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let redMin = 0.25 as CGFloat
        let greenMin = 0.20 as CGFloat
        let blueMin = 0.35 as CGFloat
        
        let redMax = 1.0 - redMin
        let greenMax = 1.0 - greenMin
        let blueMax = 1.0 - blueMin
        
        red = (redMax * CGFloat(sliderValues.0)) + redMin
        green = (greenMax * CGFloat(sliderValues.1)) + greenMin
        blue = (blueMax * CGFloat(sliderValues.2)) + blueMin
        
        return (red, green, blue)
    }
}

