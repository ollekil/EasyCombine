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

class MainViewController: UIViewController {
    @IBOutlet weak var balloonLabel: UILabel!
    
    @IBOutlet weak var character1: UIImageView!
    @IBOutlet weak var character2: UIImageView!
    @IBOutlet weak var character3: UIImageView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!

    var viewModel: MainViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: MainCoordinator!  // ✅ 코디네이터 추가

    private var characterViews: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBindings()
        setupInitialSizes()
    }

    private func setupViewModel() {
        let repository = UserDefaultsCharacterRepository()
        let useCase = DefaultSelectCharacterUseCase(repository: repository)
        coordinator = MainCoordinator(navigationController: navigationController)  // ✅ 네비게이션 컨트롤러 주입
        viewModel = MainViewModel(useCase: useCase, coordinator: coordinator)
        
        characterViews = [character1, character2, character3]
    }

    private func setupBindings() {
        viewModel.$balloonText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.balloonLabel.text = text
            }
            .store(in: &cancellables)

        viewModel.$characterSizes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sizes in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3) {
                    for (index, size) in sizes.enumerated() {
                        self.characterViews[index].frame.size = size
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func setupInitialSizes() {
        let initialSizes = characterViews.map { $0.frame.size }
        viewModel.setInitialSizes(initialSizes)
    }

    @IBAction func selectCharacter1(_ sender: UIButton) {
        showConfirmationAlert(for: 0)
    }

    @IBAction func selectCharacter2(_ sender: UIButton) {
        showConfirmationAlert(for: 1)
    }

    @IBAction func selectCharacter3(_ sender: UIButton) {
        showConfirmationAlert(for: 2)
    }

    private func showConfirmationAlert(for index: Int) {
        viewModel.highlightSelectedCharacter(index)

        let characterName = Character.getCharacter(by: index)?.name ?? "캐릭터"
        
        let alert = UIAlertController(
            title: "캐릭터 선택",
            message: "이대로 \(characterName)(으)로 시작하시겠습니까?",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.viewModel.confirmCharacterSelection(index: index)  // ✅ ViewModel에서 코디네이터 호출
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.viewModel.resetCharacterSize()
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

