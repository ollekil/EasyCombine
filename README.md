# EasyCombine
# EasyCombine
콤바인 학습 앱
EasyCombine
├── App                         # 앱의 진입점과 핵심 관리 역할
│   ├── AppCoordinator.swift    # 앱의 흐름을 관리하는 Coordinator
│   ├── AppDIContainer.swift    # 앱 전체의 의존성 주입 컨테이너
│   └── RootViewController.swift # 앱의 루트 화면 컨테이너 (UIWindow 설정 등)
├── Domain                      # 비즈니스 로직 (순수한 비즈니스 계층, UI/외부 의존 없음)
│   ├── Entities                # 핵심 도메인 모델 정의
│   │   └── Lesson.swift        # Lesson 도메인 모델
│   ├── UseCases                # 유스케이스 (도메인 로직 수행)
│   │   └── FetchLessonsUseCase.swift # Lesson 데이터 가져오는 UseCase
│   └── Repositories            # 데이터 접근을 추상화하는 인터페이스
│       └── LessonRepository.swift # LessonRepository 프로토콜 (구현은 Data 레이어에서)
├── Data                        # 외부 데이터 관리 (API, DB, 로컬 저장소 등)
│   ├── Repositories
│   │   └── LessonRepositoryImpl.swift # LessonRepository 구현체
│   ├── DataTransferObjects     # 네트워크 / 데이터 저장을 위한 모델
│   │   └── LessonDTO.swift     # Lesson의 DTO (Data Transfer Object)
│   ├── Mappers                 # DTO ↔ Domain 변환을 담당하는 매퍼
│   │   └── LessonMapper.swift  # LessonDTO → Lesson 변환 매퍼
│   └── Services                # 외부 서비스 (API 통신 등)
│       └── LessonAPIService.swift # Lesson 관련 API 호출 서비스
├── Presentation                # UI 및 화면 관련 계층 (UIKit 기반)
│   ├── ViewControllers         # 화면을 담당하는 ViewController
│   │   ├── LessonListViewController.swift  # Lesson 목록 화면
│   │   └── LessonDetailViewController.swift # Lesson 상세 화면
│   ├── ViewModels              # ViewController에서 사용할 데이터와 상태 관리
│   │   ├── LessonListViewModel.swift # Lesson 목록 ViewModel
│   │   └── LessonDetailViewModel.swift # Lesson 상세 ViewModel
│   ├── Coordinators            # 화면 이동을 담당하는 Coordinator 패턴
│   │   ├── LessonCoordinator.swift  # Lesson 목록 관련 화면 이동 관리
│   │   └── DetailCoordinator.swift  # Lesson 상세 화면 이동 관리
│   └── Views                   # 커스텀 UI 뷰
│       └── CustomLessonView.swift # Lesson 관련 커스텀 뷰
├── Common                      # 공통적으로 사용되는 유틸리티 및 확장 기능
│   ├── Extensions              # Swift 및 UIKit 확장 (Extension)
│   │   ├── FoundationExtensions
│   │   │   └── Combine+Extensions.swift # Combine 관련 확장
│   │   ├── UIKitExtensions
│   │   │   └── UIView+Extensions.swift  # UIView 관련 확장
│   ├── Helpers                 # 공통 유틸리티 및 헬퍼 클래스
│   │   ├── Logger.swift        # 로그 시스템
│   │   └── NetworkMonitor.swift # 네트워크 상태 모니터링
└── Tests                       # 테스트 코드 (Unit/UI 테스트)
    ├── UnitTests               # 유닛 테스트 (각 레이어별 로직 테스트)
    │   ├── DomainTests         # 도메인 계층 테스트
    │   ├── DataTests           # 데이터 계층 테스트
    │   └── PresentationTests   # UI 관련 로직 테스트
    └── UITests                 # UI 테스트 (실제 화면 동작 검증)
        └── PresentationUITests # Presentation 계층 UI 테스트
