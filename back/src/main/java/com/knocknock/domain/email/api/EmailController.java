package com.knocknock.domain.email.api;

import com.knocknock.domain.email.dto.EmailCodeReqDto;
import com.knocknock.domain.email.dto.EmailCodeResDto;
import com.knocknock.domain.email.dto.EmailPostDto;
import com.knocknock.domain.email.service.EmailService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/email")
@RestController
@RequiredArgsConstructor
public class EmailController {

    private final EmailService emailService;

    @Operation(
            summary = "회원가입 이메일 인증 코드 발신",
            description = "회원가입시 이메일 인증 코드 유효 검사를 위한 이메일 인증 코드 발신입니다."
    )
    @PostMapping("/sign-up")
    public ResponseEntity<EmailCodeResDto> sendSignUpMail(@RequestBody EmailPostDto emailPostDto) {
        return ResponseEntity.ok(emailService.sendEmail(emailPostDto, "email"));
    }

    @Operation(
            summary = "이메일 중복 검사",
            description = "회원가입 이전에 이메일을 중복검사합니다. " +
                    "중복이 아니라 회원가입이 가능하면 true를 반환합니다."
    )
    @GetMapping("/check")
    public ResponseEntity<Boolean> checkEmail(@RequestParam String email) {
        return ResponseEntity.ok(emailService.checkEmail(email));
    }

    @Operation(
            summary = "임시 비밀번호 발급",
            description = "비밀번호 찾기를 위한 임시 비밀번호 발급입니다."
    )
    @PostMapping("/password")
    public ResponseEntity<EmailCodeResDto> sendPasswordMail(@RequestBody EmailPostDto emailPostDto) {
        return ResponseEntity.ok(emailService.sendEmail(emailPostDto, "password"));
    }

    @Operation(
            summary = "이메일 인증 코드 유효 검사",
            description = "인증 코드가 일치하는지 체크합니다."
    )
    @PostMapping("/check")
    public ResponseEntity<Boolean> checkEmailCode(@RequestBody EmailCodeReqDto emailCodeReqDto) {
        return ResponseEntity.ok(emailService.checkEmailCode(emailCodeReqDto));
    }


}
