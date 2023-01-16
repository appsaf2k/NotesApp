//
//  ShowNoteVC.swift
//  NotesApp
//
//  Created by @andreev2k on 10.01.2023.
//

import UIKit

class ShowNoteVC: UIViewController, UITextViewDelegate {
    public var closure: ((String, String) -> Void)?
    public var titleText: String = ""
    public var noteText: String  = ""
    private var toggle: Bool     = false
    
    var titleTextView: UITextView = {
        let text = UITextView()
        text.font = UIFont.boldSystemFont(ofSize: 20)
        text.textAlignment = .center
        text.sizeToFit()
        text.isScrollEnabled = false
        text.translatesAutoresizingMaskIntoConstraints = true
        return text
    }()
    
    var noteTextView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 16)
        text.isEditable = false
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor     = .white
        titleTextView.text       = titleText
        noteTextView.text        = noteText
        noteTextView.delegate    = self
        noteTextView.isEditable  = true
        titleTextView.isEditable = true
        
        makeConstraints()
        editTextView()
    }
    
    //MARK: Button loading for append new note
    @objc private func editTextView() {
        let addButton = editableButton(isEditable: toggle, selector: #selector(editTextView))
        navigationItem.rightBarButtonItems = [addButton]
        toggle.toggle()
        noteTextView.isEditable.toggle()
        titleTextView.isEditable.toggle()
        
        if !titleTextView.text!.isEmpty && !noteTextView.text.isEmpty {
            closure?(titleTextView.text!, noteTextView.text)
        }
        
        if toggle == false {
            noteTextView.becomeFirstResponder()
        }
    }
}
