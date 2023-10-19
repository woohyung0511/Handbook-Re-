package com.sns.handbook.oauth;

import com.github.scribejava.core.builder.api.DefaultApi20;
import org.springframework.stereotype.Component;

//네이버 로그인, Naver Login 구현체 추가
@Component
public class NaverOAuthApi extends DefaultApi20 {

    protected NaverOAuthApi() {
    }

    private static class InstanceHolder {
        private static final NaverOAuthApi INSTANCE = new NaverOAuthApi();
    }

    public static NaverOAuthApi instance() {
        return InstanceHolder.INSTANCE;
    }

    @Override
    public String getAccessTokenEndpoint() {
        //접근 토큰의 발급, 갱신, 삭제를 요청합니다.
        return "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code";
    }

    @Override
    protected String getAuthorizationBaseUrl() {
        //네이버 로그인 인증을 요청합니다.
        return "https://nid.naver.com/oauth2.0/authorize";
    }

}