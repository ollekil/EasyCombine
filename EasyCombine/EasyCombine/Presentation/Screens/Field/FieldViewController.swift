//
//  FieldViewController.swift
//  EasyCombine
//
//  Created by 배정길 on 3/3/25.
//

import UIKit
import Combine

class FieldViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    // UI 요소
    private let backgroundImageView = UIImageView(image: UIImage(named: "fieldBg"))
    private let wizardImageView = UIImageView(image: UIImage(named: "b"))
    private let monsterImageView = UIImageView(image: UIImage(named: "c"))
    private let wizardDialogueBubble = DialogueBubble()
    private let monsterDialogueBubble = DialogueBubble()
    private let vsLabel: UILabel = {
        let label = UILabel()
        label.text = "VS"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .red
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    // 상태 관리
    @Published private var wizardAppeared = false
    @Published private var monsterAppeared = false
    
    private let nextAction = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        startSequence()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(wizardImageView)
        view.addSubview(monsterImageView)
        view.addSubview(wizardDialogueBubble)
        view.addSubview(monsterDialogueBubble)
        view.addSubview(vsLabel)
        
        backgroundImageView.frame = view.bounds
        
        wizardImageView.frame = CGRect(x: -100, y: view.bounds.height * 0.6, width: 100, height: 100)
        monsterImageView.frame = CGRect(x: view.bounds.width + 100, y: view.bounds.height * 0.6, width: 100, height: 100)
        
        wizardDialogueBubble.frame = CGRect(x: 20, y: wizardImageView.frame.minY - 80, width: 200, height: 80)
        monsterDialogueBubble.frame = CGRect(x: view.bounds.width - 220, y: monsterImageView.frame.minY - 90, width: 200, height: 80)
        
        vsLabel.frame = CGRect(x: (view.bounds.width / 2) - 40, y: wizardImageView.frame.minY - 60, width: 80, height: 50)
        
        wizardDialogueBubble.isHidden = true
        monsterDialogueBubble.isHidden = true
    }
    
    private func setupBindings() {
        $wizardAppeared
            .filter { $0 }
            .sink { [weak self] _ in self?.showWizardDialogue() }
            .store(in: &cancellables)
        
        $monsterAppeared
            .filter { $0 }
            .sink { [weak self] _ in self?.showMonsterDialogue() }
            .store(in: &cancellables)
        
        nextAction
            .sink { [weak self] in self?.moveToCenter() }
            .store(in: &cancellables)
    }
    
    private func startSequence() {
        showWizard()
    }
    
    private func showWizard() {
        UIView.animate(withDuration: 1.0, animations: {
            self.wizardImageView.frame.origin.x = 50
        }) { _ in
            self.wizardAppeared = true
        }
    }
    
    private func showWizardDialogue() {
        let dialogues = [
            "이곳에 데이터의 흐름이 어지럽혀지고 있어...",
            "데이터가 흘러야 하는데... 네가 이를 막고 있군!",
            "Combine 마법으로 네 정체를 밝혀주마!"
        ]
        showDialogueSequentially(dialogues, isWizard: true) {
            self.showMonster()
        }
    }
    
    private func showMonster() {
        UIView.animate(withDuration: 1.0, animations: {
            self.monsterImageView.frame.origin.x = self.view.bounds.width - 150
        }) { _ in
            self.monsterAppeared = true
        }
    }
    
    private func showMonsterDialogue() {
        let dialogues = [
            "하하하! 나는 '끊어진 스트림'! 데이터를 막는 자다!",
            "Publisher가 데이터를 보내도, 난 절대 Subscriber에게 넘기지 않지!"
        ]
        showDialogueSequentially(dialogues, isWizard: false) {
            self.nextAction.send()
        }
    }
    
    private func showDialogueSequentially(_ dialogues: [String], isWizard: Bool, completion: @escaping () -> Void) {
        guard !dialogues.isEmpty else {
            completion()
            return
        }
        
        var dialoguesQueue = dialogues
        let firstDialogue = dialoguesQueue.removeFirst()
        let dialogueBubble = isWizard ? wizardDialogueBubble : monsterDialogueBubble
        
        dialogueBubble.setText(firstDialogue)
        dialogueBubble.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            dialogueBubble.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    dialogueBubble.alpha = 0
                }) { _ in
                    dialogueBubble.isHidden = true
                    self.showDialogueSequentially(dialoguesQueue, isWizard: isWizard, completion: completion)
                }
            }
        }
    }
    
    private func moveToCenter() {
        UIView.animate(withDuration: 1.5, animations: {
            self.wizardImageView.frame.origin.x = (self.view.bounds.width / 2) - 80
            self.monsterImageView.frame.origin.x = (self.view.bounds.width / 2) + 20
        }) { _ in
            self.showVSLabel()
        }
    }
    
    private func showVSLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.vsLabel.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.transitionToBattle()
            }
        }
    }
    
    private func transitionToBattle() {
//        let battleVC = BasicBattleViewController()
//        self.present(battleVC, animated: true, completion: nil)
    }
}

class DialogueBubble: UIView {
    private let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    func setText(_ text: String) {
        label.text = text
        label.sizeToFit()
        self.frame.size.height = label.frame.height + 20
    }
}
