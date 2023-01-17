//
//  ViewController.swift
//  NotesApp
//
//  Created by @andreev2k on 10.01.2023.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var savedNotes    = SavedNotes()
    public var notesList     = [(Items)]()
    
    let searchBar: UISearchBar = {
        let search           = UISearchBar()
        search.placeholder   = "Search..."
        search.isTranslucent = true
        return search
    }()
    
    //MARK: Table for view notes
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: Label for view number of notes
    let label: UILabel = {
        let label       = UILabel()
        label.text      = "No notes yet"
        label.textColor = UIColor.lightGray
        label.font      = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate   = self
        tableView.dataSource = self
        searchBar.delegate   = self
        tableView.isEditing  = true
        title                = "Note Book"
        
        if savedNotes.items.isEmpty {
            savedNotes.items.append(Items(
                title: "Hello Everyone!",
                note: "My name is Sergey and i have get place in school CFT"))
        }
        
        makeConstraints()
        addNavBar()
        clickHeandlerEditableButton()
        notesList = savedNotes.items
    }
    
    //MARK: Append button notes
    @objc private func addNavBar() {
        let addButton = customButton(imageName: "square.and.pencil", selector: #selector(showAddNotes))
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    //MARK: Button for editing table
    @objc private func clickHeandlerEditableButton() {
        let isEditing = self.tableView.isEditing
        
        let addEditButton = editableButton(isEditable: !isEditing, selector: #selector(clickHeandlerEditableButton))
        navigationItem.leftBarButtonItems = [addEditButton]
        self.tableView.isEditing.toggle()
        self.searchBar.searchTextField.endEditing(true)
    }
    
    //MARK: Method append Items
    @objc private func showAddNotes() {
        let addNotesVC = AddNotesVC()
        addNotesVC.closure = { title, note in
            let save = Items(title: title, note: note)
            self.savedNotes.items.insert(save, at: 0)
            self.notesList = self.savedNotes.items
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        
        self.searchBar.text = nil
        self.searchBar.searchTextField.endEditing(true)
        self.tableView.reloadData()
        present(addNotesVC, animated: true)
    }
    
    //MARK: Number of lines
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notesList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = notesList[indexPath.row].title
        cell?.textLabel?.highlight(text: searchBar.text, backColor: .yellow.withAlphaComponent(0.7))
        cell?.detailTextLabel?.text = notesList[indexPath.row].note
        cell?.detailTextLabel?.highlight(text: searchBar.text, backColor: .yellow.withAlphaComponent(0.7))
        
        return cell!
    }
    
    //MARK: View select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = notesList[indexPath.row]
        
        let showNoteVC = ShowNoteVC()
        
        showNoteVC.highlightText = searchBar.text!
        
        showNoteVC.titleText = model.title
        showNoteVC.noteText = model.note
        
        showNoteVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(showNoteVC, animated: true)
        
        //MARK: Edit notes
        if let row = self.savedNotes.items.firstIndex(where: {$0.id == model.id}) {
            showNoteVC.closure = { title, note in
                
                self.savedNotes.items[row].title = title
                self.savedNotes.items[row].note = note
                
                //MARK: Adding parameters to by index for search in the searchBar
                self.notesList[indexPath.row].title = self.savedNotes.items[row].title
                self.notesList[indexPath.row].note = self.savedNotes.items[row].note
                
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Edit Table Row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveObject = savedNotes.items[sourceIndexPath.item]
        savedNotes.items.remove(at: sourceIndexPath.item)
        savedNotes.items.insert(moveObject, at: destinationIndexPath.item)
    }
    
    //MARK: Delete element from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.savedNotes.items.remove(at: indexPath.row)
            self.notesList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            if savedNotes.items.isEmpty && notesList.isEmpty{
                self.label.isHidden = false
                self.tableView.isHidden = true
            }
        }
    }
}
