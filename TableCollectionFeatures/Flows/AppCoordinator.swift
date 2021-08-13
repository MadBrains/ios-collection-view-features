//
//  AppCoordinator.swift
//  TableCollectionFeatures
//
//  Created by Alexander Khiger on 28.06.2021.
//

import UIKit
import XCoordinator
import RxSwift
import RxCocoa

enum AppRoute: Route {
    
    case main
    
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    init() {
        super.init(rootViewController: BaseNavigationController(), initialRoute: .main)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .main:
            let vc = MainViewController()
            return .set([vc])
        }
    }

}
