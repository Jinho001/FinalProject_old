<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>제로웨이스트지도</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
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
<style>
	#mapwrap{position:relative;overflow:hidden;}
	.category, .category *{margin:0;padding:0;color:#000;}   
	.category {position:absolute;overflow:hidden;top:10px;left:10px;width:350px;height:54px;z-index:10;border:1px solid black;font-family:'Malgun Gothic','맑은 고딕',sans-serif;font-size:12px;text-align:center;background-color:#fff;}
	.category .menu_selected {background:#FF5F4A;color:#fff;border-left:1px solid #915B2F;border-right:1px solid #915B2F;margin:0 -1px;} 
	.category li{list-style:none;float:left;width:50px;height:45px;padding-top:10px;cursor:pointer;} 
	.category .ico_comm {display:block;margin:0 auto 2px;width:22px;height:26px;} 
	.category .ico_bookstore {background-position:-10px 0; background:url('/images/category1.png'); background-size: 100% 100%}  
	.category .ico_pub {background-position:-10px -36px; background:url('/images/category2.png'); background-size: 100% 100%}
	.category .ico_vege {background-position:-10px -72px; background:url('/images/category3.png'); background-size: 100% 100%}
	.category .ico_vegan {background-position:-10px -108px; background:url('/images/category4.png'); background-size: 100% 100%} 
	.category .ico_zero {background-position:-10px -144px; background:url('/images/category5.png'); background-size: 100% 100%} 
	.category .ico_hairsalon {background-position:-10px -180px; background:url('/images/category6.png'); background-size: 100% 100%} 
	.category .ico_etc {background-position:-10px -216px; background:url('/images/category7.png'); background-size: 100% 100%}  
</style>
<body>
<div id="mapwrap">
	 <!-- 지도가 표시될 div -->
	<div id="map" style="width: 1000px; height: 500px;"></div>
	<!-- 지도 위에 표시될 마커 카테고리 -->
    <div class="category">
        <ul>
            <li id="bookstoreMenu" onclick="changeMarker('bookstore')">
                <span class="ico_comm ico_bookstore"></span>
                책방
            </li>
            <li id="pubMenu" onclick="changeMarker('pub')">
                <span class="ico_comm ico_pub"></span>
                술집
            </li>
            <li id="vegeMenu" onclick="changeMarker('vege')">
                <span class="ico_comm ico_vege"></span>
                채식식당
            </li>
            <li id="veganMenu" onclick="changeMarker('vegan')">
                <span class="ico_comm ico_vegan"></span>
                비건식당
            </li>
            <li id="zeroMenu" onclick="changeMarker('zero')">
                <span class="ico_comm ico_zero"></span>
                zerowaste
            </li>
            <li id="hairsalonMenu" onclick="changeMarker('hairsalon')">
                <span class="ico_comm ico_hairsalon"></span>
                미용실
            </li>
            <li id="etcMenu" onclick="changeMarker('etc')">
                <span class="ico_comm ico_etc"></span>
                기타
            </li>
        </ul>
    </div>
</div>
	<br><br>
	<form name="regimap" method="post" action="/regimap" onsubmit="return validateForm()">
	    <input type="text" name="shopName" id="shopName" value="진호샵">
	    <input type="text" name="addr" id="addr" value="천안">
	    <select id="category" name="category" id="category">
			<option value="2">책방</option>
			<option value="3">술집</option>
			<option value="4">채식 옵션 가능 식당</option>
			<option value="5">100% 비건식당</option>
			<option value="6">제로웨이스트샵</option>
			<option value="7">미용실</option>
			<option value="1">기타</option>
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
		
		//--------마커 표시-------------------------------------------
		//1. 책방 마커가 표시될 좌표 배열
		var bookstorePositions = [];
		//2. 술집 마커가 표시될 좌표 배열
		var pubPositions = [];
		//3. 채식 식당이 표시될 좌표 배열
		var vegePositions =[];
		
		// 마커이미지의 주소 (스프라이트 이미지)
		var markerImageSrc = '/images/category7.png';
		//createBookstoreMarkers(markerImageSrc1);
		bookstoreMarkers = [], // 책방 마커 객체를 가지고 있을 배열입니다
	    pubMarkers = [], // 술집 마커 객체를 가지고 있을 배열입니다
	    vegeMarkers = []; // 채식식당 마커 객체를 가지고 있을 배열입니다
	    
	    //createBookstoreMarkers(markerImageSrc1); // 커피숍 마커를 생성하고 커피숍 마커 배열에 추가합니다
	   // createPubMarkers(); // 편의점 마커를 생성하고 편의점 마커 배열에 추가합니다
	    //createVegeMarkers(); // 주차장 마커를 생성하고 주차장 마커 배열에 추가합니다
		
	   // changeMarker('bookstore'); // 지도에 책방 마커가 보이도록 설정합니다  
	    
	 	// 마커이미지의 주소와, 크기, 옵션으로 마커 이미지를 생성하여 리턴하는 함수입니다
	    function createMarkerImage(src, size, options) {
		    //alert(src);
	        var markerImage = new kakao.maps.MarkerImage(src, size, options);
	        return markerImage;            
	    }
	    
	 	// 좌표와 마커이미지를 받아 마커를 생성하여 리턴하는 함수입니다
	    function createMarker(position, image) {
	 		//console.log("position====="+position[0], position[1]);
	 		console.dir(image)
	        var marker = new kakao.maps.Marker({
	            position: new kakao.maps.LatLng(position[0], position[1]),
	            image: image
	        });
	        
	        return marker;  
	    }
	 	
	 	// 책방 마커를 생성하고 책방 마커 배열에 추가하는 함수입니다
	    function createBookstoreMarkers(markerImageSrc) {
	 		//alert(bookstorePositions.length+"<<<");
	        var imageSrc = '/images/category1.png';
	      for (var i = 0; i < bookstorePositions.length; i++) {  
	            
	            var imageSize = new kakao.maps.Size(26, 26),
	                imageOption = {offset: new kakao.maps.Point(27, 69)};
	            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
		        markerPosition = new kakao.maps.LatLng(bookstorePositions[i][0], bookstorePositions[i][1]);           
	            var marker = new kakao.maps.Marker({
	      	      position: markerPosition,
	      	      image: markerImage // 마커이미지 설정 
	      	    });
	            var iwContent = '<div style="padding: 5px">내용</div>';
	    		// 인포윈도우를 생성합니다
	    		
	    		var infowindow = new kakao.maps.InfoWindow({
	    		   content: '<div style="padding: 19px; font-size: 14px; text-align: center; margin-top: -3px;">' + bookstorePositions[i][2] + '</div>'
	    		});

	    		bookstoreMarkers.push(marker);
	    		//markers.push(marker);
	    		kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(
	    				map, marker, infowindow));
	    		kakao.maps.event.addListener(marker, 'mouseout',
	    				makeOutListener(infowindow));
	            marker.setMap(map);  
	            /* 
	            // 마커이미지와 마커를 생성합니다
	            var markerImage = createMarkerImage(markerImageSrc, imageSize, imageOptions),    
	                marker = createMarker(bookstorePositions[i], markerImage);  
	            //alert(bookstoreMarkers.length+"/"+marker)
	            // 생성된 마커를 책방 마커 배열에 추가합니다
	            bookstoreMarkers.push(marker);
	            */
	            
	        }      
	    	
	     }

	    // 책방 마커들의 지도 표시 여부를 설정하는 함수입니다
	    function setBookstoreMarkers(map) {   
	    	//createBookstoreMarkers('/images/category7.png');
	        for (var i = 0; i < bookstoreMarkers.length; i++) {  
	            bookstoreMarkers[i].setMap(map);
	        }        
	    }

	 	// 술집 마커를 생성하고 술집 마커 배열에 추가하는 함수입니다
	    function createPubMarkers() {
	        
	        for (var i = 0; i < pubPositions.length; i++) {  
	            
	            var imageSize = new kakao.maps.Size(22, 26),
	                imageOptions = {  
	                    spriteOrigin: new kakao.maps.Point(10, 36),    
	                    spriteSize: new kakao.maps.Size(36, 98)  
	                };     
	            
	            // 마커이미지와 마커를 생성합니다
	            var markerImage = createMarkerImage(markerImageSrc, imageSize, imageOptions),    
	                marker = createMarker(pubPositions[i], markerImage);  
	            
	            // 생성된 마커를 술집 마커 배열에 추가합니다
	            pubMarkers.push(marker);
	        }     
	    }

	    // 술집 마커들의 지도 표시 여부를 설정하는 함수입니다
	    function setPubMarkers(map) {        
	        for (var i = 0; i < pubMarkers.length; i++) {  
	            pubMarkers[i].setMap(map);
	        }        
	    }
	    
	 	// 채식식당 마커를 생성하고 채식식당 마커 배열에 추가하는 함수입니다
	    function createVegeMarkers() {
	        
	        for (var i = 0; i < vegePositions.length; i++) {  
	            
	            var imageSize = new kakao.maps.Size(22, 26),
	                imageOptions = {  
	                    spriteOrigin: new kakao.maps.Point(10, 72),    
	                    spriteSize: new kakao.maps.Size(36, 98)  
	                };     
	            
	            // 마커이미지와 마커를 생성합니다
	            var markerImage = createMarkerImage(markerImageSrc, imageSize, imageOptions),    
	                marker = createMarker(vegePositions[i], markerImage);  
	            
	            // 생성된 마커를 채식식당 마커 배열에 추가합니다
	            vegeMarkers.push(marker);
	        }     
	    }

	    // 채식식당 마커들의 지도 표시 여부를 설정하는 함수입니다
	    function setVegeMarkers(map) {        
	        for (var i = 0; i < vegeMarkers.length; i++) {  
	            vegeMarkers[i].setMap(map);
	        }        
	    }
	   
	    
	    function changeMarker(type){
	        
	        var bookstoreMenu = document.getElementById('bookstoreMenu');
	        var pubMenu = document.getElementById('pubMenu');
	        var vegeMenu = document.getElementById('vegeMenu');
	        
	       // 책방 카테고리가 클릭됐을 때
	       if(type == 'bookstore') {
	        
	            // 책방 카테고리를 선택된 스타일로 변경하고
	            bookstoreMenu.className = 'menu_selected';
	            
	            // 나머지 카테고리는 선택되지 않은 스타일로 바꿉니다
	            pubMenu.className = '';
	            vegeMenu.className = '';
	            
	            // 책방 마커들만 지도에 표시하도록 설정합니다
	            //setBookstoreMarkers(map);
	            setPubMarkers(null);
	            setVegeMarkers(null);
	           
	            $.ajax({
		           	type:'post',
		           	url:'/mapList/searchCategory',
		           	data:{ intValue: 2 },
		           	dataType:'json',
		           	contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		           	cache:false
		        })
		        .done((res)=>{
		        	//alert(res.length)
		        	$.each(res, function(i){ 
		        		//alert(i)
		        		bookstorePositions.push([ res[i].lat, res[i].lng,
		        			'<div style="padding: 5px">'+res[i].shopName+'</div> <div>'+res[i].addr+'</div>' ]);
		        		//makeMarkers(bookstorePositions);
		        		var markerImageSrc1 = '/images/category7.png';
		        		createBookstoreMarkers(markerImageSrc1);
					})
		        })
		        .fail((err)=>{
		           	alert(err.status);
		        })      
	        } else if (type === 'pub') { // 술집 카테고리가 클릭됐을 때
	        
	            // 술집 카테고리를 선택된 스타일로 변경하고
	            bookstoreMenu.className = '';
	            pubMenu.className = 'menu_selected';
	            vegeMenu.className = '';
	            
	            // 술집 마커들만 지도에 표시하도록 설정합니다
	            setBookstoreMarkers(null);
	            setPubMarkers(map);
	            setVegeMarkers(null);
	            
	        } else if (type === 'vege') { // 채식식당 카테고리가 클릭됐을 때
	         
	            // 채식식당 카테고리를 선택된 스타일로 변경하고
	            bookstoreMenu.className = '';
	            pubMenu.className = '';
	            vegeMenu.className = 'menu_selected';
	            
	            // 채식식당 마커들만 지도에 표시하도록 설정합니다
	            setBookstoreMarkers(null);
	            setPubMarkers(null);
	            setVegeMarkers(map);
	        }    
	    } 
	    
		// 마커 클러스터러를 생성합니다 
		var clusterer = new kakao.maps.MarkerClusterer({
			map : map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
			averageCenter : true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
			minLevel : 10
		// 클러스터 할 최소 지도 레벨 
		});
		
		// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
		if (navigator.geolocation) {
		    
		    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
		    navigator.geolocation.getCurrentPosition(function(position) {
		        
		        var lat = position.coords.latitude, // 위도
		            lon = position.coords.longitude; // 경도
		        
		        var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
		            message = '<div style="padding:5px;">사용자의 현재 위치</div>'; // 인포윈도우에 표시될 내용입니다
		        
		        // 마커와 인포윈도우를 표시합니다
		        displayMarker(locPosition, message);
		            
		      });
		    
		} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
		    
		    var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
		        message = 'geolocation을 사용할 수 없어요'
		        
		    displayMarker(locPosition, message);
		}

		// 지도에 마커와 인포윈도우를 표시하는 함수입니다
		function displayMarker(locPosition, message) {

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
		}    
	var data = [];
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
		
//data배열 --> 카테고리별 배열 삽입
function makeMarkers(data){
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
}
	//클러스터러에 마커들을 추가합니다
	clusterer.addMarkers(markers);
	
	//인포윈도우를 표시하는 클로저를 만드는 함수입니다 
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
</body>
</html>