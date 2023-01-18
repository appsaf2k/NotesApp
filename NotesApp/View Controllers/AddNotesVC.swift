//
//  AddNotesVC.swift
//  NotesApp
//
//  Created by @andreev2k on 10.01.2023.
//

import UIKit


class AddNotesVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    public var closure: ((String, String) -> Void)?
    var placeholderLabel: UILabel!
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let labelNewNote: UILabel = {
        let label  = UILabel()
        label.text = "New note"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleTextField: UITextField = {
        let text         = UITextField()
        text.placeholder = "Note title"
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let noteTextView: UITextView = {
        let text        = UITextView()
        text.font       = UIFont.systemFont(ofSize: 16)
        text.isEditable = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor    = .white
        titleTextField.delegate = self
        noteTextView.delegate   = self
        
        titleTextField.becomeFirstResponder()
        addPlaceholderForNoteTextView()
        makeConstraints()
    }
    
    @objc private func tapSave() {
        if !titleTextField.text!.isEmpty && !noteTextView.text.isEmpty {
            closure?(titleTextField.text!, noteTextView.text)
        }
        dismiss(animated: true)
    }
    
    //MARK: Switch to next textView after tap "Return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField {
            textField.resignFirstResponder()
            noteTextView.becomeFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
