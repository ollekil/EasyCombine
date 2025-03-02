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

/// 의존성 주입을 관리하는 컨테이너 클래스
/// 앱의 주요 객체들을 생성하고 필요한 의존성을 주입하는 역할을 한다.
final class DIContainer {
    let navigationController: UINavigationController
    let appCoordinator: AppCoordinator

    /// DIContainer 초기화
    /// - Parameter navigationController: 앱의 내비게이션 컨트롤러
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.appCoordinator = AppCoordinator(navigationController: navigationController)
        self.appCoordinator.diContainer = self // DIContainer를 AppCoordinator에 연결
    }

    /// MainViewController 생성 및 의존성 주입
    /// - Returns: MainViewController 인스턴스
    func makeMainViewController() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        // 캐릭터 선택 관련 유스케이스 및 저장소 생성
        let repository = UserDefaultsCharacterRepository()
        let useCase = DefaultSelectCharacterUseCase(repository: repository)
        
        // ViewModel만 주입 (Coordinator 제거)
        viewController.viewModel = MainViewModel(useCase: useCase)
        viewController.coordinator = appCoordinator // ViewController에서 직접 사용

        return viewController
    }

    /// IntroViewController 생성 및 의존성 주입
    /// - Returns: IntroViewController 인스턴스
    func makeIntroViewController() -> IntroViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        
        // 인트로 스토리 관련 유스케이스 및 저장소 생성
        let repository = DefaultIntroStoryRepository()
        let useCase = FetchIntroStoryUseCase(repository: repository)
        
        // ViewModel과 Coordinator를 주입
        viewController.viewModel = IntroViewModel(fetchIntroStoryUseCase: useCase)
        viewController.coordinator = appCoordinator

        return viewController
    }
    
    /// FieldViewController 생성 및 의존성 주입
    /// - Returns: FieldViewController 인스턴스
    func makeFieldViewController() -> FieldViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FieldViewController") as! FieldViewController
        
        // 의존성 주입 (UseCase 및 ViewModel 추가)
        let repository = DialogueRepository()
        let useCase = FieldUseCase(repository: repository)
        let viewModel = FieldViewModel(useCase: useCase)
        
        viewController.viewModel = viewModel
        viewController.coordinator = appCoordinator
        
        return viewController
    }
}
