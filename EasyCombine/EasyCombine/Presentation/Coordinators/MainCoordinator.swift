//
//  MainCoordinator.swift
//  EasyCombine
//
//  Created by 배정길 on 2/14/25.
//

import UIKit

/// 화면 전환을 담당하는 코디네이터
protocol MainCoordinatorProtocol {
    func navigateToMazeViewController()
}

/// 실제 화면 전환을 수행하는 코디네이터
final class MainCoordinator: MainCoordinatorProtocol {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    /// MazeViewController로 이동
    func navigateToMazeViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let introVC = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
            navigationController?.pushViewController(introVC, animated: true)
        }
    }
}
