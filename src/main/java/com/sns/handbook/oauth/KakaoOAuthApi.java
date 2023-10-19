package com.sns.handbook.oauth;

import com.github.scribejava.core.builder.api.DefaultApi20;
import org.springframework.stereotype.Component;

@Component
public class KakaoOAuthApi extends DefaultApi20 {

    protected KakaoOAuthApi() {
    }

    private static class InstanceHolder {
        private static final KakaoOAuthApi INSTANCE = new KakaoOAuthApi();
    }

    public static KakaoOAuthApi instance() {
        return InstanceHolder.INSTANCE;
    }

    @Override
    public String getAccessTokenEndpoint() {
        return "https://kauth.kakao.com/oauth/token";
    }

    @Override
    protected String getAuthorizationBaseUrl() {
        return "https://kauth.kakao.com/oauth/authorize";
    }

}
