package com.sns.handbook.oauth;

import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.servlet.http.HttpSession;
import java.util.UUID;

@Component
public class GoogleLoginBO {

    // 구글 로그인 정보
    private final static String GOOGLE_CLIENT_ID = "606007311099-ndg9fvd658k02pa5vqaege0evsvcj8kh.apps.googleusercontent.com";
    private final static String GOOGLE_CLIENT_SECRET = "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";
    private final static String GOOGLE_REDIRECT_URI = "http://localhost:7777/googlecallback";
    private final static String SESSION_STATE = "google_session_state";
    private final static String PROFILE_API_URL = "https://www.googleapis.com/oauth2/v1/userinfo";

    public String getAuthorizationUrl(HttpSession session) {
        String state = generateRandomString();
        setSession(session, state);

        OAuth20Service oauthService = new ServiceBuilder()
                .apiKey(GOOGLE_CLIENT_ID)
                .apiSecret(GOOGLE_CLIENT_SECRET)
                .callback(GOOGLE_REDIRECT_URI)
                .state(state)
                .scope("profile email")
                .build(GoogleOAuthApi.instance());
        return oauthService.getAuthorizationUrl();
    }

    public OAuth2AccessToken getAccessToken(HttpSession session, String code, String state) throws Exception {
        String sessionState = getSession(session);
        if (StringUtils.pathEquals(sessionState, state)) {
            OAuth20Service oauthService = new ServiceBuilder()
                    .apiKey(GOOGLE_CLIENT_ID)
                    .apiSecret(GOOGLE_CLIENT_SECRET)
                    .callback(GOOGLE_REDIRECT_URI)
                    .state(state)
                    .scope("profile email")
                    .build(GoogleOAuthApi.instance());
            OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
            return accessToken;
        }
        return null;
    }

    public String getUserProfile(OAuth2AccessToken oauthToken) throws Exception {
        OAuth20Service oauthService = new ServiceBuilder()
                .apiKey(GOOGLE_CLIENT_ID)
                .apiSecret(GOOGLE_CLIENT_SECRET)
                .callback(GOOGLE_REDIRECT_URI)
                .scope("profile email")
                .build(GoogleOAuthApi.instance());
        OAuthRequest request = new OAuthRequest(Verb.GET, PROFILE_API_URL, oauthService);
        oauthService.signRequest(oauthToken, request);
        Response response = request.send();
        String responseBody = response.getBody();

        return responseBody;
    }

    private String generateRandomString() {
        return UUID.randomUUID().toString();
    }

    private void setSession(HttpSession session, String state) {
        session.setAttribute(SESSION_STATE, state);
    }

    private String getSession(HttpSession session) {
        return (String) session.getAttribute(SESSION_STATE);
    }
}
