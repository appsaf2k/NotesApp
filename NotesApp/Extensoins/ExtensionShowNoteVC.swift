//
//  File2.swift
//  NotesApp
//
//  Created by @andreev2k on 18.01.2023.
//

import UIKit

extension ShowNoteVC: UIImagePickerControllerDelegate {
    func makeConstraints() {

        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.right.equalToSuperview().inset(32)
        }
        
        view.addSubview(noteTextView)
        noteTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    //MARK: highlighting text in notes when searching
    func generateAttributedString(searchText: NSAttributedString, targetText: NSAttributedString) -> NSAttributedString? {
        
        let attributedString = NSMutableAttributedString(attributedString: targetText)
        
        if searchText.string != "" {
            do {
                let regex = try NSRegularExpression(pattern: searchText.string.trimmingCharacters(in: .whitespacesAndNewlines).folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive)
                let range = NSRange(location: 0, length: targetText.string.utf16.count)
                for match in regex.matches(in: targetText.string.folding(options: .diacriticInsensitive, locale: .current), options: .withTransparentBounds, range: range) {
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: match.range)
                }
                return attributedString
            } catch {
                NSLog("Error creating regular expresion: \(error)")
                return nil
            }
        }
        
        let range: NSRange = attributedString.mutableString.range(of: targetText.string, options: .caseInsensitive)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        
        return attributedString
    }
}

