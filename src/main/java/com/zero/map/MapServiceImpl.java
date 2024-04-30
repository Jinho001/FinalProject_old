package com.zero.map;


import org.springframework.stereotype.Service;

import com.zero.waste.mapper.MapMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MapServiceImpl implements MapService {
	
	private final MapMapper mapMapper;
	
	@Override
	public int registMap(MapVO mapInfo) {
		return mapMapper.registMap(mapInfo);
	}

}
