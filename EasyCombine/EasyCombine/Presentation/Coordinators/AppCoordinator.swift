//
//  AppCoordinator.swift
//  EasyCombine
//
//  Created by 배정길 on 2/14/25.
//

import UIKit

/// 화면 전환을 담당하는 코디네이터 프로토콜
/// 특정 화면으로 이동하는 기능을 정의
protocol CoordinatorProtocol {
    func navigateToMazeViewController()
    func navigateToIntroViewController()
}

/// 앱의 네비게이션 흐름을 관리하는 코디네이터 클래스
final class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var diContainer: DIContainer? // DIContainer를 참조하여 화면을 생성

    /// 코디네이터 초기화
    /// - Parameter navigationController: 네비게이션 컨트롤러를 받아 화면 전환을 관리
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /// 앱이 시작될 때 첫 번째 화면을 설정
    func start() {
        guard let diContainer = diContainer else { return }
        let mainVC = diContainer.makeMainViewController()
        navigationController.viewControllers = [mainVC]
    }

    /// 미로(Maze) 화면으로 이동
    func navigateToMazeViewController() {
        guard let diContainer = diContainer else { return }
        let mazeVC = diContainer.makeMazeViewController()
        mazeVC.delegate = self  // 미로 화면이 닫혔을 때 이벤트를 받기 위해 delegate 설정
        navigationController.pushViewController(mazeVC, animated: true)
    }

    /// 인트로 화면으로 이동
    func navigateToIntroViewController() {
        guard let diContainer = diContainer else { return }
        let introVC = diContainer.makeIntroViewController()
        navigationController.pushViewController(introVC, animated: true)
    }
}

/// MazeViewController의 종료 이벤트를 처리하는 델리게이트 구현
extension AppCoordinator: MazeViewControllerDelegate {
    /// 미로 화면이 닫혔을 때 실행되는 메서드
    func mazeViewDidDisappear() {
        print("MazeViewController가 닫혔습니다. (AppCoordinator에서 감지됨)")

        // 메인 화면으로 돌아올 때, 캐릭터 크기를 초기화
        if let mainVC = navigationController.viewControllers.first(where: { $0 is MainViewController }) as? MainViewController {
            mainVC.viewModel.resetCharacterSize()
        }
    }
}
