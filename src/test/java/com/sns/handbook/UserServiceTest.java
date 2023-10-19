package handbook;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.MockitoJUnitRunner;

import com.sns.handbook.dto.PostDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.mapper.UserMapperInter;
import com.sns.handbook.serivce.UserService;

@RunWith(MockitoJUnitRunner.class)
public class UserServiceTest {
	
    @InjectMocks
    private UserService userService;

    @Mock
    private UserMapperInter usermapperInter;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this); // Mockito 초기화 및 Mock 객체 생성
    }

    @Test
    public void testUpdateCover() {
        // 테스트할 데이터
        String user_num = "123";
        String user_cover = "test_cover.jpg";

        // given: Mock 객체의 동작 설정 및 예상되는 파라미터를 설정
        Map<String, String> expectedParams = new HashMap<>();
        expectedParams.put("user_num", user_num);
        expectedParams.put("user_cover", user_cover);

        // when: Mock 객체의 메서드 호출 설정 (for void methods, use doNothing)
        doNothing().when(usermapperInter).updateCover(expectedParams);

        // when: 테스트 대상 메서드 호출
        userService.updateCover(user_num, user_cover);

        // then: 결과 검증
        verify(usermapperInter).updateCover(expectedParams); // updateCover 메소드가 호출되었는지 확인
    }
}
