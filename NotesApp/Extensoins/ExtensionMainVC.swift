//
//  File.swift
//  NotesApp
//
//  Created by @andreev2k on 18.01.2023.
//

import UIKit
import SnapKit


extension MainVC: UISearchBarDelegate {
    func makeConstraints() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(view.bounds.width)
            make.left.right.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
        }
    }
    
    //MARK:- SEARCH BAR DELEGATE METHOD FUNCTION
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        addNavBar()
        navigationItem.titleView = noteBookLabel
        searchBar.isHidden = true
        searchBar.text = nil
        notesList = savedNotes.items
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    
    //MARK: Method searching for titles and notes
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        notesList = searchText.isEmpty ? savedNotes.items : savedNotes.items.filter { (item) -> Bool in
            
            let items = item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            
            return items
        }
        
        if notesList.isEmpty {
            
            notesList = searchText.isEmpty ? savedNotes.items : savedNotes.items.filter { (item) -> Bool in
                
                let attrString = NSMutableAttributedString(item.note)
                
                let items = attrString.string.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                
                return items
            }
        }
        
        tableView.reloadData()
    }
    
    //MARK: Adding cancel button
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
