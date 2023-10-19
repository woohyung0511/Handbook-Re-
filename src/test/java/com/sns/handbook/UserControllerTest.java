package handbook;

import org.junit.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.MockitoJUnitRunner;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.*;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import com.sns.handbook.controller.UserController;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.serivce.UserService;

import java.io.IOException;
import javax.servlet.http.HttpSession;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.http.MediaType;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(MockitoJUnitRunner.class)
public class UserControllerTest {

    @InjectMocks
    private UserController userController;

    @Mock
    private UserService userService;

    private MockMvc mockMvc;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        this.mockMvc = MockMvcBuilders.standaloneSetup(userController).build();
    }

    @Test
    public void testCoverUpdate() throws Exception {
        // 테스트할 데이터
        String user_num = "123";
        String fileName = "test_cover.jpg";
        MockMultipartFile file = new MockMultipartFile("cover", fileName, MediaType.IMAGE_JPEG_VALUE, "test data".getBytes());
        HttpSession session = mock(HttpSession.class);
        
        // Mock 객체의 동작 설정
        doNothing().when(userService).updateCover(user_num, fileName);
        
        // HTTP POST 요청 시뮬레이션
        mockMvc.perform(MockMvcRequestBuilders.multipart("/user/coverupdate")
                .file(file)
                .param("user_num", user_num)
                .sessionAttr("dto", new UserDto()))
                .andExpect(status().isOk());
        
        // 서비스 메서드가 호출되었는지 확인
        verify(userService).updateCover(user_num, fileName);
    }
}
