//
//  Section.swift
//  PhotoExamleApp
//
//  Created by 김광준 on 2021/08/09.
//

import Foundation
import UIKit

// MARK:- Types for managing sections
enum Section: Int {
    case allPhotos = 0
    case smartAlbums = 1
    case userCollections = 2
    
    static let count = 3
}
