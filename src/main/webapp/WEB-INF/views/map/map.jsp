<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>제로웨이스트지도</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script>
function validateForm() {
    var category = document.getElementById("category").value;
    // 문자열을 숫자로 변환
    var categoryInt = parseInt(category);
    // 숫자로 변환된 값을 다시 input 태그의 value에 설정
    document.getElementById("category").value = categoryInt;
    return true; // 폼 제출
}
</script>
<body>
	<div id="map" style="width: 1000px; height: 500px;"></div>
	<form name="regimap" method="post" action="/regimap" onsubmit="return validateForm()">
	    <input type="text" name="shopName" id="shopName" value="진호샵">
	    <input type="text" name="addr" id="addr" value="천안">
	    <select id="category" name="category" id="category">
	        <option value="5">베지테리안 옵션 가능</option>
	        <option value="4">비건 식당</option>
	        <option value="6">제로웨이스트샵</option>
	     </select>
	    <button type="submit">제출</button>
	</form>
	<br><br>
	<form name="searchShop" method="get" action="/mapList/searchShop">
		<select name="type" id="type">
			<option value="">검색 유형 선택</option>
			<option value="shopName">상점이름</option>
			<option value="addr">주소</option>
		</select>
		<td colspan="2">
          <input type="text" name="keyword" id="keyword" placeholder="검색어 입력">
        </td>
		<td>
          <input type="button" value="검색" onclick="searchCheck()">
		</td>
	</form>
	
	<script
		src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=4da202d77036151199a56057c568131d&libraries=clusterer"></script>
	<script>

	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(37.55489, 126.9708), // 지도의 중심좌표
			level : 5, // 지도의 확대 레벨
			mapTypeId : kakao.maps.MapTypeId.ROADMAP
		// 지도종류
		};

		// 지도를 생성한다 
		var map = new kakao.maps.Map(mapContainer, mapOption);

		// 마커 클러스터러를 생성합니다 
		var clusterer = new kakao.maps.MarkerClusterer({
			map : map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
			averageCenter : true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
			minLevel : 10
		// 클러스터 할 최소 지도 레벨 
		});
		var data = [];
		
		
		// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
		if (navigator.geolocation) {
		    
		    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
		    navigator.geolocation.getCurrentPosition(function(position) {
		        
		        	var lat = position.coords.latitude, // 위도
		             	lon = position.coords.longitude; // 경도
		        
		        var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
		            message = '<div style="padding:5px;">사용자의 현재 위치</div>'; // 인포윈도우에 표시될 내용입니다
		        
		        // 마커와 인포윈도우를 표시합니다
		        displayMarker(locPosition, message, lat, lon);
		            
		      });
		    
		} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
		    lat=33.450701;
			lon=126.570667;
			
		    var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
		        message = 'geolocation을 사용할 수 없어요'
		        
		    displayMarker(locPosition, message, lat, lon);
		}

		// 지도에 마커와 인포윈도우를 표시하는 함수입니다
		function displayMarker(locPosition, message, lat, lon) {

		    // 마커를 생성합니다
		    var marker = new kakao.maps.Marker({  
		        map: map, 
		        position: locPosition
		    }); 
		    
		    var iwContent = message, // 인포윈도우에 표시할 내용
		        iwRemoveable = true;

		    // 인포윈도우를 생성합니다
		    var infowindow = new kakao.maps.InfoWindow({
		        content : iwContent,
		        removable : iwRemoveable
		    });
		    
		    // 인포윈도우를 마커위에 표시합니다 
		    infowindow.open(map, marker);
		    
		    // 지도 중심좌표를 접속위치로 변경합니다
		    map.setCenter(locPosition);  
		    sideInfo(lat, lon);
		}    
		
		<c:choose>
		<c:when test="${not empty mapList}">
		   <c:forEach items="${mapList}" var="m">
			data.push([ ${m.lat}, ${m.lng},
				'<div style="padding: 5px">${m.shopName}</div> <div>${m.addr}</div>' ]);
		   </c:forEach>
		</c:when>
		<c:otherwise>
			alert('검색 결과가 존재하지 않습니다.');
			location.href='javascript:history.back()';
		</c:otherwise>
	</c:choose>
	   
	   
		var markers = [];

		for (var i = 0; i < data.length; i++) {
			
			// 지도에 마커를 생성하고 표시한다
			var marker = new kakao.maps.Marker({
				position : new kakao.maps.LatLng(data[i][0], data[i][1]), // 마커의 좌표
				map : map
			// 마커를 표시할 지도 객체
			});

			var iwContent = '<div style="padding: 5px">내용</div>';
			// 인포윈도우를 생성합니다
			
			var infowindow = new kakao.maps.InfoWindow({
 		   content: '<div style="padding: 20px; font-size: 14px; text-align: center; margin-top: -3px;">' + data[i][2] + '</div>'
			});

			
			markers.push(marker);
			kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(
					map, marker, infowindow));
			kakao.maps.event.addListener(marker, 'mouseout',
					makeOutListener(infowindow));
		}
		// 클러스터러에 마커들을 추가합니다
		clusterer.addMarkers(markers);

		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(map, marker, infowindow) {
			return function() {
				infowindow.open(map, marker);
			};
		}

		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function makeOutListener(infowindow) {
			return function() {
				infowindow.close();
			};
		}
	</script>
	
	
	<script>
	function searchCheck(){
		if(!searchShop.type.value){
			alert('검색 유형을 선택하세요');
			return;
		}
		if(!searchShop.keyword.value){
			alert('검색어를 입력하세요');
			var key = document.getElementById("keyword");
			key.focus();
			return;
		}
		searchShop.submit();
	}
	</script>
	
	<c:import url="/mapSidebar2"/>
	
	<script>
	
	
	$(document).ready(function() {
	    
	    //sideInfo()
	});

	function sideInfo(lat, lon){
		alert("##"+lat);
		 $.ajax({
		        url: '/mapSidebar?lat='+lat+'&lng='+lon,
		        type: 'GET',
		        success: function(data) {
		        	alert(data);
		            var table='';
		            table+=data[0].addr;
		            $('body').append(table);
		        }
		    });
		
	}
	</script>
</body>
</html>