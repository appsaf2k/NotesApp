//
//  File2.swift
//  NotesApp
//
//  Created by @andreev2k on 18.01.2023.
//

import UIKit

extension ShowNoteVC {
    func makeConstraints() {
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.right.equalToSuperview().inset(32)
        }
        
        view.addSubview(noteTextView)
        noteTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    //MARK: highlighting text in notes when searching
    func generateAttributedString(with searchTerm: String, targetString: String) -> NSAttributedString? {
        
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let attributedString = NSMutableAttributedString(string: targetString, attributes: attributes)
        
        do {
            let regex = try NSRegularExpression(pattern: searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive)
            let range = NSRange(location: 0, length: targetString.utf16.count)
            for match in regex.matches(in: targetString.folding(options: .diacriticInsensitive, locale: .current), options: .withTransparentBounds, range: range) {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: match.range)
            }
            return attributedString
        } catch {
            NSLog("Error creating regular expresion: \(error)")
            return nil
        }
    }
}
