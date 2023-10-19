package com.sns.handbook.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.CommentDto;
import com.sns.handbook.dto.CommentlikeDto;
import com.sns.handbook.dto.GuestbookDto;
import com.sns.handbook.dto.PostDto;

@Mapper
public interface CommentMapperInter {

	public int getMaxNum();
	public void updateStep(Map<String, Integer> map);
	public void insert(CommentDto dto);
	public void delete(String comment_num);
	public void deleteGroup(int comment_num);
	public CommentDto getData(String comment_num);
	public List<CommentDto> getDataGroupStep(Map<String, Integer> map);
	public void update(CommentDto dto);
	public List<CommentDto> selectScroll(Map<String, Object> map);
	public List<CommentDto> selectGuestScroll(Map<String, Object> map);
	public List<CommentDto> getAllDatas();
	
	//댓글 좋아요 부분
	public void insertLike(CommentlikeDto dto);
	public void deleteLike(Map<String, String> map);
	public int getTotalLikes(String comment_num);
	public int getLikeCheck(Map<String, String> map);
	
	
	public int getTotalCount(String post_num);
	public int getTotalGuestCount(String guest_num);
	public GuestbookDto getDataByGuestNum(String guest_num);
}
