//
//  File.swift
//  NotesApp
//
//  Created by @andreev2k on 18.01.2023.
//

import UIKit

extension MainVC: UISearchBarDelegate {
    func makeConstraints() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(140)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(190)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    
    //MARK:- SEARCH BAR DELEGATE METHOD FUNCTION
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        notesList = savedNotes.items
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    
    //MARK: Method searching for titles and notes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        notesList = searchText.isEmpty ? savedNotes.items : savedNotes.items.filter { (item) -> Bool in
            
            let items = item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            
            return items
        }
        
        if notesList.isEmpty {
            
            notesList = searchText.isEmpty ? savedNotes.items : savedNotes.items.filter { (item) -> Bool in
                
                let items = item.note.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                
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
