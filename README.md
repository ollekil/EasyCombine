# EasyCombine
콤바인 학습 앱
EasyCombine
├── Root
│   ├── RootViewController.swift
│   ├── RootCoordinator.swift
│   └── RootDIContainer.swift
├── Domain
│   ├── Entities
│   │   └── Lesson.swift
│   ├── UseCases
│   │   └── FetchLessonsUseCase.swift
│   └── Repositories
│       └── LessonRepository.swift
├── Data
│   ├── Repositories
│   │   └── LessonRepositoryImpl.swift
│   ├── Models
│   │   └── LessonDTO.swift
│   └── Services
│       └── LessonAPIService.swift
├── Presentation
│   ├── ViewControllers
│   │   ├── LessonListViewController.swift
│   │   └── LessonDetailViewController.swift
│   ├── ViewModels
│   │   ├── LessonListViewModel.swift
│   │   └── LessonDetailViewModel.swift
│   ├── Coordinators
│   │   ├── LessonCoordinator.swift
│   │   └── DetailCoordinator.swift
│   └── Views
│       └── CustomLessonView.swift
├── Common
│   ├── Extensions
│   │   ├── UIView+Extensions.swift
│   │   └── Combine+Extensions.swift
│   └── Utilities
│       ├── Logger.swift
│       └── NetworkMonitor.swift
└── Tests
    ├── UnitTests
    │   ├── DomainTests
    │   └── DataTests
    └── UITests
        └── PresentationTests
