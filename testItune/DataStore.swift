//
//  Datastore.swift
//  testItune
//
//  Created by Apple on 30/06/19.
//  Copyright © 2019 Jp.LLC. All rights reserved.
//

import Foundation
import UIKit

final class DataStore {
    
    static let sharedInstance = DataStore()
    fileprivate init() {}
    
    var audiobooks: [ItuneFile] = []
    var images: [UIImage] = []
    
    func getBooks(completion: @escaping () -> Void) {
        
        APIClient.getAudiobooksAPI { (json) in
            let feed = json?["feed"] as? ItuneartJSON
            if let results = feed?["results"] as? [ItuneartJSON] {
                for dict in results {
                    let newItunefile = ItuneFile(dictionary: dict)
                    self.audiobooks.append(newItunefile)
                }
                completion()
            }
        }
    }
    
    func getBookImages(completion: @escaping () -> Void) {
        getBooks {
            for book in self.audiobooks {
                let url = URL(string: book.coverImage)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    self.images.append(image!)
                }
            }
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }
}
