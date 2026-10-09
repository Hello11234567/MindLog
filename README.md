# 🧠 MindLog
> 캡스톤디자인 프로젝트 | 2025.10 ~ 2025.12

Flutter 기반 AI 감정 관리 애플리케이션입니다.
청소년 및 청년들이 일상에서 자신의 감정을 기록하고, AI 분석을 통해 감정 상태를 돌아볼 수 있도록 돕는 서비스입니다.

> 본 프로젝트에서 구현한 감정 기록 및 AI 분석 경험을 바탕으로, Spring Boot 백엔드와 연동하고 실제 출시를 목표로 하는 개인 프로젝트 마음이를 개발하고 있습니다.

## ✨ 주요 기능
- 🎚️ 감정 기록: 슬라이더를 이용한 기쁨, 화남, 불안, 평안, 슬픔의 5가지 감정 수치 입력
- 🤖 AI 감정 분석: OpenAI GPT API를 활용한 감정 분석 및 요약
- 💡 개인화 케어 추천: AI 분석 결과를 바탕으로 감정 케어 방법 제공
- 📅 감정 캘린더: 날짜별 감정 기록 및 AI 대표 이모지 확인
- 📊 감정 통계: 주간·월간 감정 평균 계산 및 레이더 차트 시각화

## 📱 주요 화면
### 메인 캘린더
<p align="center">
  <img src="docs/images/main-calendar.png" width="280" alt="MindLog 메인 캘린더" />
</p>

날짜별 감정 기록과 AI 대표 이모지를 캘린더에서 확인할 수 있습니다.

### 감정 기록
<p align="center">
  <img src="docs/images/emotion-input.jpg" width="280" alt="MindLog 감정 기록 화면" />
</p>

슬라이더를 이용해 다섯 가지 감정의 정도를 입력하고 기록합니다.

### AI 감정 분석
<p align="center">
  <img src="docs/images/ai-analysis.png" width="280" alt="MindLog AI 분석 결과 화면" />
</p>

OpenAI API를 통해 감정 분석 요약과 개인화된 케어 추천을 제공합니다.

### 감정 통계
<p align="center">
  <img src="docs/images/emotion-statistics.png" width="280" alt="MindLog 감정 통계 화면" />
</p>

주간·월간 감정 데이터를 계산하고 레이더 차트와 감정별 평균으로 시각화합니다.

### 감정 이모티콘 선택
<p align="center">
  <img src="docs/images/emotion-selection.png" width="280" alt="MindLog 감정 이모티콘 선택 화" />
</p>

감정 기록에 사용할 이모티콘을 선택할 수 있습니다.

## 🛠 기술 스택
| 구분 | 기술 |
|------|------|
| Mobile | Flutter, Dart |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| AI Integration | OpenAI GPT API |
| Data Visulization | fl_chart |

## 👩‍💻 담당 역할 
### 4인 팀 프로젝트 | 팀장 / PM 및 핵심 기능 개발
- 프로젝트 관리: 프로젝트 전체 기획 및 일정 관리
- 데이터 관리: Firebase Authentication 연동 및 Cloud Firestore 데이터 구조 설계·구현
- AI 기능 개발: OpenAI API 연동 및 감정 분석 기능 구현
- UI 개발: 감정 입력, AI 분석 결과, 캘린더 및 통계 화면 구현
- 통계 기능 개발: 주간·월간 감정 평균 계산 로직 및 레이더 차트 시각화 구현

## 📅 프로젝트 기간
2025.10 ~ 2025.12 (약 3개월)

##🔗 후속 프로젝트
- 📱 마음이(Maeum) Flutter 앱: https://github.com/Hello11234567/Maeum
- ⚙️ 마음이 서버: https://github.com/Hello11234567/maeum-server
