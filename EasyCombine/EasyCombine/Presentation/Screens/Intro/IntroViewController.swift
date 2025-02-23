//
//  IntroViewController.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/19/25.
//

/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 미로 화면
       - 미로 화면 뷰 컨트롤러
 */
/*!<
 
 */

import UIKit
import Combine

/// ✅ 인트로 화면의 뷰 컨트롤러 (화면 흐름 관리)
class IntroViewController: UIViewController {
    
    var viewModel: IntroViewModel!
    var cancellables = Set<AnyCancellable>()
    var coordinator: AppCoordinator?  // ✅ AppCoordinator 추가 (화면 전환 담당)

    /// ✅ UI를 담당하는 뷰 (뷰 컨트롤러가 직접 UI를 다루지 않음)
    private let introView = IntroView()

    /// ✅ 생성자 (스토리보드 기반 초기화)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        // 🔹 의존성 주입 (UseCase → ViewModel)
        let repository = DefaultIntroStoryRepository()
        let useCase = FetchIntroStoryUseCase(repository: repository)
        self.viewModel = IntroViewModel(fetchIntroStoryUseCase: useCase)
    }

    /// ✅ `loadView()`에서 커스텀 뷰를 설정
    override func loadView() {
        view = introView
    }

    /// ✅ 화면이 로드된 후 실행되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.startStoryAnimation()
        
        // ✅ 버튼 클릭 시 `AppCoordinator`를 통해 화면 전환
        introView.startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }

    /// ✅ ViewModel과 UI를 바인딩 (Combine 사용)
    private func bindViewModel() {
        viewModel.currentStoryText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.introView.storyLabel.text = text
            }
            .store(in: &cancellables)

        viewModel.showCharacter
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showCharacter() }
            .store(in: &cancellables)

        viewModel.showBackground
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showBackground() }
            .store(in: &cancellables)

        viewModel.showStartButton
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showStartButton() }
            .store(in: &cancellables)
    }

    /// ✅ 캐릭터 등장 애니메이션
    private func showCharacter() {
        introView.characterImageView.alpha = 1
        UIView.animate(withDuration: 2.0, animations: {
            self.introView.characterImageView.transform = CGAffineTransform.identity
        }) { _ in
            self.viewModel.showBackground.send(())
        }
    }

    /// ✅ 배경 등장 애니메이션
    private func showBackground() {
        UIView.animate(withDuration: 2.0, animations: {
            self.introView.backgroundImageView.alpha = 1
        }) { _ in
            self.viewModel.showStartButton.send(())
        }
    }

    /// ✅ 시작 버튼 등장 애니메이션
    private func showStartButton() {
        UIView.animate(withDuration: 1.5) {
            self.introView.startButton.alpha = 1
        }
    }

    /// ✅ 모험 시작 버튼 클릭 시 `MazeViewController`로 이동
    @objc private func startGame() {
        coordinator?.navigateToMazeViewController()  // ✅ `AppCoordinator`를 통해 이동하도록 변경
    }
}
