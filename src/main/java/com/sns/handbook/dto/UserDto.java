package com.sns.handbook.dto;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("UserDto")
public class UserDto {
	private String user_num;
	private String user_id ;
	private String user_pass;
	private String user_name;
	private String user_hp;
	private String user_addr;
	private String user_email;
	private String user_gender;
	private String user_birth;
	private Timestamp user_joindate;
	private String user_photo;
	private String user_description;
	private String user_cover;
	private String mail_auth;
	private String mail_key;
	
	private int tf_count;
}
