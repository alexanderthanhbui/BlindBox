//
//  SettingsTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 4/5/16.
//  Copyright © 2016 Animenim. All rights reserved.
//

import Foundation

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var locationSlider: UISlider!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBAction func unwindToSettingsScreen(_ segue:UIStoryboardSegue) {
    }
    @IBAction func valueChanged(_ sender: AnyObject) {
        let currentValue = Int(locationSlider.value)
        locationLabel.text = "\(currentValue)mi."
    }
    @IBAction func valueChangeEnd(_ sender: AnyObject) {
        UserDefaults.standard.set(locationSlider.value, forKey: "slider_value")
    }
    @IBOutlet weak var minAgeSlider: UISlider!
    @IBAction func minAgeValueChanged(_ sender: AnyObject) {
        let maxInt = Int(maxAgeSlider.value)
        let maxFloat = Float(maxInt)
        let maxValue: Float = maxFloat
        if (sender as! UISlider).value > maxValue {
            (sender as! UISlider).value = maxValue
        }
        let currentValue = Int(minAgeSlider.value)
        minAgeLabel.text = "\(currentValue)"

    }
    @IBAction func minAgeValueChangeEnd(_ sender: AnyObject) {
        UserDefaults.standard.set(minAgeSlider.value, forKey: "min_age_slider_value")
    }
    @IBOutlet weak var maxAgeSlider: UISlider!
    
    @IBAction func maxAgeValueChanged(_ sender: AnyObject) {
        let minInt = Int(minAgeSlider.value)
        let minFloat = Float(minInt)
        let minValue: Float = minFloat
        if (sender as! UISlider).value < minValue {
            (sender as! UISlider).value = minValue
        }
        let currentValue = Int(maxAgeSlider.value)
        if currentValue == 65 {
            maxAgeLabel.text = "\(currentValue)+"
        }
        else{
            maxAgeLabel.text = "\(currentValue)"
        }
    }
    
    @IBAction func maxAgeValueChangeEnd(_ sender: AnyObject) {
        UserDefaults.standard.set(maxAgeSlider.value, forKey: "max_age_slider_value")
    }
    
    // Minimum Timeline Code
    @IBOutlet weak var minTimeline: UISlider!
    @IBOutlet weak var minTimelineLabel: UILabel!
    @IBAction func minTimelineValueChanged(_ sender: AnyObject) {
        let maxInt = Int(maxTimelineSlider.value)
        let maxFloat = Float(maxInt)
        let maxValue: Float = maxFloat
        if (sender as! UISlider).value > maxValue {
            (sender as! UISlider).value = maxValue
        }
        let currentValue = Int(minTimeline.value)
        
        if currentValue == 0 {
            minTimelineLabel.text = "Now"
        }
        else if currentValue == 1 {
            minTimelineLabel.text = "\(currentValue) Day"
        }
        else {
            minTimelineLabel.text = "\(currentValue) Days"
        }
    }
    
    //Maximum Timeline Code
    @IBOutlet weak var maxTimelineSlider: UISlider!
    @IBOutlet weak var maxTimelineLabel: UILabel!
    @IBAction func maxTimelineValueChanged(_ sender: AnyObject) {
        let maxInt = Int(minTimeline.value)
        let maxFloat = Float(maxInt)
        let maxValue: Float = maxFloat
        if (sender as! UISlider).value < maxValue {
            (sender as! UISlider).value = maxValue
        }
        let currentValue = Int(maxTimelineSlider.value)
        
        if currentValue == 0 {
            maxTimelineLabel.text = "Now"
        }
        else if currentValue == 1 {
            maxTimelineLabel.text = "\(currentValue) Day"
        }
        else {
            maxTimelineLabel.text = "\(currentValue) Days"
        }
    }
    @IBAction func maxTimelineValueChangedEnd(_ sender: AnyObject) {
            UserDefaults.standard.set(maxTimelineSlider.value, forKey: "max_timeline_slider_value")
    }
    
    //Minimum BlindBox Size Code
    @IBOutlet weak var minBlindBoxSizeSlider: UISlider!
    @IBOutlet weak var minBlindBoxSizeLabel: UILabel!
    @IBAction func minBlindBoxValueChanged(_ sender: AnyObject) {
        let maxInt = Int(maxBlindBoxSizeSlider.value)
        let maxFloat = Float(maxInt)
        let maxValue: Float = maxFloat
        if (sender as! UISlider).value > maxValue {
            (sender as! UISlider).value = maxValue
        }
        let currentValue = Int(minBlindBoxSizeSlider.value)
        
        if currentValue == 10 {
            minBlindBoxSizeLabel.text = "\(currentValue)+"
        }
        else {
            minBlindBoxSizeLabel.text = "\(currentValue)"
        }
    }
    @IBAction func minBlindBoxValueChangeEnd(_ sender: AnyObject) {
                UserDefaults.standard.set(minBlindBoxSizeSlider.value, forKey: "min_blindbox_slider_value")
    }
    
    //Maximum BlindBox Size Code
    @IBOutlet weak var maxBlindBoxSizeSlider: UISlider!
    @IBOutlet weak var maxBlindBoxSizeLabel: UILabel!
    @IBAction func maxBlindBoxValueChanged(_ sender: AnyObject) {
        let maxInt = Int(minBlindBoxSizeSlider.value)
        let maxFloat = Float(maxInt)
        let maxValue: Float = maxFloat
        if (sender as! UISlider).value < maxValue {
            (sender as! UISlider).value = maxValue
        }
        let currentValue = Int(maxBlindBoxSizeSlider.value)
        
        if currentValue == 10 {
            maxBlindBoxSizeLabel.text = "\(currentValue)+"
        }
        else {
            maxBlindBoxSizeLabel.text = "\(currentValue)"
        }
    }
    @IBAction func maxBlindBoxValueChangedEnd(_ sender: AnyObject) {
            UserDefaults.standard.set(maxBlindBoxSizeSlider.value, forKey: "max_blindbox_slider_value")
    }
    
    
    @IBAction func minTimelineValueChangedEnd(_ sender: AnyObject) {
        UserDefaults.standard.set(minTimeline.value, forKey: "min_timeline_slider_value")
    }
    
    @IBOutlet weak var minAgeLabel: UILabel!
    @IBOutlet weak var maxAgeLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //load view with persistent location value
        let sliderValue = UserDefaults.standard.float(forKey: "slider_value")
        let currentInt = Int(sliderValue)
        let currentString = String(currentInt)
        locationLabel.text = "\(currentString)mi."
        locationSlider.value = sliderValue
        
        //load view with persistent minimum age value
        let minAgeSliderValue = UserDefaults.standard.float(forKey: "min_age_slider_value")
        let minAgeCurrentInt = Int(minAgeSliderValue)
        let minAgeCurrentString = String(minAgeCurrentInt)
        if minAgeCurrentInt == 65 {
            minAgeLabel.text = "\(minAgeCurrentString)+"
        }
        else{
            minAgeLabel.text = "\(minAgeCurrentString)"
        }
        minAgeSlider.value = minAgeSliderValue
        
        //load view with persistent maximum age value
        let maxAgeSliderValue = UserDefaults.standard.float(forKey: "max_age_slider_value")
        let maxAgeCurrentInt = Int(maxAgeSliderValue)
        let maxAgeCurrentString = String(maxAgeCurrentInt)
        if maxAgeCurrentInt == 65 {
            maxAgeLabel.text = "\(maxAgeCurrentString)+"
        }
        else{
            maxAgeLabel.text = "\(maxAgeCurrentString)"
        }
        maxAgeSlider.value = maxAgeSliderValue
        
        //load view with persistent gender value
        let defaults = UserDefaults.standard
        let Gender = defaults.integer(forKey: "Gender")
        if Gender == 0 {
           genderLabel.text = "Only Men"
        }
        else if Gender == 1 {
            genderLabel.text = "Only Women"
            }
        else if Gender == 2 {
            genderLabel.text = "Men and Women"
        }
        
        //load view with persistent minimum timeline value
        let minTimelineSliderValue = UserDefaults.standard.float(forKey: "min_timeline_slider_value")
        let minTimelineCurrentInt = Int(minTimelineSliderValue)
        let minTimelineCurrentString = String(minTimelineCurrentInt)
        if minTimelineCurrentInt == 0 {
            minTimelineLabel.text = "Now"
        }
        else if minTimelineCurrentInt == 1 {
            minTimelineLabel.text = "\(minTimelineCurrentString) day"
        }
        else {
            minTimelineLabel.text = "\(minTimelineCurrentString) days"
        }
        minTimeline.value = minTimelineSliderValue
        
        //load view with persistent maximum timeline value
        let maxTimelineSliderValue = UserDefaults.standard.float(forKey: "max_timeline_slider_value")
        let maxTimelineCurrentInt = Int(maxTimelineSliderValue)
        let maxTimelineCurrentString = String(maxTimelineCurrentInt)
        if maxTimelineCurrentInt == 0 {
            maxTimelineLabel.text = "Now"
        }
        else if maxTimelineCurrentInt == 1 {
            maxTimelineLabel.text = "\(maxTimelineCurrentString) day"
        }
        else {
            maxTimelineLabel.text = "\(maxTimelineCurrentString) days"
        }
        maxTimelineSlider.value = maxTimelineSliderValue

        //load view with persistent minimum blindbox size value
        let minBlindBoxSliderValue = UserDefaults.standard.float(forKey: "min_blindbox_slider_value")
        let minBlindBoxSizeCurrentInt = Int(minBlindBoxSliderValue)
        let minBlindBoxSizeCurrentString = String(minBlindBoxSizeCurrentInt)
        if minBlindBoxSizeCurrentInt == 10 {
            minBlindBoxSizeLabel.text = "\(minBlindBoxSizeCurrentString)+"
        }
        else {
            minBlindBoxSizeLabel.text = "\(minBlindBoxSizeCurrentString)"
        }
        minBlindBoxSizeSlider.value = minBlindBoxSliderValue
        
        //load view with persistent maximum blindbox size value
        let maxBlindBoxSliderValue = UserDefaults.standard.float(forKey: "max_blindbox_slider_value")
        let maxBlindBoxSizeCurrentInt = Int(maxBlindBoxSliderValue)
        let maxBlindBoxSizeCurrentString = String(maxBlindBoxSizeCurrentInt)
        if maxBlindBoxSizeCurrentInt == 10 {
            maxBlindBoxSizeLabel.text = "\(maxBlindBoxSizeCurrentString)+"
        }
        else {
            maxBlindBoxSizeLabel.text = "\(maxBlindBoxSizeCurrentString)"
        }
        maxBlindBoxSizeSlider.value = maxBlindBoxSliderValue
    }
}
