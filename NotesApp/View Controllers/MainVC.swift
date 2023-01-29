//
//  ViewController.swift
//  NotesApp
//
//  Created by @andreev2k on 10.01.2023.
//

import UIKit
import SnapKit


class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    public var savedNotes    = SavedNotes()
    public var showNoteVC   = ShowNoteVC()
    public var notesList     = [(Items)]()
    
    lazy var searchBar: UISearchBar = {
        let search           = UISearchBar()
        search.placeholder   = "Search..."
        search.isHidden = true
        search.sizeToFit()
        search.isTranslucent = true
        return search
    }()
    
    //MARK: Table for view notes
    var tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .insetGrouped)
        table.scrollsToTop = true
        table.headerView(forSection: 0)
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
    
    let noteBookLabel: UILabel = {
        let label       = UILabel()
        label.text      = "notes"
        label.textColor = UIColor.black
        label.font      = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        configForviewDidLoad()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true

        tableView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(0)
                make.left.right.equalToSuperview().inset(0)
                make.bottom.equalToSuperview().inset(0)
            }
        UIView.animate(withDuration: 0.5) { [weak self] in
          self?.view.layoutIfNeeded()
        }
    }

    private func configForviewDidLoad() {
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.isEditing  = true
        tableView.contentInsetAdjustmentBehavior = .always
        searchBar.delegate   = self
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.titleView = noteBookLabel
        
        if savedNotes.items.isEmpty {
            savedNotes.items.append(Items(
                title: "Hello Everyone!",
                note: AttributedString("My name is Sergey and i have get place in school CFT")))
        }
        
        makeConstraints()
        addNavBar()
        clickHeandlerEditableButton()
        notesList = savedNotes.items
    }
    
    //MARK: Append button notes
    public func addNavBar() {
        let showSearchButton = customButton(imageName: "magnifyingglass", selector: #selector(showSearchBar))
        let addNoteButton = customButton(imageName: "square.and.pencil", selector: #selector(showAddNotes))

        navigationItem.rightBarButtonItems = [addNoteButton, showSearchButton]
    }
    
    //MARK: Button for editing table
    @objc private func clickHeandlerEditableButton() {
        let isEditing = self.tableView.isEditing
        
        let addEditButton = editableButton(isEditable: !isEditing, selector: #selector(clickHeandlerEditableButton))
    
        navigationItem.leftBarButtonItems = [addEditButton]
        self.tableView.reloadData()
        self.tableView.isEditing.toggle()
        self.searchBar.isHidden = false
        self.searchBar.searchTextField.endEditing(true)
        self.navigationController?.hidesBarsOnSwipe.toggle()
    }
    
    @objc private func showSearchBar() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems = []
        searchBar.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    //MARK: Method append Items
    @objc private func showAddNotes() {
        let addNotesVC = AddNotesVC()
        addNotesVC.closure = { title, note in

            let save = Items(title: title, note: AttributedString(note))
            self.savedNotes.items.insert(save, at: 0)
            self.notesList = self.savedNotes.items
            self.tableView.isHidden = false
            self.searchBar.isHidden = false
            self.tableView.reloadData()
        }
        
        self.searchBar.text = nil
        self.tableView.reloadData()
        
        navigationController?.pushViewController(addNotesVC, animated: true)
    }
    
    private func searchBarIsHidden() {
        self.searchBar.isHidden = true
    }
    
    //MARK: Number of lines
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notesList.count
    }
    
    //MARK: Upload table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        
        cell?.textLabel?.text = notesList[indexPath.row].title
        cell?.textLabel?.highlight(text: searchBar.text, backColor: .yellow.withAlphaComponent(0.7))
        
        
        cell?.detailTextLabel?.attributedText = NSAttributedString(notesList[indexPath.row].note)
        cell?.detailTextLabel?.highlight(text: searchBar.text, backColor: .yellow.withAlphaComponent(0.7))
        
        return cell!
    }
    
    //MARK: View select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        self.showNoteVC.highlightText = NSAttributedString(string: searchBar.text!)
        
        self.showNoteVC.titleTextView.text = notesList[indexPath.row].title
        self.showNoteVC.noteTextView.attributedText = NSAttributedString(notesList[indexPath.row].note)
        
        self.showNoteVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(showNoteVC, animated: true)
        
        
        //MARK: Edit notes
        if let row = self.savedNotes.items.firstIndex(where: {$0.id == notesList[indexPath.row].id}) {
            self.showNoteVC.closure = { title, note in
                self.savedNotes.items[indexPath.row].title = title
                self.savedNotes.items[indexPath.row].note = AttributedString(note)
                
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
        
        notesList = savedNotes.items
        self.tableView.reloadData()
        
    }
    
    //MARK: Delete element from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.savedNotes.items.remove(at: indexPath.row)
            self.notesList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            if savedNotes.items.isEmpty && notesList.isEmpty {
                self.label.isHidden = false
                self.tableView.isHidden = true
                searchBarIsHidden()
            }
        }
    }
    
    //MARK: Swipe gesture
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
           searchBarIsHidden()
           addNavBar()
       } else {
           searchBarIsHidden()
           addNavBar()
       }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "notes"
    }
}
