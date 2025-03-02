EasyCombine

│-- App                     # 앱의 진입점과 핵심 관리 역할
│   │-- AppDelegate.swift               # 앱의 생명주기 관리
│   │-- ScreenDelegate.swift            # scren 전환 및 관리
│   │-- DIContatiner.swif               # 의존성 주입 컨테이너
│
│-- Domain                  # 비즈니스 로직 (순수한 비즈니스 계층, UI/외부 의존 없음)
│   │-- Entities                        # 도메인 엔티티 정의    
|   |   ├── Character.swift  # 캐릭터 데이터 모델 (Entity)
│   │   ├── IntroStory.swift  ✅ (인트로 텍스트 데이터 모델)
│   │-- UserCases                       # 유스케이스 - 도메인 로직 처리
|       ├── SelectCharacterUseCase.swift            # 캐릭터 선택 비즈니스 로직
│   │   ├── FetchIntroStoryUseCase.swift  ✅ (인트로 텍스트 가져오기)
│
│-- Data                   # 외부 데이터 관리 (API, DB, 로컬 저장소 등)
│   │-- Repositories                    # 데이터 저장소 인터페이스 및 구현
|   |   ├── CharacterSelectionRepository.swift  ← 캐릭터 저장소 (UserDefaults 사용)
│   │   ├── IntroStoryRepository.swift  ✅ (인트로 텍스트 관리)
│   │-- Network                         # 네트워크 관련 계층
│   │   │-- APIClient.swift                         # API 호출 로직
│   │   │-- Endpoints.swift                         # API 엔드 포인트 정의
│   │-- Storage                         # 로컬 데이터 저장 계층
│       │-- LocalStorage.swift                      # UserDefaults 또는 CoreData 관리
│
│-- Presentation            # UI 및 화면 관련 계층 (UIKit 기반)
│   │-- Screens                         # 화면별 ViewController 와 ViewModel
│   │   │-- Main                                    # 메인 화면
│   │   │   │-- MainViewController.swift                    # 메인 화면 뷰 컨트롤러
│   │   │   │-- MainViewModel.swift                         # UI 상태 관리 및 UseCase 연결
|   |   |-- Intro
|   |   |   |-- IntroViewController.swift                   # 메인 이후 인트로 화면 뷰 컨트롤러
|   |   |   |-- IntroViewModel.swift                        # 인트로 화면 상태 관리
│   │-- Coordinators                   # 화면 전환을 담당하는 코디네이터 폴더 추가
│   |   │-- MainCoordinator.swift                # 메인 화면 전환 담당 코디네이터
│   |   │-- AppCoordinator.swift                 # 앱 전체의 네비게이션을 관리하는 코디네이터 (필요하면 추가)
│   │-- Components                      # 재사용 가능한 UI 컴포넌트
│       │-- CustomButton.swift                      # 공통 버튼 UI
│       │-- CustomLabel.swift                       # 공통 라벨 UI
│
│-- Common                # 공통적으로 사용되는 유틸리티 및 확장 기능
│   │-- Extenstions                     # UIKit 및 기본 타입 확장
│   │   │-- UIView+Extensions.swift                 # UIView 관련 확장 함수
│   │   │-- String+Extensions.swift                 # 문자열 관련 확장 함수
│   │-- Utilities                       # 공통 유틸리티 클래스
│   │   │-- Logger.swift                            # 디버깅 및 로그 처리
│   │   │-- ErrorHandler.swift                      # 에러 처리 유틸리티
│   │-- CombineHelpers                  # Combine 관련 유틸리티
│       │-- Publisher+Extenstions.swift             # 퍼블리셔 확장
│       │-- Subscriber+Helpers.swift                # 서브스크라이버 유틸리티
│   │   ├── Timer+Extensions.swift  ✅ (타이핑 효과를 위한 Combine 확장)
│
│-- Resources                           # 앱 리소스 및 다국어 지원
│   │-- Assets.scassets                             # 이미지 및 아이콘 관리 
│   │-- Localization                                # 다국어 리소스 
│       │-- ko.strings                                      # 한국어 번역 파일
│       │-- en.strings                                      # 영어 번역 파일
│
│-- Tests               # 테스트 코드 (Unit/UI 테스트)
│   │-- UnitTests                       # 유닛 테스트
│       │-- MainViewModelTests.swift                # MainViewModel 테스트
│   │-- UITests                         # UI 테스트    
│       │-- MainScreentUITests.swift                # Main UI 테스트

