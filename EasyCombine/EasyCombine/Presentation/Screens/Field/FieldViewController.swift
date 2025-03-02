//
//  FieldViewController.swift
//  EasyCombine
//
//  Created by 배정길 on 3/3/25.
//

import UIKit
import Combine

// MARK: - FieldViewController (Presentation Layer)
/// 필드 화면을 담당하는 뷰 컨트롤러
/// - 마법사와 몬스터의 등장, 대사 진행, VS 연출 및 전투 화면으로 전환하는 역할을 한다.
class FieldViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>() // Combine을 활용한 비동기 이벤트 구독 관리
    var viewModel: FieldViewModel! // ViewModel을 주입받아 데이터 및 상태를 관리
    var coordinator: AppCoordinator? // 화면 전환을 관리하는 코디네이터
    
    // UI 요소
    private let backgroundImageView = UIImageView(image: UIImage(named: "fieldBg")) // 배경 이미지
    private let wizardImageView = UIImageView(image: UIImage(named: "b")) // 마법사 캐릭터 이미지
    private let monsterImageView = UIImageView(image: UIImage(named: "c")) // 몬스터 캐릭터 이미지
    private let dialogueBubble = DialogueBubble() // 대사 말풍선
    private let vsLabel: UILabel = {
        let label = UILabel()
        label.text = "VS" // VS 표시 (전투 시작 연출)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .red
        label.textAlignment = .center
        label.alpha = 0 // 초기에는 숨김 상태
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.startSequence()
    }
    
    /// UI 초기 설정
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(wizardImageView)
        view.addSubview(monsterImageView)
        view.addSubview(dialogueBubble)
        view.addSubview(vsLabel)
        
        backgroundImageView.frame = view.bounds
        wizardImageView.frame = CGRect(x: -150, y: view.bounds.height * 0.6, width: 100, height: 100) // 마법사 초기 위치 (왼쪽 바깥)
        monsterImageView.frame = CGRect(x: view.bounds.width + 150, y: view.bounds.height * 0.6, width: 100, height: 100) // 몬스터 초기 위치 (오른쪽 바깥)
        dialogueBubble.frame = CGRect(x: 50, y: wizardImageView.frame.minY - 80, width: view.bounds.width - 100, height: 80)
        vsLabel.frame = CGRect(x: (view.bounds.width / 2) - 40, y: wizardImageView.frame.minY - 60, width: 80, height: 50)
        
        dialogueBubble.isHidden = true // 대사 말풍선은 초기에는 숨김 상태
    }
    
    /// ViewModel과 바인딩 설정
    private func setupBindings() {
        viewModel.wizardAppeared
            .sink { [weak self] _ in self?.showWizard() } // 마법사 등장 이벤트를 구독
            .store(in: &cancellables)
        
        viewModel.monsterAppeared
            .sink { [weak self] _ in self?.showMonster() } // 몬스터 등장 이벤트를 구독
            .store(in: &cancellables)
        
        viewModel.dialogueText
            .sink { [weak self] text in
                self?.showDialogue(text) // 대사 표시 이벤트를 구독
            }
            .store(in: &cancellables)
        
        viewModel.moveToCenter
            .sink { [weak self] in self?.moveToCenter() } // 마법사와 몬스터가 중앙으로 이동하는 이벤트를 구독
            .store(in: &cancellables)
    }
    
    /// 마법사 등장 애니메이션
    private func showWizard() {
        UIView.animate(withDuration: 1.0, animations: {
            self.wizardImageView.frame.origin.x = 50
        }) { _ in
            self.viewModel.startWizardDialogue() // 마법사 등장 후 대사 시작
        }
    }
    
    /// 몬스터 등장 애니메이션
    private func showMonster() {
        UIView.animate(withDuration: 1.0, animations: {
            self.monsterImageView.frame.origin.x = self.view.bounds.width - 150
        }) { _ in
            self.viewModel.startMonsterDialogue() // 몬스터 등장 후 대사 시작
        }
    }
    
    /// 대사 표시 애니메이션
    private func showDialogue(_ text: String) {
        dialogueBubble.setText(text)
        dialogueBubble.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.dialogueBubble.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.dialogueBubble.alpha = 0
                }) { _ in
                    self.dialogueBubble.isHidden = true
                    self.viewModel.nextDialogue() // 다음 대사 호출
                }
            }
        }
    }
    
    /// 마법사와 몬스터가 중앙으로 이동하는 애니메이션
    private func moveToCenter() {
        UIView.animate(withDuration: 1.5, animations: {
            self.wizardImageView.frame.origin.x = (self.view.bounds.width / 2) - 100
            self.monsterImageView.frame.origin.x = (self.view.bounds.width / 2)
        }) { _ in
            self.showVSLabel() // 이동 후 VS 연출
        }
    }
    
    /// VS 연출 표시 후 전투 화면으로 전환
    private func showVSLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.vsLabel.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.viewModel.transitionToBattle() // 전투 화면으로 전환
            }
        }
    }
}
