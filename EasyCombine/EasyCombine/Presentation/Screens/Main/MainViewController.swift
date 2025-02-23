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
    
    @IBOutlet weak var tButton: UIButton!  // 테스트 버튼
    @IBOutlet weak var tLbel: UILabel!     // 테스트 라벨

    var viewModel: MainViewModel!  // ViewModel 인스턴스
    private var cancellables = Set<AnyCancellable>()  // Combine에서 사용되는 구독 관리 객체
    private var coordinator: MainCoordinator!  // 코디네이터 추가 (화면 전환 담당)

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
        coordinator = MainCoordinator(navigationController: navigationController)  //  네비게이션 컨트롤러 주입
        viewModel = MainViewModel(useCase: useCase, coordinator: coordinator)
        
        characterViews = [character1, character2, character3]  // 캐릭터 이미지 배열 저장
    }

    /// ViewModel의 데이터를 UI에 바인딩 (Combine 사용)
    private func setupBindings() {
        viewModel.$balloonText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.balloonLabel.text = text  // 말풍선 텍스트 변경
            }
            .store(in: &cancellables)

        viewModel.$characterSizes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sizes in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3) {
                    for (index, size) in sizes.enumerated() {
                        self.characterViews[index].frame.size = size  // 캐릭터 크기 애니메이션 변경
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$testText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.tLbel.text = text  // 말풍선 텍스트 변경
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
    
    
    @IBAction func selectTest(_ sender: UIButton) {
        viewModel.handleTestButtonClicked()
    }

    /// 캐릭터 선택 확인 얼럿을 표시하는 메서드
    private func showConfirmationAlert(for index: Int) {
        viewModel.highlightSelectedCharacter(index)  // 선택한 캐릭터 크기 확대

//        let characterName = Character.getCharacter(by: index)?.name ?? "캐릭터"
        let characterTitle = Character.getCharacter(by: index)?.title ?? ""
        let characterMessage = Character.getCharacter(by: index)?.message ?? ""
        
        let alert = UIAlertController(
            title: "\(characterTitle)",
            message: "\(characterMessage)",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.viewModel.confirmCharacterSelection(index: index)  // ViewModel에서 코디네이터 호출 (화면 전환)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.viewModel.resetCharacterSize()  // 선택 취소 시 크기 원복
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

