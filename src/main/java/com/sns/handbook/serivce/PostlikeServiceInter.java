package com.sns.handbook.serivce;

import java.util.Map;

import com.sns.handbook.dto.PostlikeDto;

public interface PostlikeServiceInter {

	public int getTotalLike(String post_num);
	public void insertLike(PostlikeDto dto);
	public void deleteLike(String post_num ,String user_num);
	public int checklike(String user_num,String post_num);
}
