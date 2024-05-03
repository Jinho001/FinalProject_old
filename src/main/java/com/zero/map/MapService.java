package com.zero.map;

import java.util.List;

public interface MapService {

	int registMap(MapVO mapInfo);

	List<MapVO> selectMapView();

	List<MapVO> getMapAll(MapVO vo);
	
}
