//
//  MasterTableViewController.swift
//  PhotoExamleApp
//
//  Created by 김광준 on 2021/08/08.
//

import UIKit
import Photos

class MasterTableViewController: UITableViewController {
    
    // MARK:- Properties
    /// Retrieves all assets matching the specified options.
    var allPhotos: PHFetchResult<PHAsset>?
    /// Retrieves asset collections of the specified type and subtype.
    var smartAlbums: PHFetchResult<PHAssetCollection>?
    /// Retrieves collections from the root of the photo library’s hierarchy of user-created albums and folders.
    var userCollections: PHFetchResult<PHCollection>?
    let sectionLocalizedTitles = [
        NSLocalizedString("All Photos", comment: ""),
        NSLocalizedString("Smart Albums", comment: ""),
        NSLocalizedString("Albums", comment: ""),
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        // Create a PHFetchResult objcet for each section in the table view.
        configurePHFetchOptions()
        
        // register ChangeObserver the 'MasterTableViewController' at PHPhotoLibrary.
        PHPhotoLibrary.shared().register(self)

    }
    
    /// - Tag: UnregisterChangeObserver
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    /// To list all the user’s albums and collections, the app creates a PHFetchOptions object and dispatches several fetch requests
    private func configurePHFetchOptions() {
        /// A set of options that affect the filtering, sorting, and management of results that Photos returns when you fetch asset or collection objects.
        let allPhotoOptions = PHFetchOptions()
        allPhotoOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate",
                             ascending: true)
        ]
        
        allPhotos = PHAsset.fetchAssets(with: allPhotoOptions)
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                              subtype: .albumRegular,
                                                              options: nil)
        
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }

   
}

extension MasterTableViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("Ok")
    }
    
    
}
