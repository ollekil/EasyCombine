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

/// 메인 화면을 관리하는 ViewController
class MainViewController: UIViewController {
    @IBOutlet weak var balloonLabel: UILabel!
    
    @IBOutlet weak var character1: UIImageView!
    @IBOutlet weak var character2: UIImageView!
    @IBOutlet weak var character3: UIImageView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var tButton: UIButton!
    @IBOutlet weak var tLabel: UILabel!

    var viewModel: MainViewModel!
    var coordinator: AppCoordinator?  // 화면 전환을 담당하는 코디네이터
    private var cancellables = Set<AnyCancellable>()
    private var characterViews: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCharacterViews()
        setupBindings()
        setupInitialSizes()
    }

    /// 캐릭터 이미지뷰 배열을 설정
    private func setupCharacterViews() {
        characterViews = [character1, character2, character3]
    }

    /// ViewModel과 UI를 바인딩 (Combine 사용)
    private func setupBindings() {
        // 말풍선 텍스트 변경 시 UI 업데이트
        viewModel.$balloonText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.balloonLabel.text = text
            }
            .store(in: &cancellables)

        // 캐릭터 크기 변경 시 애니메이션 적용
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

    /// 캐릭터의 초기 크기 저장
    private func setupInitialSizes() {
        let initialSizes = characterViews.map { $0.frame.size }
        viewModel.setInitialSizes(initialSizes)
    }

    /// 첫 번째 캐릭터 선택 버튼 클릭
    @IBAction func selectCharacter1(_ sender: UIButton) {
        showConfirmationAlert(for: 0)
    }

    /// 두 번째 캐릭터 선택 버튼 클릭
    @IBAction func selectCharacter2(_ sender: UIButton) {
        showConfirmationAlert(for: 1)
    }

    /// 세 번째 캐릭터 선택 버튼 클릭
    @IBAction func selectCharacter3(_ sender: UIButton) {
        showConfirmationAlert(for: 2)
    }

    /// 테스트 버튼 클릭
    @IBAction func selectTest(_ sender: UIButton) {
        viewModel.handleTestButtonClicked()
    }

    /// 캐릭터 선택 시 확인 알림창 표시
    private func showConfirmationAlert(for index: Int) {
        viewModel.highlightSelectedCharacter(index)

        let characterTitle = Character.getCharacter(by: index)?.title ?? ""
        let characterMessage = Character.getCharacter(by: index)?.message ?? ""
        
        let alert = UIAlertController(title: characterTitle, message: characterMessage, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.viewModel.confirmCharacterSelection(index: index)
            self?.coordinator?.navigateToIntroViewController()
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.viewModel.resetCharacterSize()
        }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}
    
    /// 테스트 선택 버튼 액션
    /*!<
     Publisher(발행자)
     . 데이터를 방출하는 역할
     CurrentValueSubject 등이 대표적인 Publisher
     ex)
     let publisher = Just(5)    // 5라는 값을한번만 방출하는 publisher
     */
    /*!<
     Subscriber(구독자)
     sink(receiveValue: ), assign(to:on:) 등을 사용해 구독 가능.
     ex)
     let subscriber = publisher.sink { value in
        print("받은 값: \(value)")
     // 출력: 받은 값: 5
     }
     */
    /*!<
     Operator(연산자)
     Publisher의 데이터를 가공하거나 필터링 하는 중간 연산자
     map, filter, flatMap 같은변형 연산자가 있음
     ex)
     let mappedPublisher = publisher
        .map { $0 * 2 } // 값을 두배로 변환
        .sink { value in
            print("변환된 값: \(value)")
        }
     // 춮력: 변환된 값: 10
     */
    /*!<
     Publisher 의 종류
     Just
     . 단 한개의 값을 방출하고 완료되는 Publisher.
     let justPublisher = Just("hello, combine!")
     justPublisher.sink { print($0) }
     
     PassthroughSubject
     . 값을 직접 방출할수 있는 Publisher.
     let subject = PAssthroughSubject<String, Never>()
     let cancellable = subject.sink { value in
        print("받은 값: \(value)")
     }
     subject.send("첫번째 메시지")
     subject.send("두번째 메시지")
     // 출력 :
     받은값 : 첫번째 메시지
     받은값: 두번쨰 메시지
     */
    
    /*!<
     CurrentValueSubject
     . 초기값을 가지며, 새로운 값을 보낼때마다 구독자에게 즉시 전달 하는 Publisher.
     let currentValueSubject = CurrentValueSubject<Int, Never>(0)
     currentValueSubject.sink { print("현재 값: \($0)") }
     
     currentValueSubject.send(10)
     currentValueSubject.send(20)
     // 출력
     // 현재값: 0
     현재값: 10
     현재값: 20
     */
    /*!<
     메모리 관리 : AnyCancellable
     . Combine 에서 구독을 하면 AnyCancellable 타입이 반환 되는데, 이를 저장하고 있어야 구독이 유지됨
     . store(in:)을 사용해서 자동으로 구독 관리 가능
     var cancellables = Set<AnyCancellable>()
     let myPublisher = Just("hello")
        .sink { print($0) }
        .store(in: $cancellables)
     */
    
    


