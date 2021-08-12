//
//  MasterTableViewCell.swift
//  PhotoExamleApp
//
//  Created by 김광준 on 2021/08/12.
//

import UIKit

class MasterTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "MasterTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
