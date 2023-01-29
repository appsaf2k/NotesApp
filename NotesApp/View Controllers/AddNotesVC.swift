//
//  AddNotesVC.swift
//  NotesApp
//
//  Created by @andreev2k on 10.01.2023.
//

import UIKit


class AddNotesVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let imagePicker = UIImagePickerController()
    
    public var closure: ((String, NSAttributedString) -> Void)?
    var placeholderLabel: UILabel!
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let labelNewNote: UILabel = {
        let label  = UILabel()
        label.text = "New note"
        label.textAlignment = .center
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
        let text            = UITextView()
        text.font           = UIFont.systemFont(ofSize: 16)
        text.contentOffset  = CGPoint.zero
        text.textAlignment  = .left
        text.isEditable     = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleTextField.delegate = self
        noteTextView.delegate   = self
        imagePicker.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        titleTextField.becomeFirstResponder()
        addPlaceholderForNoteTextView()
        makeConstraints()
        addNavBar()
    }
    
    @objc private func addNavBar() {
        let addImageButton = UIBarButtonItem(customView: addImageButton)
        let saveButton = UIBarButtonItem(customView: doneButton)
        
        navigationItem.rightBarButtonItems = [saveButton, addImageButton]
    }
    
    @objc private func tapSave() {
        if !titleTextField.text!.isEmpty && !noteTextView.text.isEmpty {
            closure?(titleTextField.text!, noteTextView.attributedText)
        }
        
        navigationController?.pushViewController(MainVC(), animated: false)
    }
    
    //MARK: Switch to next textView after tap "Return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField {
            textField.resignFirstResponder()
            noteTextView.becomeFirstResponder()
        }
        return true
    }
    
    //MARK: Show placeholder if noteTextView empty
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
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

//MARK: For resized image from noteTextView
extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let height = CGFloat(ceil(width / size.width * size.height))
        let canvasSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
