//
//  AppCoordinator.swift
//  EasyCombine
//
//  Created by 배정길 on 2/14/25.
//

import UIKit

/// 화면 전환을 담당하는 코디네이터 프로토콜
protocol CoordinatorProtocol {
    func navigateToMazeViewController()
    func navigateToIntroViewController()
}

/// AppCoordinator - 전체 화면 전환을 담당
final class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var diContainer: DIContainer? // DIContainer 참조 추가

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /// 앱 시작 시 초기 화면 설정
    func start() {
        guard let diContainer = diContainer else { return }
        let mainVC = diContainer.makeMainViewController()
        navigationController.viewControllers = [mainVC]
    }

    /// MazeViewController로 이동
    func navigateToMazeViewController() {
        guard let diContainer = diContainer else { return }
        let mazeVC = diContainer.makeMazeViewController()
        mazeVC.delegate = self  // MazeViewController 종료 감지를 위해 delegate 설정
        navigationController.pushViewController(mazeVC, animated: true)
    }

    /// IntroViewController로 이동
    func navigateToIntroViewController() {
        guard let diContainer = diContainer else { return }
        let introVC = diContainer.makeIntroViewController()
        navigationController.pushViewController(introVC, animated: true)
    }
}

/// MazeViewControllerDelegate 구현
extension AppCoordinator: MazeViewControllerDelegate {
    func mazeViewDidDisappear() {
        print("MazeViewController가 닫혔습니다. (AppCoordinator에서 감지됨)")

        // MainViewController로 돌아갈 때, ViewModel 상태 초기화
        if let mainVC = navigationController.viewControllers.first(where: { $0 is MainViewController }) as? MainViewController {
            mainVC.viewModel.resetCharacterSize()
        }
    }
}
