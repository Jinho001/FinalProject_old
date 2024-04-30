package com.zero.map;

import lombok.Data;

@Data
public class MapVO {
	private String shopName;
	private String addr;
	private long lat;
	private long lng;
	private int category;
}
