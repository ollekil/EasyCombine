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
    
    private var viewModel: IntroViewModel!  // 🔹 ViewModel 인스턴스 (데이터 및 로직 관리)
    private var cancellables = Set<AnyCancellable>()  // 🔹 Combine 구독을 저장하는 컬렉션
    
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

    /// ✅ `loadView()`에서 커스텀 뷰를 설정 (뷰 컨트롤러의 기본 뷰를 `IntroView`로 변경)
    override func loadView() {
        view = introView
    }

    /// ✅ 화면이 로드된 후 실행되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 🔹 ViewModel과 UI를 연결
        bindViewModel()
        
        // 🔹 인트로 스토리 애니메이션 시작
        viewModel.startStoryAnimation()
        
        // 🔹 버튼 클릭 시 `startGame()` 호출
        introView.startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }

    /// ✅ ViewModel과 UI를 바인딩 (Combine 사용)
    private func bindViewModel() {
        // 🔹 현재 표시될 스토리 텍스트 업데이트
        viewModel.currentStoryText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.introView.storyLabel.text = text
            }
            .store(in: &cancellables)

        // 🔹 캐릭터 등장 트리거
        viewModel.showCharacter
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.showCharacter()
            }
            .store(in: &cancellables)

        // 🔹 배경 등장 트리거
        viewModel.showBackground
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.showBackground()
            }
            .store(in: &cancellables)

        // 🔹 시작 버튼 등장 트리거
        viewModel.showStartButton
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.showStartButton()
            }
            .store(in: &cancellables)
    }

    /// ✅ 캐릭터 등장 애니메이션 (크기가 점점 커지면서 등장)
    private func showCharacter() {
        introView.characterImageView.alpha = 1
        UIView.animate(withDuration: 2.0, animations: {
            self.introView.characterImageView.transform = CGAffineTransform.identity // 🔹 원래 크기로 복귀
        }) { _ in
            self.viewModel.showBackground.send(()) // 🔹 애니메이션이 끝나면 배경 등장
        }
    }

    /// ✅ 배경 등장 애니메이션 (서서히 나타남)
    private func showBackground() {
        UIView.animate(withDuration: 2.0, animations: {
            self.introView.backgroundImageView.alpha = 1
        }) { _ in
            self.viewModel.showStartButton.send(()) // 🔹 배경이 완전히 나타나면 버튼 등장
        }
    }

    /// ✅ 시작 버튼 등장 애니메이션
    private func showStartButton() {
        UIView.animate(withDuration: 1.5) {
            self.introView.startButton.alpha = 1
        }
    }

    /// ✅ 모험 시작 버튼 클릭 시 게임 화면으로 이동
    @objc private func startGame() {
        let gameVC = MazeViewController()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: false)
    }
}
