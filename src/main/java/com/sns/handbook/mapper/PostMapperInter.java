package com.sns.handbook.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.PostDto;

@Mapper
public interface PostMapperInter {
	public int getTotalCount();
	public void insertPost(PostDto dto);
	public List<PostDto> postList(Map<String, Object> map); // 파라미터값 변경	public void deletePost(int post_num);
	public void deletePost(String post_num);
	public void updatePhoto(Map<String, String> map);
	public void updatePost(PostDto dto);
	public PostDto getDataByNum(String post_num);
	public int checklogin(Map<String, String> map);
	
}
