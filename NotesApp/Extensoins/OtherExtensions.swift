//
//  Extensions.swift
//  NotesApp
//
//  Created by @andreev2k on 10.01.2023.
//

import UIKit
//MARK: Custom UILabel for highlighting text in notes when searching in Table(TextLabel, detailTextLabel)
extension UILabel {
    func highlight(text: String?, font: UIFont? = nil, forColor: UIColor? = nil, backColor: UIColor? = nil) {
        guard let fullText = self.text, let target = text else {
            return
        }
        
        let attribText = NSMutableAttributedString(string: fullText)
        let range: NSRange = attribText.mutableString.range(of: target, options: .caseInsensitive)
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let font = font {
            attributes[.font] = font
        }
        if let forColor = forColor {
            attributes[.foregroundColor] = forColor
        }
        if let backColor = backColor {
            attributes[.backgroundColor] = backColor
        }
        
        
        attribText.addAttributes(attributes, range: range)
        self.attributedText = attribText
    }
}

//MARK: Custom Navigation Bar
extension UIViewController {
    
    func customButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor                  = .systemBlue
        button.imageView?.contentMode     = .scaleAspectFit
        button.contentVerticalAlignment   = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
    
    func editableButton(isEditable: Bool, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setTitle(isEditable ? "Done" : "Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}











