package com.sns.handbook.dto;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("ClikealarmDto")
public class ClikealarmDto {

	private String clikeal_num;
	private String receiver_num;
	private String sender_num;
	private String comment_num;
	private Timestamp alarmtime;
	
	private String sender_name;
	private String sender_photo;
	
	private long timeSec;
	private String time;
	
	private String type="clike";
}
