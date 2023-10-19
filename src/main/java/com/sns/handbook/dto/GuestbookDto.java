package com.sns.handbook.dto;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("GuestbookDto")
public class GuestbookDto {

	private String guest_num;
	private String write_num;
	private String owner_num;
	private String guest_content;
	private String guest_file;
	private String guest_access;
	private Timestamp guest_writeday;
	
	//add
	private String type="guest";
	private int comment_count;
	private String user_name;
	
	
}
