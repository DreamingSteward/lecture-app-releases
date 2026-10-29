# 시간표 모음

강의록앱의 「시간표 모음에서 고르기」가 읽는 곳이에요.

- `index.json` — 학교 목록 `{"schools":[{"id","name","file","updated"}]}`
- `<학교>.json` — 앱의 「시간표 가져오기」와 같은 형식 `{"courses":[{"name","lectures":[{"year","date","period","title","prof","term"}]}]}`
  - `date`가 있는 강의 = 그 해 시간표, 없는 강의 = 지난 해 담당 교수 기록
- 과목마다 `group`(예: 본과 1학년 2학기)은 화면에 작게 보이는 꼬리표예요 (거르기용 아님)
- 새 학교·학년을 넣으려면 학교 파일의 `courses`에 과목을 더하고 `index.json`의 `updated`를 바꿔요.
