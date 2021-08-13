//
//  BaseNavigationController.swift
//  TableCollectionFeatures
//
//  Created by Alexander Khiger on 28.06.2021.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        topViewController
    }
    
}
