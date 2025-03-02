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

    /// 인트로 화면으로 이동
    func navigateToIntroViewController() {
        guard let diContainer = diContainer else { return }
        let introVC = diContainer.makeIntroViewController()
        navigationController.pushViewController(introVC, animated: true)
    }
    
    /// 인트로 화면으로 이동
    func navigateToFieldViewController() {
        guard let diContainer = diContainer else { return }
        let introVC = diContainer.makeFieldViewController()
        navigationController.pushViewController(introVC, animated: true)
    }
}
