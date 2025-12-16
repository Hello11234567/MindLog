//AI API 설정
import 'dart:convert';
import 'package:http/http.dart' as http; //http 통신을 위한 패키지
import '../api_keys.dart'; //OpenAI API Key를 분리해서 관리하는 파일
import '../UI/emotion_score_page.dart'; 

//AI 감정 분석 서비스 
class AIService {
    static Future<String> analyzeEmotionText(String emotionText) async { //감정분석 요청 함수 emotionText: 사용자가 입력한 감정 점수를 문장으로 정리한 텍스트
        final uri = Uri.parse("https://api.openai.com/v1/chat/completions"); //OpenAi Chat Completions API 엔드포인트

        //http 요청 헤더 설정
        final headers = {
            'Content-Type': 'application/json', //json 형식 데이터 전송
            'Authorization': 'Bearer ${ApiKeys.openAIKey}', //OpenAI 인증 키
        };

        //AI에게 전달할 프롬프트 (역할 + 출력 형식 강제)
        final prompt = """
        당신은 사용자의 감정을 정리하고 이해를 돕는 공감형 보조 AI입니다.

        아래는 사용자가 오늘 감정을 0~5 점수로 기록한 내용을 문장으로 정리한 것입니다: 

        $emotionText  

        반드시 아래 두 섹션을 모두 포함하여 한국어로 답변하세요.
        아래 조건을 하나라도 지키지 않으면 답변으로 인정되지 않습니다.

        ⚠️ 중요 규칙:
        - 감정이 매우 안정적이거나 행복한 하루여도
        - 반드시 "✨ 오늘의 감정 케어 추천" 섹션을 작성해야 합니다.
        - 추천이 없는 답변은 잘못된 답변입니다.

        ⚠️ 문단 규칙:
        - 첫 문단 끝에 반드시 줄바꿈을 넣으세요.
        - 문단 구분은 Enter 두 번(빈 줄 1줄)로 하세요.

        아래 형식을 절대 변경하지 말고 그대로 사용하세요.

        [🧠 분석 결과 요약]
        - 반드시 두 개의 문단으로 나누어 작성하세요.
        -각 문단 뒤에는 반드시 줄바꿈(\n)을 포함하세요.
        - 두 문단 사이에는 빈 줄 한 줄을 추가하세요.
        - 첫 번째 문단:
            · 오늘 하루의 전반적인 감정 상태를 공감하며 설명
        - 두 번째 문단:
            · 오늘 하루를 돌아보며 긍정적인 마무리 메시지 제공
        - 각 문단은 1~2문장으로 구성하세요.
        - 힘들지 않았더라도, 일상의 소중함을 느낄 수 있게 말해 주세요.

        [✨ 오늘의 감정 케어 추천]
        - 정확히 3개만 추천하세요.
        - 감정이 좋더라도 "오늘은 더 행복하게 마무리하기 위한 제안"을 하세요.
        - 각 추천의 "부가 설명"은 반드시 한 문단(한 줄)으로 작성하세요.
        - 각 항목은 아래의 형식을 반드시 지켜주세요.
        
        - 추천 제목 (감정 / 행동을 나타내는 이모지 1개를 제목 맨 앞에 붙일것)
          부가 설명 (한 문장, 왜 도움이 되는지 설명)

        [🤖 오늘의 대표 감정]
        - 오늘 하루를 가장 잘 표현하는 감정 이모지 1개를 선택해 주세요.
        - 반드시 이모지 하나만 작성하세요. (텍스트 설명 ❌)

        주의사항:
        - 진단, 병명, 전문 상담 언급 ❌
        - 명령조 ❌
        친구처럼 부드럽고 따뜻한 말투 ✅
        """;

        //OpenAI 요청 body 구성
        final body = jsonEncode({
            "model": "gpt-4o-mini", //사용 모델
            "messages": [{"role": "user", "content": prompt}], //사용자 메시지 역할, 프롬프트 내용
            "temperature": 0.7, //응답 다양성 조정
            "max_tokens": 400, //최대 응답 길이 제한
        });

        final res = await http.post(uri, headers: headers, body: body); //OpenAI API POST 요청 실행

        //응답 처리
        if(res.statusCode == 200) {
            final data = jsonDecode(res.body) as Map<String, dynamic>; //성공 시 json 파싱
            final String result = data["choices"][0]["message"]["content"] as String? ?? ""; //AI가 생성한 실제 텍스트 추출
            return result.trim(); //앞뒤 공백 제거 후 반환
        } else {
            throw Exception('OpenAI 오류: ${res.statusCode} ${res.body}'); //실패 시 에러 발생
        }
    }
}