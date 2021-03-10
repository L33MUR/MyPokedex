//
//  Colors.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 05/03/2021.
//

import UIKit

import UIKit
import Foundation

//ThemeCandy
struct ThemePalette {
    let primary:String
    let secondary:String
    let tertiary:String
    let quaternary:String
    let titleText:String
    let subtitleText:String
}

//Green Theme

let aLightTheme  = ThemePalette(
    primary:        "#5a1297",
    secondary:      "#a3459a",
    tertiary:       "#e52d8a",
    quaternary:     "#c695c9",
    titleText:      "#dbdde6",
    subtitleText:   "#f9f9fb")


let aDarkTheme = ThemePalette(
    primary:        "#5c8d89",
    secondary:      "#74b49b",
    tertiary:       "#a7d7c5",
    quaternary:     "#f4f9f4",
    titleText:      "#f9f9f9",
    subtitleText:   "#f9f9f9")

enum Theme: Int {
    
    case lightTheme, darkTheme
    
    var primaryColor: UIColor {
        switch self {
            case .lightTheme:
                return UIColor(hex:aLightTheme.primary) ?? .white
            case .darkTheme:
                return UIColor(hex:aDarkTheme.primary) ?? .white
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
            case .lightTheme:
                return UIColor(hex:aLightTheme.secondary) ?? .white
            case .darkTheme:
                return UIColor(hex:aDarkTheme.secondary) ?? .white
        }
    }
    
    var tertiaryColor: UIColor {
        switch self {
            case .lightTheme:
                return UIColor(hex:aLightTheme.tertiary) ?? .white
            case .darkTheme:
                return UIColor(hex:aDarkTheme.tertiary) ?? .white
        }
    }
    
    var quaternaryColor: UIColor {
        switch self {
            case .lightTheme:
                return UIColor(hex:aLightTheme.quaternary) ?? .white
            case .darkTheme:
                return UIColor(hex:aDarkTheme.quaternary) ?? .white
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
            case .lightTheme:
                return UIColor(hex:aLightTheme.titleText) ?? .white
            case .darkTheme:
                return UIColor(hex:aDarkTheme.titleText) ?? .white
        }
    }
    var subtitleTextColor: UIColor {
        switch self {
            case .lightTheme:
                return UIColor(hex:aLightTheme.subtitleText) ?? .white
            case .darkTheme:
                return UIColor(hex:aDarkTheme.subtitleText) ?? .white
        }
    }
    
    //Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
            case .lightTheme:
                return .default
            case .darkTheme:
                return .black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .lightTheme ? UIImage(named: "navBackground") : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .lightTheme ? UIImage(named: "tabBarBackground") : nil
    }
}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
class ThemeManager {
    
    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .darkTheme
        }
    }
    
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.primaryColor
        
        
        navigationBarTheme(theme)
        ///tabBarTheme(theme)
        ///controlTheme(theme)
    }
    
    fileprivate static func navigationBarTheme(_ theme: Theme) {
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
    }
    
    fileprivate static func tabBarTheme(_ theme: Theme) {
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
    }
    
    fileprivate static func controlTheme(_ theme: Theme) {
        let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
        
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
        
        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
                                                    .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
                                                    .withRenderingMode(.alwaysTemplate)
                                                    .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)
        
        UISwitch.appearance().onTintColor = theme.primaryColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.primaryColor
    }
    
}

@objc class ThemeManagerObjC: NSObject {

    @objc class func primaryColor()-> UIColor {return ThemeManager.currentTheme().primaryColor}
    @objc class func secondaryColor()-> UIColor {return ThemeManager.currentTheme().secondaryColor}
    @objc class func tertiaryColor()-> UIColor {return ThemeManager.currentTheme().tertiaryColor}
    @objc class func quaternaryColor()-> UIColor {return ThemeManager.currentTheme().quaternaryColor}
    @objc class func titleTextColor()-> UIColor {return ThemeManager.currentTheme().titleTextColor}
    @objc class func subtitleTextColor()-> UIColor {return ThemeManager.currentTheme().subtitleTextColor}

}
