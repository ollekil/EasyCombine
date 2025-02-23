//
//  AppCoordinator.swift
//  EasyCombine
//
//  Created by 배정길 on 2/14/25.
//

import UIKit

/// 앱 전체 화면 전환을 담당하는 코디네이터
final class AppCoordinator {
    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /// 앱 시작 시 초기 화면 설정
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            mainVC.coordinator = self  // 코디네이터 주입
            navigationController.viewControllers = [mainVC]
        }
    }

    /// MazeViewController로 이동
    func navigateToMazeViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mazeVC = storyboard.instantiateViewController(withIdentifier: "MazeViewController") as? MazeViewController {
            navigationController.pushViewController(mazeVC, animated: true)
        }
    }

    /// IntroViewController로 이동
    func navigateToIntroViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let introVC = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
            navigationController.pushViewController(introVC, animated: true)
        }
    }
}
