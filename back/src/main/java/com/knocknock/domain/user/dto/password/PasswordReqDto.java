package com.knocknock.domain.user.dto.password;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PasswordReqDto {

    private String password; // 변수가 하나인 dto는 requestBody로 사용할떄 기본생성자가 반드시 필요함
    // 안그러면 JsonParsingError가 납니다.
}
