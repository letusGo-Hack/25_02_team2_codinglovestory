# 개발자 연애 시뮬레이션 (Developer Love Story)

SwiftUI로 개발한 iOS 연애 시뮬레이션 게임입니다. 개발자를 주제로 한 스토리와 선택지 기반 게임플레이를 제공합니다.

## 🎮 게임 소개

신입 개발자로 입사한 당신은 밝고 긍정적인 동료 개발자 '미소'를 만나게 됩니다. 
함께 프로젝트를 진행하며 관계를 발전시켜 나가는 연애 시뮬레이션 게임입니다.

### 주요 특징
- 3개의 챕터로 구성된 스토리
- 선택지에 따라 변화하는 호감도 시스템
- 호감도에 따른 3가지 엔딩 (해피/친구/배드 엔딩)
- 캐릭터의 감정별 이미지 변화

## 📁 프로젝트 구조

```
devcodingstory/
├── Utils/
│   ├── FileReader.swift       # 범용 파일 읽기 유틸리티
│   └── ScenarioManager.swift  # 시나리오 관리 및 게임 상태 관리
├── Models/
│   └── GameModels.swift       # 데이터 모델 (Codable)
├── Chapters/
│   └── Chapter_1/
│       └── Chapter1View.swift # 시나리오 기반 UI
├── Assets.xcassets/
│   ├── Title.imageset/        # 타이틀 이미지
│   └── Miso/                  # 미소 캐릭터 이미지
│       ├── default.imageset/
│       ├── smile1.imageset/
│       ├── smile2.imageset/
│       ├── smile3.imageset/
│       ├── angry.imageset/
│       ├── bad.imageset/
│       ├── crying.imageset/
│       ├── coding.imageset/
│       └── goodEnding.imageset/
├── MainView.swift             # 메인 화면 (시작 페이지)
├── scenario.json              # 구조화된 시나리오 데이터
└── scenario.txt              # 원본 시나리오 텍스트 (해커톤 팀 리더 루트)
```

## 🛠 구현된 기능

### 1. 파일 읽기 시스템 (FileReader.swift)
- `readTextFile()`: 범용 텍스트 파일 읽기
- `readJSONFile()`: JSON 파일 읽기
- `readScenarioText()`: scenario.txt 읽기
- `readScenarioJSON()`: scenario.json 읽기

### 2. 데이터 모델 (GameModels.swift)
- `GameScenario`: 전체 게임 구조
- `Character`: 캐릭터 정보 (미소, 플레이어)
- `Chapter`: 챕터별 시나리오
- `Scene`: 대화/선택지 씬
- `Choice`: 선택지 (호감도 포함)
- `Ending`: 엔딩 정보
- `EndingType`: 엔딩 종류 enum (good, friend, bad)

### 3. 시나리오 관리 (ScenarioManager.swift)
- 싱글톤 패턴으로 구현
- 시나리오 로드 및 파싱
- 현재 씬/챕터 관리
- 호감도 시스템
- 선택지 처리
- 엔딩 분기 결정
- 게임 리셋

### 4. UI 구현
- **MainView**: 타이틀 이미지 표시, Chapter1View로 네비게이션
- **Chapter1View**: 실제 게임 플레이 화면
  - 챕터 타이틀 표시
  - 캐릭터 이미지 (감정별)
  - 대화 텍스트
  - 선택지 버튼
  - 호감도 표시
  - 엔딩 화면

## 📖 시나리오 구조

### 챕터 구성
1. **Chapter 1: 첫 만남**
   - 미소와의 첫 만남
   - 첫 인사 선택지

2. **Chapter 2: 함께 코딩하기**
   - 페어 프로그래밍 제안
   - 협업 방식 선택

3. **Chapter 3: 마지막 선택**
   - 관계의 방향 결정
   - 최종 선택

### 엔딩 분기
- **해피 엔딩** (호감도 30 이상): 함께 멋진 코드를 만들어가기로 약속
- **친구 엔딩** (호감도 15 이상): 좋은 동료이자 친구로 지내기
- **배드 엔딩** (호감도 15 미만): 프로젝트만 마무리하고 끝

## 💻 사용 방법

### ScenarioManager 사용 예시
```swift
// ScenarioManager 사용
let manager = ScenarioManager.shared

// 전체 시나리오 가져오기
let fullScenario = manager.getFullScenario()

// 특정 챕터 가져오기
let chapter1 = manager.getChapter(id: 1)

// 캐릭터 정보
let miso = manager.getCharacter(id: "miso")

// 선택지 선택
manager.makeChoice(choice)

// 현재 호감도
let affection = manager.affectionLevel
```

## 🎯 향후 개발 계획
- [ ] 추가 챕터 개발
- [ ] 더 많은 캐릭터 추가
- [ ] 사운드 효과 및 배경음악
- [ ] 저장/불러오기 기능
- [ ] 다양한 루트 추가 (해커톤 팀 리더 루트 구현)

## 📱 시스템 요구사항
- iOS 16.0+
- Xcode 14.0+
- Swift 5.8+

## 🔧 설치 및 실행
1. 프로젝트를 클론합니다
2. Xcode에서 `devcodingstory.xcodeproj`를 엽니다
3. scenario.json 파일을 프로젝트에 추가합니다 (Copy items if needed 체크)
4. 실행 타겟을 선택하고 빌드합니다

## 📝 참고사항
- scenario.json 파일은 Bundle에 포함되어야 정상적으로 읽을 수 있습니다
- 모든 이미지 파일은 Assets.xcassets에 등록되어 있어야 합니다
