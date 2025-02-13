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

/// 메인 화면의 ViewController
/// - 캐릭터 선택 및 화면 UI를 관리함
class MainViewController: UIViewController {
    @IBOutlet weak var balloonLabel: UILabel!  // 말풍선 라벨
    
    @IBOutlet weak var character1: UIImageView!  // 첫 번째 캐릭터 이미지
    @IBOutlet weak var character2: UIImageView!  // 두 번째 캐릭터 이미지
    @IBOutlet weak var character3: UIImageView!  // 세 번째 캐릭터 이미지
    
    @IBOutlet weak var button1: UIButton!  // 첫 번째 캐릭터 선택 버튼
    @IBOutlet weak var button2: UIButton!  // 두 번째 캐릭터 선택 버튼
    @IBOutlet weak var button3: UIButton!  // 세 번째 캐릭터 선택 버튼

    var viewModel: MainViewModel!  // ViewModel 인스턴스
    private var cancellables = Set<AnyCancellable>()  // Combine에서 사용되는 구독 관리 객체
    private var coordinator: MainCoordinator!  // ✅ 코디네이터 추가 (화면 전환 담당)

    private var characterViews: [UIImageView] = []  // 캐릭터 이미지 배열

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()  // ViewModel 설정
        setupBindings()   // ViewModel과 UI 연결
        setupInitialSizes()  // 캐릭터 크기 초기화
    }

    /// ViewModel을 초기화하고, 코디네이터를 설정
    private func setupViewModel() {
        let repository = UserDefaultsCharacterRepository()
        let useCase = DefaultSelectCharacterUseCase(repository: repository)
        coordinator = MainCoordinator(navigationController: navigationController)  // ✅ 네비게이션 컨트롤러 주입
        viewModel = MainViewModel(useCase: useCase, coordinator: coordinator)
        
        characterViews = [character1, character2, character3]  // 캐릭터 이미지 배열 저장
    }

    /// ViewModel의 데이터를 UI에 바인딩 (Combine 사용)
    private func setupBindings() {
        viewModel.$balloonText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.balloonLabel.text = text  // ✅ 말풍선 텍스트 변경
            }
            .store(in: &cancellables)

        viewModel.$characterSizes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sizes in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3) {
                    for (index, size) in sizes.enumerated() {
                        self.characterViews[index].frame.size = size  // ✅ 캐릭터 크기 애니메이션 변경
                    }
                }
            }
            .store(in: &cancellables)
    }

    /// 캐릭터 크기 초기화
    private func setupInitialSizes() {
        let initialSizes = characterViews.map { $0.frame.size }
        viewModel.setInitialSizes(initialSizes)  // ViewModel에 초기 크기 전달
    }

    /// 첫 번째 캐릭터 선택 버튼 액션
    @IBAction func selectCharacter1(_ sender: UIButton) {
        showConfirmationAlert(for: 0)
    }

    /// 두 번째 캐릭터 선택 버튼 액션
    @IBAction func selectCharacter2(_ sender: UIButton) {
        showConfirmationAlert(for: 1)
    }

    /// 세 번째 캐릭터 선택 버튼 액션
    @IBAction func selectCharacter3(_ sender: UIButton) {
        showConfirmationAlert(for: 2)
    }

    /// 캐릭터 선택 확인 얼럿을 표시하는 메서드
    private func showConfirmationAlert(for index: Int) {
        viewModel.highlightSelectedCharacter(index)  // ✅ 선택한 캐릭터 크기 확대

        let characterName = Character.getCharacter(by: index)?.name ?? "캐릭터"
        
        let alert = UIAlertController(
            title: "캐릭터 선택",
            message: "이대로 \(characterName)(으)로 시작하시겠습니까?",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.viewModel.confirmCharacterSelection(index: index)  // ✅ ViewModel에서 코디네이터 호출 (화면 전환)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.viewModel.resetCharacterSize()  // ✅ 선택 취소 시 크기 원복
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

