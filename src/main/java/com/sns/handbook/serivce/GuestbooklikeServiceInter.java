package com.sns.handbook.serivce;

import com.sns.handbook.dto.GuestbooklikeDto;

public interface GuestbooklikeServiceInter {

	public int getTotalGuestLike(String guest_num);
	public void insertGuestLike(GuestbooklikeDto dto);
	public void deleteGuestLike(String guest_num ,String user_num);
	public int checkGuestLike(String user_num,String guest_num);
}
