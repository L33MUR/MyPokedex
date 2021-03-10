//
//  Extensions.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 28/02/2021.
//

import UIKit

extension UIView {
    //For constraining views
    @objc public func anchor(
        top:        NSLayoutYAxisAnchor?,
        leading:    NSLayoutXAxisAnchor?,
        bottom:     NSLayoutYAxisAnchor?,
        trailing:   NSLayoutXAxisAnchor?,
        centerX:    NSLayoutXAxisAnchor?,
        centerY:    NSLayoutYAxisAnchor?,
        padding:    UIEdgeInsets = .zero,
        size:       CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint        (equalTo: top,      constant: padding.top).isActive = true
        }
        if let leading = leading{
            leadingAnchor.constraint    (equalTo: leading,  constant: padding.left).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint     (equalTo: bottom,   constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint   (equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let centerX = centerX{
            centerXAnchor.constraint    (equalTo: centerX).isActive = true
        }
        if let centerY = centerY{
            centerYAnchor.constraint    (equalTo: centerY).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint  (equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint (equalToConstant: size.height).isActive = true
        }
    }
}

extension UIColor {
    
    //UIColor from Hex color.
    @objc public convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        return nil
    }
}
