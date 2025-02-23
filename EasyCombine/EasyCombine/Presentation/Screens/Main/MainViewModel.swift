//
//  MainViewModel.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 메인 화면
       - 메인 화면 상태 관리

 비즈니스 로직(confirmCharacterSelection, handleMazeViewDismiss)을 UseCase로 이동
ViewModel에서는 UI 상태를 관리하고, 핵심 로직은 UseCase에 위임
 ViewController → ViewModel → UseCase → Repository의 흐름을 유지하면서 클린 아키텍처 준수

 
 •    ViewModel → UI 상태 관리 + UseCase 호출
 •    UseCase → 캐릭터 선택/초기화 로직
 •    Repository → UserDefaults 저장

 손님으로 부터 아메리카노 주세요. 요청을 받음
 커피 주문을 useCase 에게 넘김
 
 주문이 완료 되면 손님에게 전달 할 수 있도록 준비함
 
 usecase = 커피 머신
 바리스트/(viewModel)가 요청 한 대로 커피를 만듦
 예를들어 아메리카노 만들기 usecase 는 원두를 갈고 물을 넣고 추출하는 과정(비즈니스 로직) 을 수행함
 완성된 커피를 viewModel 에게 넘겨줌
 
 
 */
// ViewModel은 FetchQuizUseCase를 통해 데이터를 UI 상태로 관리.

/*!<
 1. Publisher(발행자)
 -> 손님 (주문하는 사람)
 손님이 커피를 주문하는 것이 Publisher 의 역할
 Publisher는 특정 이벤트(데이터)를 방출하는 존재니까
 손님이 바리스타에게 "아메리카노 한잔 주세요."라고
 말하는 순간이 바로 Publisher 가 데이터를 방출하는 순간
 
 let customer = PassthroughSubject<String, Never>()
 customer.send("아메리카노")
 */
/*!<
 2. Subscriber(구독자) -> 바리스타
 (주문을 받아 커피를 만드는 사람)
 Subscriber는 Publisher의 데이터를 받아서 처리하는 존재
 즉, 바리스타가 손님의 주문을 받고, 주문에 맞는 커피를 만들고, 최종적으로손님에게 커피를 제공하는 과정
 
 let barista = customer.sink { order in
        print("바리스타: \(oder) 주문을 받았습니다. 커피를 만들게요.)
 }
 // 결과 출력 : 아메리카노 주문을 받았습니다. 커피를 만들게요.
 */
/*!<
 3. Operator (연산자) -> 커피 제조 과정 (주문을 가공하는 과정)
 손님이 커피를 주문하면 바리스타는 그 주문을 가공해서 완성된 커피를 만들어야 함
 이때 Combine의 map 연산자를 사용하면, 손님의 주문 데이터를 완성된 커피로 변환할수 있음
 
 customer
    .map { order in
        return "\(order) 커피 완성!"
    }
    .sink { completedCoffee in
        print("손님에게 제공: \(completedCoffee)")
    }
 결과 출력: 손님에게 제공: 아메리카토 커피 완성!
 */
/*!<
 4. Subject(Subject) -> 주문벨
 (다른곳에서도 주문을 받을 수 있는 시스템
 . PassthroughSubject를 사용하면 손님이 직접 주문할 수도 있고,
 전화 주문 같은 외부 주문도 받을수 있음
 . CurrentValueSubject 는 최신 주문 상태를 유지하는 시스템
 (예: 대기중인 주문 목록)처럼 쓸수 있음
 
 let orderBell = PassthroughSubject<String, Never>()
 
 orderBell
    .map { "바리스타: \($0) 주문 들어왔습니다." }
    .sink { print($0) }
 
 orderBell.send("카페라떼")
 
 orderBell.send("바닐라라떼")
 
 // 결과 출력
 바리스타: 카페라떼 주문 들어왔습니다.
 바리스타: 바닐라라떼 주문 들어왔습니다.
 */

/*!<
 5. Completion(완료) -> 영업종료
 
 Combine의 Completion 은 주문이 더이상 들어오지 않음을 의미
 즉 커피숍의 영업이 종료되는 상황
 
 let coffeOrders = PasshroughSubject<String, Never>()
 coffeOrders.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("커피숍 영업종료: 더 이상 주문을 받지 않습니다.")
    case .failure( let error) :
        print("오류 발생 : \(error)")
 
 coffeeOrders.send("아메리카노")
 coffeeOrders.send("카페라떼")
 
 coffeeOrders.send(completion: .finished)
 
 coffeeOrders.send("에스프레소")
 
 결과
 주문받은 커피: 아메리카노
 주문받은 커피: 카페라떼
 커피숍영업종료: 더이상 주문을 받지 않습니다.
 */

import Combine
import UIKit

/// 메인 화면의 ViewModel
/// - 캐릭터 선택 상태를 관리하고, UseCase와 Coordinator를 통해 화면 전환을 수행
final class MainViewModel {
    private let useCase: SelectCharacterUseCase  // 캐릭터 선택 비즈니스 로직을 담당하는 UseCase
    private let coordinator: MainCoordinatorProtocol  // 화면 전환을 담당하는 Coordinator
    private var cancellables = Set<AnyCancellable>()  //  Combine에서 사용되는 구독 관리 객체
    
    @Published var balloonText: String = "나만의 캐릭터를 선택하고,Combine 퀘스트를 시작하자!"  // 말풍선 텍스트 상태 관리
    @Published var selectedCharacter: Int? = nil  //  현재 선택된 캐릭터 인덱스
    @Published var characterSizes: [CGSize] = []  //  캐릭터 크기 변경 상태 관리

    /// 테스트
    @Published var testText: String = "lbl_test"
    
    private var originalCharacterSizes: [CGSize] = []  //  캐릭터 원본 크기 저장 (애니메이션 원복용)
    private var defaultBalloonText: String = "나만의 캐릭터를 선택하고,Combine 퀘스트를 시작하자!"  //  초기 문구 저장 (취소 시 원래대로 복귀)

    /// ViewModel 초기화
    /// - Parameters:
    ///   - useCase: 캐릭터 선택 로직을 처리하는 UseCase
    ///   - coordinator: 화면 전환을 담당하는 Coordinator
    init(useCase: SelectCharacterUseCase, coordinator: MainCoordinatorProtocol) {
        self.useCase = useCase
        self.coordinator = coordinator
        bind()
    }
    
    /// Combine을 활용한 데이터 바인딩
    private func bind() {
        useCase.balloonText.assign(to: &$balloonText)  //  UseCase의 말풍선 텍스트와 바인딩
        useCase.selectedCharacter.assign(to: &$selectedCharacter)  //  선택된 캐릭터 상태 바인딩
        useCase.testText.assign(to: &$testText)
    }

    /// 초기 캐릭터 크기를 설정
    /// - Parameter sizes: 각 캐릭터의 원본 크기 배열
    func setInitialSizes(_ sizes: [CGSize]) {
        characterSizes = sizes
        originalCharacterSizes = sizes
    }

    /// 선택된 캐릭터의 크기를 확대하고 말풍선 텍스트를 변경
    /// - Parameter index: 선택한 캐릭터의 인덱스 (0, 1, 2)
    func highlightSelectedCharacter(_ index: Int) {
        selectedCharacter = index
        if let character = Character.getCharacter(by: index) {
            balloonText = character.description  //  선택한 캐릭터에 맞는 문구 설정
        }

        for i in 0..<characterSizes.count {
            characterSizes[i] = i == index ?
                CGSize(width: originalCharacterSizes[i].width * 1.6, height: originalCharacterSizes[i].height * 1.6) :
                originalCharacterSizes[i]  //  선택된 캐릭터는 크기 확대, 나머지는 원래 크기 유지
        }
    }

    /// 선택 취소 시 크기를 원래대로 복귀
    func resetCharacterSize() {
        selectedCharacter = nil
        characterSizes = originalCharacterSizes
        balloonText = defaultBalloonText  //  초기 문구로 변경
    }

    /// 캐릭터 선택 확정 후 `UseCase`를 통해 저장 및 화면 전환 처리
    /// - Parameter index: 선택한 캐릭터의 인덱스 (0, 1, 2)
    func confirmCharacterSelection(index: Int) {
        useCase.selectCharacter(index)  //  UseCase에 캐릭터 선택 처리 위임
        coordinator.navigateToMazeViewController()  //  화면 이동은 Coordinator가 처리
    }

    ///  MazeViewController가 닫힐 때 `UseCase`에서 상태 초기화
    func handleMazeViewDismiss() {
        useCase.resetCharacterSelection()  //  UseCase에서 선택된 캐릭터 초기화
        print(" Maze 화면이 닫힘 - ViewModel에서 이벤트 감지됨")
    }
    
    ///
    func handleTestButtonClicked() {
        useCase.testLblSelection()
    }
}
