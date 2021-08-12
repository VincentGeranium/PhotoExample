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
        view.addSubview(masterTableView)
    }
    
    // Called to notify the view controller that its view has just laid out its subviews.
    override func viewDidLayoutSubviews() {
        masterTableView.frame = view.bounds
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionLocailzedTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MasterTableViewCell.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "asd"
        return cell
    }
    
    
}
