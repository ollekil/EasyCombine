//
//  AppCoordinator.swift
//  EasyCombine
//
//  Created by 배정길 on 2/14/25.
//

import UIKit

/// ✅ 화면 전환을 담당하는 코디네이터 프로토콜
protocol CoordinatorProtocol {
    func navigateToMazeViewController()
    func navigateToIntroViewController()
}

/// ✅ AppCoordinator - 전체 화면 전환을 담당
final class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /// ✅ 앱 시작 시 초기 화면 설정
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            mainVC.coordinator = self  // ✅ 코디네이터 주입
            navigationController.viewControllers = [mainVC]
        }
    }

    /// ✅ MazeViewController로 이동
    func navigateToMazeViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mazeVC = storyboard.instantiateViewController(withIdentifier: "MazeViewController") as? MazeViewController {
//            mazeVC.coordinator = self
            navigationController.pushViewController(mazeVC, animated: true)
        }
    }

    /// ✅ IntroViewController로 이동
    func navigateToIntroViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let introVC = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
            introVC.coordinator = self
            navigationController.pushViewController(introVC, animated: true)
        }
    }
}
