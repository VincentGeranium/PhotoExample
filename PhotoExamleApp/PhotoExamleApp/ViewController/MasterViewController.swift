//
//  MasterViewController.swift
//  PhotoExamleApp
//
//  Created by 김광준 on 2021/08/12.
//

import UIKit
import Photos

class MasterViewController: UIViewController {
    
    // MARK:- Properties
    var allPhotos: PHFetchResult<PHAsset>?
    var smartAlbums: PHFetchResult<PHAssetCollection>?
    var userCollections: PHFetchResult<PHCollection>?
    
    var returnSection = 0
    /*
     c.f: Peurpose of 'sectionLocailzedTitles'
     This property that array type is will use for table view section titles.
     */
    let sectionLocailzedTitles = ["", NSLocalizedString("Smart Album", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    // MARK:- TableView computed property
    let masterTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(MasterTableViewCell.self, forCellReuseIdentifier: MasterTableViewCell.cellIdentifier)
        return tableView
    }()
    
    
    
    // MARK:- NavigationBarButton property
    /*
     시점에 관한 이슈로 인해 addButton이 동작하지 않았었다
     let으로 addButton을 생성시 앱 내에 + 버튼이 보이긴 했지만 눌러도 동작하지 않았고
     lazt var으로 addButton으로 수정 후 앱 내의 + 버튼이 동작했다.
     lazy와 생성 시점에 관한 여러가지 엮인 이슈들에 대해 공부할 필요가 있다.
     */
    lazy var addButton: UIBarButtonItem = {
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                             target: self,
                                                             action: #selector(addAlbum))
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        masterTableView.delegate = self
        masterTableView.dataSource = self
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = addButton
        createPHFetchResultObject()

        view.addSubview(masterTableView)
    }
    
    // Called to notify the view controller that its view has just laid out its subviews.
    override func viewDidLayoutSubviews() {
        masterTableView.frame = view.bounds
    }
    
    private func createPHFetchResultObject() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        guard var allPhotos = self.allPhotos,
              var smartAlbums = self.smartAlbums,
              var userCollections = self.userCollections else {
            return
        }
        
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                              subtype: .albumRegular,
                                                              options: nil)
        
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        PHPhotoLibrary.shared().register(self)
        
    }
    
    @objc private func addAlbum() {
        print("🎯Add Button is excute")
    }

}


extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let allPhotos = allPhotos,
           let smartAlbums = smartAlbums,
           let userCollections = userCollections {
            switch Section(rawValue: section) {
            case .allPhotos:
                returnSection = 1
                return returnSection
            case .smartAlbums:
                returnSection = smartAlbums.count
                return returnSection
            case .userCollection:
                returnSection = userCollections.count
                return returnSection
            case .none:
                print("Error: Can't get Section raw value")
                return 0
            }
           
        }
        return returnSection
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionLocailzedTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MasterTableViewCell.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "asd"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assetGridVC = AssetGridViewController()
        present(assetGridVC, animated: true) {
            print("Success to present assetGridVC")
        }
    }
    
    
}

extension MasterViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("have to write the code")
    }
    
    
}
