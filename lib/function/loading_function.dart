//로딩 화면 때 텍스트 변환 
String makeEmotionText({
    required int joy,
    required int anger,
    required int anxiety,
    required int comfort,
    required int sadness,
}) {
    String result = "오늘의 감정을 분석할 준비가 되었어요!\n\n";

    void addEmotion(String label, int score, String highText, String midText, String lowText) {
        result += "• 오늘의 $label 수치는 ${score}점이에요.";

        if(score >= 4) {
            result += "$highText\n";
        } else if(score == 3) {
            result += "$midText\n";
        } else {
            result += "$lowText\n";
        }
    }

    addEmotion(
        "기쁨",
        joy,
        "오늘은 기쁜 감정이 강하게 느껴졌어요 ☺️",
        "기쁨이 적당히 느껴진 하루였어요 🙂",
        "기쁨을 느끼기 어려운 하루였을 수 있어요 ☹️",
    );

    addEmotion(
        "분노",
        anger,
        "화가 많이 났던 하루였어요 😡",
        "약간의 짜증이 나 답답함이 있었던 것 같아요 🤨",
        "큰 분노 없이 비교적 차분했어요 😌",
    );

    addEmotion(
        "불안",
        anxiety,
        "불안한 마음이 크게 느껴졌던 하루예요 😊",
        "약간의 걱정이 있었을지도 몰라요  😓",
        "전반적으로 안정적인 하루였어요 😃",
    );

    addEmotion(
        "편안",
        comfort,
        "마음이 굉장히 편안했던 하루예요 😆",
        "보통 수준의 편안함을 느꼈어요 🙃",
        "편안함을 느낄 여유가 적었을 수도 있어요 😮‍💨",
    );

    addEmotion(
        "기쁨",
        joy,
        "슬픈 감정이 크게 영향을 준 하루였어요 😭",
        "감정적으로 조금 가라앉아 있었을 수 있어요 😔",
        "슬픔은 크게 느껴지지 않았어요 😀",
    );
    
    return result;
}
