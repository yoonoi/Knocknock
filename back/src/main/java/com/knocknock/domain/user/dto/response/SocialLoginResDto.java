package com.knocknock.domain.user.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SocialLoginResDto {
    private String accessToken;
    private String refreshToken;
    private String email;
    private String userType;
    private String nickname;
    private String address;
}
