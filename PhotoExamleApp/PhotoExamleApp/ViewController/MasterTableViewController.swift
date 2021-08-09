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
    
    
    
    /*
     Discussion: Why did I create this property by lazy var?
     
     Because I want match the create time with 'addButton' and 'addAlbum' function.
     
     When I created this property by constant(let), this button which is 'addButton' that action is not excute.
     Because It's create time difference between the 'addButton' property and the 'addAlbum' function.
     
     If 'addButton' is create first, the button can see in the screen but not excute action.
     The reason of not excute action is when the button is already created but the action code is not create.
     So, no matter how to user tapped button, It's not excuted button action.
     That's why I did 'addButton' create by 'lazy var'
     */
    lazy var addButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                      target: self,
                                                      action: #selector(addAlbum(_:)))
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        self.navigationItem.rightBarButtonItem = addButton
        
        self.tableView.register(AllPhotosTableViewCell.self, forCellReuseIdentifier: AllPhotosTableViewCell.cellIdentifire)
        
        // Create a PHFetchResult objcet for each section in the table view.
        configurePHFetchOptions()
        
        // register ChangeObserver the 'MasterTableViewController' at PHPhotoLibrary.
        PHPhotoLibrary.shared().register(self)
    }
    
    /// - Tag: UnregisterChangeObserver
    deinit {
        // unregister ChangeObserver the 'MasterTableViewController' at PHPhotoLibrary.
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
    
    // MARK:- addAlbum function
    /// Create Album
    @objc private func addAlbum(_ sender: AnyObject) {
        let alertController = UIAlertController(title: NSLocalizedString("New Album", comment: ""),
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("New Album", comment: "")
        }
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: ""),
                                                style: .default,
                                                handler: { action in
                                                    guard let textField = alertController.textFields?.first else {
                                                        return
                                                    }
                                                    if let title = textField.text,
                                                       title.isEmpty == false {
                                                        // Create a new album with enterd title.
                                                        PHPhotoLibrary.shared().performChanges {
                                                            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                                                        } completionHandler: { result, error in
                                                            switch result {
                                                            case true:
                                                                print("Success to change")
                                                            case false:
                                                                print("Error occur: \(String(describing: error))")
                                                            }
                                                        }
                                                        
                                                    }
                                                })
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionValue = Section(rawValue: section) {
            switch sectionValue {
            case .allPhotos: return 1
            case .smartAlbums:
                if let smartAlbumCount = smartAlbums?.count {
                    return smartAlbumCount
                }
            case .userCollections:
                if let userCollectionsCount = userCollections?.count {
                    return userCollectionsCount
                }
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionValue = Section(rawValue: indexPath.row) else {
            print("Error occur: \(TableViewCellError.FailedToGetTableViewCell)")
            return UITableViewCell()
        }
        
        switch sectionValue {
        case .allPhotos:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.allPhotos.rawValue, for: indexPath)
            print("Success : \(TableViewCellError.SuccessToGetTableViewCell)")
            cell.textLabel?.text = NSLocalizedString("All Photos", comment: "")
            return cell
        default:
            print("Error occur: \(TableViewCellError.FailedToGetTableViewCell)")
            break
        }
        return UITableViewCell()
    }
}


extension MasterTableViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard var allPhotos = allPhotos else {
            return
        }
        
        DispatchQueue.main.async {
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }
        }
    }
    
    
}
