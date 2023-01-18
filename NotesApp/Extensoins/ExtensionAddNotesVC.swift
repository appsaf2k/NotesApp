//
//  File1.swift
//  NotesApp
//
//  Created by @andreev2k on 18.01.2023.
//

import UIKit

extension AddNotesVC {
    func makeConstraints() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(labelNewNote)
        labelNewNote.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(labelNewNote.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(noteTextView)
        noteTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    //MARK: Custom placeholder for TextView
    func addPlaceholderForNoteTextView() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.font = .italicSystemFont(ofSize: (noteTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !noteTextView.text.isEmpty
        noteTextView.addSubview(placeholderLabel)
    }
}
