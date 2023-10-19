package com.sns.handbook.serivce;

import java.util.List;

import com.sns.handbook.dto.CommentDto;
import com.sns.handbook.dto.CommentlikeDto;
import com.sns.handbook.dto.GuestbookDto;

public interface CommentServiceInter {

	public int getMaxNum();
	public void updateStep(int comment_group,int comment_step);
	public void insert(CommentDto dto);
	public void delete(String comment_num);
	public void deleteGroup(int comment_num);
	public CommentDto getData(String comment_num);
	public List<CommentDto> getDataGroupStep(int comment_group,int comment_step);
	public void update(CommentDto dto);
	public List<CommentDto> selectScroll(String post_num,int offset);
	public List<CommentDto> selectGuestScroll(String guest_num,int offset);
	public List<CommentDto> getAllDatas();
	
	//댓글 좋아요 부분
	public void insertLike(CommentlikeDto dto);
	public void deleteLike(String user_num,String comment_num);
	public int getTotalLikes(String comment_num);
	public int getLikeCheck(String user_num,String comment_num);	
	
	
	
	public int getTotalCount(String post_num);
	public int getTotalGuestCount(String guest_num);
	public GuestbookDto getDataByGuestNum(String guest_num);

}
