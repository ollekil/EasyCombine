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

/// 인트로 화면을 관리하는 뷰 컨트롤러
class IntroViewController: UIViewController {
    
    var viewModel: IntroViewModel!
    var cancellables = Set<AnyCancellable>()
    var coordinator: AppCoordinator?  // 화면 전환을 담당하는 코디네이터

    /// 커스텀 뷰를 사용하여 UI 구성
    private let introView = IntroView()

    /// 기본 뷰를 커스텀 뷰로 변경
    override func loadView() {
        view = introView
    }

    /// 화면이 로드된 후 실행되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.startStoryAnimation()
        
        // 버튼 클릭 시 게임 화면으로 이동
        introView.startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }

    /// ViewModel과 UI를 연결 (Combine 사용)
    private func bindViewModel() {
        // 현재 스토리 텍스트 업데이트
        viewModel.currentStoryText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.introView.storyLabel.text = text
            }
            .store(in: &cancellables)

        // 캐릭터 등장 트리거
        viewModel.showCharacter
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showCharacter() }
            .store(in: &cancellables)

        // 배경 등장 트리거
        viewModel.showBackground
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showBackground() }
            .store(in: &cancellables)

        // 시작 버튼 등장 트리거
        viewModel.showStartButton
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showStartButton() }
            .store(in: &cancellables)
    }

    /// 캐릭터 등장 애니메이션
    private func showCharacter() {
        introView.characterImageView.alpha = 1
        UIView.animate(withDuration: 2.0, animations: {
            self.introView.characterImageView.transform = CGAffineTransform.identity
        }) { _ in
            self.viewModel.showBackground.send(())
        }
    }

    /// 배경 등장 애니메이션
    private func showBackground() {
        UIView.animate(withDuration: 2.0, animations: {
            self.introView.backgroundImageView.alpha = 1
        }) { _ in
            self.viewModel.showStartButton.send(())
        }
    }

    /// 시작 버튼 등장 애니메이션
    private func showStartButton() {
        UIView.animate(withDuration: 1.5) {
            self.introView.startButton.alpha = 1
        }
    }

    /// 모험 시작 버튼 클릭 시 게임 화면으로 이동
    @objc private func startGame() {
        coordinator?.navigateToMazeViewController()  // AppCoordinator를 통해 이동
    }
}
