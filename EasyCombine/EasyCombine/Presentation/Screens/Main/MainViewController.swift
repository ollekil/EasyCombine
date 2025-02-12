//
//  MainViewController.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 메인 화면
       - 메인 화면 뷰 컨트롤러
 */

import UIKit
import Combine

/// Main 화면의 ViewController
/// - 캐릭터 선택 기능을 처리하며, ViewModel과 연결하여 UI 업데이트를 담당함.
class MainViewController: UIViewController {
    // 말풍선 텍스트를 표시하는 UILabel
    @IBOutlet weak var balloonLabel: UILabel!
    
    // 캐릭터 이미지 (초딩, 중딩, 고딩)
    @IBOutlet weak var character1: UIImageView!
    @IBOutlet weak var character2: UIImageView!
    @IBOutlet weak var character3: UIImageView!

    /// ViewModel 인스턴스 (UI 상태 및 로직 관리)
    private var viewModel: MainViewModel!
    
    /// Combine에서 사용되는 구독 관리 객체
    private var cancellables = Set<AnyCancellable>()

    /// 초기 캐릭터 위치 (배열 순서: [초딩, 중딩, 고딩])
    private var characterPositions: [CGPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaults를 사용하여 선택한 캐릭터 데이터를 관리하는 Repository 생성
        let repository = UserDefaultsCharacterRepository()
        
        // UseCase를 생성하여 캐릭터 선택 로직을 관리
        let useCase = DefaultSelectCharacterUseCase(repository: repository)
        
        // ViewModel을 생성하여 UI와 데이터 바인딩
        viewModel = MainViewModel(useCase: useCase)

        // UI와 데이터 바인딩 설정
        setupBindings()
        
        // 초기 캐릭터 위치 설정
        setupInitialPositions()
    }

    /// ViewModel과 UI를 연결하여 데이터가 변경될 때 자동 업데이트되도록 설정
    private func setupBindings() {
        // 말풍선 텍스트 변경을 감지하여 UI 업데이트
        viewModel.$balloonText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.balloonLabel.text = text
            }
            .store(in: &cancellables)
        
        // 선택한 캐릭터 변경을 감지하여 캐릭터 위치를 업데이트
        viewModel.$selectedCharacter
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rotateCharacters()
            }
            .store(in: &cancellables)
    }

    /// 캐릭터들의 초기 위치를 저장 (앱 실행 후 첫 위치를 기억)
    private func setupInitialPositions() {
        characterPositions = [character1.center, character2.center, character3.center]
    }

    /// 초딩 캐릭터 선택 버튼 액션
    @IBAction func selectCharacter1(_ sender: UIButton) {
        viewModel.selectCharacter(0)
    }

    /// 중딩 캐릭터 선택 버튼 액션
    @IBAction func selectCharacter2(_ sender: UIButton) {
        viewModel.selectCharacter(1)
    }

    /// 고딩 캐릭터 선택 버튼 액션
    @IBAction func selectCharacter3(_ sender: UIButton) {
        viewModel.selectCharacter(2)
    }

    /// 캐릭터들이 시계 방향으로 회전하도록 애니메이션 처리
    private func rotateCharacters() {
        let characterViews = [character1!, character2!, character3!]

        UIView.animate(withDuration: 0.5, animations: {
            // 각 캐릭터를 다음 위치로 이동 (시계 방향 회전)
            for i in 0..<characterViews.count {
                let nextIndex = (i + 1) % self.characterPositions.count
                characterViews[i].center = self.characterPositions[nextIndex]
            }
            
            // 새로운 위치를 저장하여 다음 회전에 반영
            self.characterPositions = characterViews.map { $0.center }
        })
    }
}
