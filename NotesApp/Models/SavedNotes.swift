//
//  UserDefault.swift
//  NotesApp
//
//  Created by @andreev2k on 11.01.2023.
//

import Foundation



class SavedNotes {
    
    var items = [(Items)]() {
        didSet {
            //MARK: Encode array Items and save hear to the FileManager
            if let encode = try? JSONEncoder().encode(items) {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
                let fileUrl = documentDirectory.appendingPathComponent("Items")
                try? encode.write(to: fileUrl, options: .atomic)
                
            }
        }
    }

    init() {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileUrl = documentDirectory.appendingPathComponent("Items")
        do {
            //MARK: Get saved Items and decode them
            let savedItems = try Data(contentsOf: fileUrl)
            if let decodedItem = try? JSONDecoder().decode([(Items)].self, from: savedItems) {
                items = decodedItem
                return
            }
        } catch {}
        
        items = []
    }
}
