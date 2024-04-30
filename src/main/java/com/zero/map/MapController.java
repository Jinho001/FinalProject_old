package com.zero.map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MapController {
	
	private final MapService mapService;
	
	@PostMapping("/regimap")
	public String registMap(MapVO mapInfo) {
		
		mapService.registMap(mapInfo);

		return "map/map";
	}
	
}
