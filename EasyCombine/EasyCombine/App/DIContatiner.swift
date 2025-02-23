//
//  DIContatiner.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 앱의 진입점과 핵심 관리 역할
   - 의존성 주입 컨테이너
 */

import UIKit

/// ✅ 의존성 주입 컨테이너
final class DIContainer {
    let navigationController: UINavigationController
    let appCoordinator: AppCoordinator

    /// ✅ DIContainer 초기화
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.appCoordinator = AppCoordinator(navigationController: navigationController)
    }

    /// ✅ MainViewController 생성 및 주입
    func makeMainViewController() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        let repository = UserDefaultsCharacterRepository()
        let useCase = DefaultSelectCharacterUseCase(repository: repository)
        
        viewController.viewModel = MainViewModel(useCase: useCase, coordinator: appCoordinator) // ✅ viewModel 주입
        viewController.coordinator = appCoordinator  // ✅ coordinator 주입 (추가)

        return viewController
    }

    /// ✅ IntroViewController 생성 및 주입
    func makeIntroViewController() -> IntroViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        
        let repository = DefaultIntroStoryRepository()
        let useCase = FetchIntroStoryUseCase(repository: repository)
        
        viewController.viewModel = IntroViewModel(fetchIntroStoryUseCase: useCase)
        viewController.coordinator = appCoordinator
        
        return viewController
    }

    /// MazeViewController 생성 및 주입
     func makeMazeViewController() -> MazeViewController {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let viewController = storyboard.instantiateViewController(withIdentifier: "MazeViewController") as! MazeViewController

         let userRepository = DefaultUserRepository()
         let viewModel = MazeViewModel(userRepository: userRepository)

         viewController.viewModel = viewModel
         viewController.coordinator = appCoordinator
         viewController.delegate = appCoordinator  // AppCoordinator를 delegate로 설정

         return viewController
     }
}
