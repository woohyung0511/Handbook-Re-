package com.sns.handbook.mapper;

import java.util.Map;

import com.sns.handbook.dto.PostlikeDto;

public interface PostlikeMapperInter {
	public int getTotalLike(String post_num);
	public void insertLike(PostlikeDto dto);
	public void deleteLike(String post_num,String user_num);
	public int checklike(Map<String, String> map);
}
