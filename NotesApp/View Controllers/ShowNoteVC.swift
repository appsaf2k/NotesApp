//
//  ShowNoteVC.swift
//  NotesApp
//
//  Created by @andreev2k on 10.01.2023.
//

import UIKit



class ShowNoteVC: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
        
    public var highlightText: NSAttributedString!
    public var closure: ((String, NSAttributedString) -> Void)?

    let imagePicker = UIImagePickerController()
    
    var titleTextView: UITextView = {
        let text             = UITextView()
        text.font            = UIFont.boldSystemFont(ofSize: 20)
        text.textAlignment   = .center
        text.isScrollEnabled = false
        text.layer.cornerRadius = 10
        text.sizeToFit()
        text.translatesAutoresizingMaskIntoConstraints = true
        return text
    }()
   
    var noteTextView: UITextView = {
        let text            = UITextView()
        text.font           = UIFont.systemFont(ofSize: 16)
        text.contentOffset  = CGPoint.zero
        text.textAlignment  = .left
        text.isEditable     = false
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor     = .white
        noteTextView.delegate    = self
        imagePicker.delegate     = self
        noteTextView.isEditable  = true
        titleTextView.isEditable = true
        noteTextView.attributedText = generateAttributedString(searchText: highlightText, targetText: noteTextView.attributedText)

        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if addImageButton.isHidden == false {
            editTextView()
        }
    }
    

    //MARK: Button loading for append new note
    @objc private func editTextView() {
        let addButton = editableButton(isEditable: addImageButton.isHidden, selector: #selector(editTextView))
        let imageButton = UIBarButtonItem(customView: addImageButton)
        navigationItem.rightBarButtonItems = [addButton, imageButton]
        
        addImageButton.isHidden.toggle()
        noteTextView.isEditable.toggle()
        titleTextView.isEditable.toggle()
        
        closure?(titleTextView.text!, noteTextView.attributedText)
    }
    
    //MARK: Pick image from gallery
    @objc private func pickImage() {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Method adding image for TextView
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // start with our text data
        let font = UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.black]
        
        let myString = NSMutableAttributedString(string: "\n \n", attributes: attributes)
        
        let attachment = NSTextAttachment()
        let image = info[.originalImage] as! UIImage
        let resizeImage = image.resized(toWidth: self.noteTextView.frame.size.width)
        
        attachment.image = resizeImage
        
        let imageString = NSAttributedString(attachment: attachment)
        
        myString.append(imageString)
        myString.append(NSAttributedString(string: "\n", attributes: attributes))
        
        // add this attributed string to the cusor position
        noteTextView.textStorage.insert(myString, at: noteTextView.selectedRange.location)
        picker.dismiss(animated: true, completion: nil)
    }
}


