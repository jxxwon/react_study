<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>JobKorea</title>


<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> <!-- 다음 api   -->

<!-- 거래처 관리  -->

<style>
	#layer1,#layer2 {
  overflow-y: scroll;
}

</style>

<script type="text/javascript">

//페이징 설정 
var pageSizeEstList = 5; // 행 다섯개 
var pageBlockSizeEstList = 5;  // 블록 갯수 일단 출력

//금액 => 한글로 치환 해주는 함수 

// 1 ~ 9 한글 표시
var arrNumberWord = new Array("","일","이","삼","사","오","육","칠","팔","구");
// 10, 100, 100 자리수 한글 표시
var arrDigitWord = new  Array("","십","백","천");
// 만단위 한글 표시
var arrManWord = new  Array("","만","억", "조");


$(document).ready(function(){
	
	comcombo("cust_name", "client_search","all");
	
	comcombo("cust_name", "client_search1","all");
	
	// 견적서 목록 조회
	estList();
	
	//모달창 초기화
	 estInitForm();
	
	// 버튼 이벤트 등록
	eRegisterButtonClickEvent();
	
});



/** 버튼 이벤트 등록 */
function eRegisterButtonClickEvent() {
	$('a[name=btn]').click(function(e) {
		e.preventDefault();

		var btnIdEst = $(this).attr('id'); // id값 들어오면 변수에 넣어준다 

		switch (btnIdEst) {

			case 'btnUpdateEst' : // 신규등록 , 저장 
				eSaveEst();
				break;
			case 'btnDeleteEst' : // 삭제 
				eDeleteEst();
				break;
			case 'btnSearchEst': // 검색 
				eSearchEst();
				break;
			case 'btnCloseEst' : // 모달 닫기 함수 
				gfCloseModal();
				break;
			case 'btnApplyYes' : // 견적 승인 함수 
				gfApplyYes();
				break;
			case 'btnApplyNo' : // 견적 반려 함수
				gfApplyNo();
				break;
		}
	});
}

/*  1. 견적서 신규 등록 모달  :  모달 실행 */
 function estModal1(estm_num){
   
   // 신규 저장  - 데이터 없음
   if (estm_num == null || estm_num =="") {
   
      // Tranjection type 설정
      $("#action").val("I");
     
      //모달창 수정 초기화 
      estInitForm();
      
			var client_search1 = $("#client_search1").val();
			var estm_num = $("#estm_num").val();
			var major_class = $('#major_class').val();
			var sub_class =  $('#sub_class').val();
			var item_name =  $('#item_name').val();
			
			console.log("액션 I : 신규 등록");
			console.log("client_search1  client_search1 " ,  client_search1);
			console.log("major_class  major_class " ,  major_class);
			console.log("sub_class  sub_class " ,  sub_class);
			console.log("item_name  item_name " ,  item_name);
      
      // 모달 팝업         	
		 gfModalPop("#layer1");

   }	
}

 /*  1-1  ReadOnly 모달 / 삭제  수정 가능  =>  erp에서 연결하지 않는 이상은 수정 삭제 가능  :  모달 실행 */
 function estModal2(estm_num){

	   
	   if (estm_num != null || estm_num !="") {
 		  // readonly 붙이기 
       $("#loginID").attr("readonly", true);
       // Tranjection type 설정
       $("#action").val("U");
       

		$("#divtitle").append("<strong>거래처등록</strong>");
       // 모달 팝업         	
		 gfModalPop("#layer2");
			
	   }
 }


 /*  2 .단건조회 등등  모달창 값 초기화  */
	function estInitForm(data) {
	   
	   console.log("estInitForm",data)
		$("#estCnt").focus();
	   $("#test").empty();
		
		//2 - 1 신규등록	일 때
		if( data == "" || data == null || data == undefined) {
			
			$("#estm_num").val("");  // hidden 
			$("#client_search1").val(""); // 거래처 콤보박스
			$("#major_class").val(""); //  대분류
			$("#sub_class").val(""); // 중분류
			$("#item_name").val(""); // 제품
			$("#qut").val(""); //수량
			
			
			$('#divtitle').empty();
			
			$("#divtitle").append("<strong>견적서 등록</strong>");
			

 
		} else {
			
			//2 - 2 단건 상세조회 모달창 

			console.log("단건 조회 전 모달 보기 ", data[0].cust_name)
			
		 	$("#cust_name22").val(data[0].cust_name);
		 	$("#biz_num").val(data[0].biz_num); 
		 	$("#cust_person").val(data[0].cust_person); 
		 	$("#cust_addr").val(data[0].cust_addr); 
		 	$("#cust_detail_addr").val(data[0].cust_detail_addr); 
		 	
		 	$("#estm_date").val(data[0].estm_date);
	
		 	
		 	$("#client_search1").val(data.client_search); 

			// 담당자 번호 
			$("#cust_person_ph").val(data[0].cust_person_ph);	
			
			

			
			// 작성자 본인일때만 수정,삭제영역 보임
		 	if(estList.login_id!="${loginId}"){
				$("#changeArea").hide();
			} else{
				$("#changeArea").show();
			}
			
			if(data[0].apply_yn == "W"){
				var html = ""
					html += "<input value='" + data[0].estm_num + "' type='hidden' id='estm_num'>";
					html += "<a href='javascript:gfApplyYes()' class='btnType blue' id='btnApplyYes' name='btn'><span>승인</span></a>";
				$("#test").append(html);
			}
			
			
			
		}
	}
 
 


 /**  3.  처음 견적서 목록 뿌려주기 */
	function estList(currentPage) {  
	
		currentPage = currentPage || 1;

		var client_search =   $("#client_search").val();
		// 날짜 1
		var to_date = $("#to_date").val();
		// 날짜 2
		var from_date = $("#from_date").val();
		
     var param = {
     	
          	currentPage 	: currentPage
          	,pageSize 		: pageSizeEstList
			,client_search  : client_search
          	,to_date 		: to_date 
          	,from_date		: from_date

     }

	     console.log(" param : " , param);
		 console.log("param.valueOf()",  param.valueOf());
		
		 
		 //콜백
		var resultCallback = function(data) {
			console.log("=======resultCallback========");
		
			//목록 조회 결과 
			estListResult(data, currentPage);
			console.log(" 목록뿌려주기 조회결과 data ",data);
		};
		
		/*  보낼 링크 / 컨트롤러로 보낼 방식 /  받을 방식 ,데이터,, 비동기? 동기,     돌려 줄 함수  */
		callAjax("/business/estMngList.do", "post", "text", true, param, resultCallback); 
	 		
	}
 

	/**  3-1.목록조회 콜백 함수 */
	function estListResult(data,currentPage) {
		
		console.log("목록조회 콜백함수 ",data);

		// 기존 목록 삭제
		$('#listEstManage').empty(); 
		// 신규 목록 생성
		$("#listEstManage").append(data);
		// 총 갯수 추출
		var estCnt = $("#estCnt").val();
		
		console.log("estCnt ", estCnt);
		console.log("currentPage ", currentPage);
		
		
		// 네비게이션
		//	현재페이지  , 행 갯수 , 리스트사이즈 , 블록 갯수 , 목록리스트함수 
		var estManageHtml = getPaginationHtml(
				currentPage, 
				estCnt,
				pageSizeEstList ,  
				pageBlockSizeEstList,
				'estList'
				);
		
		console.log("estManageHtml  : " + estManageHtml );

		//네비게이션 비우고 다시 채우기
		$("#EstPagination").empty().append( estManageHtml );
		
		// BizCurrentPage 에 현재 페이지 설정
		$("#EstCurrentPage").val(currentPage);
		
		// 값이제대로 왔다 확인 
		var EstCurrentPage = $("#EstCurrentPage").val();
		console.log("EstCurrentPage " +  EstCurrentPage);
		
	}
 
	
	
	/** 4-1. 단건 조회 */
	function estOne(estm_num) {

		var param = {
				estm_num : estm_num
		};

		var resultCallback = function(data) {
			estOneResult(data);
		};
		
		callAjax("/business/estMngSelect.do", "post", "json", true, param, resultCallback);
	}
	
	
	
	/**  4-2 단건 조회 콜백 함수*/
	function estOneResult(data) {
		
			// 모달 팝업
			gfModalPop("#layer2");
			console.log("data", data)
			// 그룹코드 폼 데이터 설정
			estInitForm(data.estpart);
			
			
			// 숫자 -> 한글로 , 데이터값 바로 박음 
			fn_change_hangul_money(data.estpart.item_price ,data.estpart.qut);
			
			
			// 프로퍼티 
			// 사업자등록번호 
			$("#erp_copnum2").val(data.erp_copnum);	
			
	
			var beta0 = $("#erp_copnum1").val();
			var beta1 = $("#erp_copnum2").val();
			var beta1Answer = beta1.split("-");

			console.log("beta1Answer    ",beta1Answer);
			
			
			$("#erp_copnum2").val(beta1Answer[1]);
			var beta2 = $("#erp_copnum3").val();

			$("#erp_copnum3").val(beta1Answer[2]);
			
			if(beta0 != beta1Answer[0]){
				console.log("beta0    " ,  beta0);
				
				$("#erp_copnum1").val(beta1Answer[0]);
			}
			
	
			$("#slip_no").val(data.slip_no);
			
			// 회사이름 
			$("#erp_copnm").val(data.erp_copnm);	
			
			// 사업자등록번호
			$("#erp_copnum2").val(data.erp_copnum);	
			var beta0 = $("#erp_copnum1").val();
			var beta1 = $("#erp_copnum2").val();
			var beta1Answer = beta1.split("-");
			console.log("beta1Answer    ",beta1Answer);
		
			$("#erp_copnum2").val(beta1Answer[1]);
			var beta2 = $("#erp_copnum3").val();
			console.log("beta1Answer    ",beta1Answer[2]);
			$("#erp_copnum3").val(beta1Answer[2]);
			if(beta0 != beta1Answer[0]){
				console.log("beta0    " ,  beta0);
				$("#erp_copnum1").val(beta1Answer[0]);
			}
		
			// 담당자 
			$("#emp_name").val(data.erp_emp);	
			
			// 주소
			$("#erp_addr").val(data.erp_addr);	
			
			// 상세 주소
			$("#erp_addr_other").val("306호");
			
			// 전화번호
			$("#erp_tel").val(data.erp_tel);
	
			
			// 단건조회의 foreach문으로 리스트 뿌리기 
			estimatedetaillist(data.estpart[0].estm_num);
	}
	
	
	// 4-3 단건조회의 리스트 뿌리기 
	function estimatedetaillist(estm_num){
		console.log("단건 조회의 리스트 뿌리기 estm_num ", estm_num);
		
		
		 var param = {
				 estm_num : estm_num
	        };
			 //콜백
			var resultCallback = function(data) {
			
				//목록 조회 결과 
				estDetailListResult(data, estm_num);
			};
			
			/*  보낼 링크 / 컨트롤러로 보낼 방식 /  받을 방식 ,데이터,, 비동기? 동기,     돌려 줄 함수  */
			callAjax("/business/estDetaillist.do", "post", "text",  true, param, resultCallback); //text
	}
	
	
		// 4-4 단건조회의 리스트 뿌리기 콜백 
	 function estDetailListResult(data, estm_num){
		 
			// 기존 목록 삭제
			$('#EstDetaillist').empty(); 
			// 신규 목록 생성
			$("#EstDetaillist").append(data);
			
			$("#estm_num").val(estm_num);
	 }
	 
	 
	
	
	
	 /* 팝업내 수정, 저장 validation */
	 function eValidatePopup(data){
	
		 var chk = checkNotEmpty(
			 	 [
					 ["client_search1", "업체명을 체크해주세요!"],
					 ["scm_big_class", "대분류를 체크해주세요!"],
					 ["scm_middle_class", "중분류를 체크해주세요!"],
					 ["item_name", "제품을 체크해주세요!"],
					 ["obatin_count", "수량을 입력해주세요"]
				
				]
		 ); 
	 
	 	if(!chk){return;}
	 	return true;
	 }
	 
	 
	 /*  신규 등록 및 저장  */
	 function eSaveEst(){
		 
		 
		 // validation 체크 
		 if(!(eValidatePopup())){ return; }
		 
		
		 
		 var resultCallback = function(data){
			 
			 console.log("저장함수 타고 데이터", data)
			 eSaveResult(data); // 저장 콜백 함수 
		 };
	
	 callAjax("/business/estMngSave.do", "post", "json", true, $("#estForm1").serialize(), resultCallback);
		


		 	
	 }
	 
	/*  저장 & 수정  & 삭제 함수 콜백 함수 */
	 function  eSaveResult(data){

		
			var client_search1 = $("#client_search1").val();
			var estm_num = $("#estm_num").val();
			var cust_id = $("#cust_id").val();
			var major_class = $('#major_class').val();
			var sub_class =  $('#sub_class').val();
			var item_name =  $('#item_name').val();
			var qut =  $('#qut').val(); 
			 
			
			console.log("액션 I : 신규 등록");
			console.log("client_search1  client_search1 " ,  client_search1);
			console.log("major_class  major_class " ,  major_class);
			console.log("sub_class  sub_class " ,  sub_class);
			console.log("item_name  item_name " ,  item_name);
		
		 var currentPage = currentPage || 1; 
		 
	
		 if($("#action").val() != "I"){

			 alert("신규등록합니다");
			 
		 }

		 if(data.resultMsg == "SUCCESS"){
			
			 alert(data.resultMsg);	// 받은 메세지 출력 
			 alert("저장 되었습니다.");
			 
		 }else if(data.resultMsg == "UPDATED") {
			 alert("수정 되었습니다.");
			 
		 }else if(data.resultMsg == "DELETED") {
			 alert("삭제 되었습니다.");
			 
		 }else{
			 alert(data.resultMsg); //실패시 이거 탄다. 

		 }

		 gfCloseModal();	// 모달 닫기

		 estInitForm();// 입력폼 초기화
	 }
	
	 
	 
	 
	 	//검색구현
		function eSearchEst(currentPage) {
		 
			
		currentPage = currentPage || 1;
	
			// 날짜 1
			var to_date = $("#to_date").val();
			// 날짜 2
			var from_date = $("#from_date").val();
			
			console.log('to_date' , to_date);
			console.log('from_date' , from_date);

			
			// 거래처 넘기기 
			var client_search =   $("#client_search").val();
			console.log('client_search' , client_search);
			


			// 값 내용물 
			console.log("from_date : " + from_date.valueOf());     
			console.log("to_date : " + to_date.valueOf());     
			
			
	        var param = {
	        		   client_search : client_search
	              ,    currentPage : currentPage 
	              ,    pageSize : pageSizeEstList 
	              ,    from_date : from_date 
	              ,    to_date : to_date 
	        }
		     console.log(" param : " ,param);
			 console.log("param.valueOf()",  param.valueOf());
			
			var resultCallback = function(data) {
				console.log("=======resultCallback========");
			
				//목록 조회 결과 
				estListResult(data, currentPage);
				console.log(" 검색 조회결과 data ",data);
			};
			
			
			// 목록조회에 던져준다.
			/*  순서 주의 :  보낼 링크 / 컨트롤러로 보낼 방식 /  받을 방식 ,데이터,, 비동기? 동기,     돌려 줄 함수  */
			callAjax("/business/estMngList.do", "post", "text",  true, param, resultCallback); //text       
	  } 
	 	
	 	
	 	
	 	
	 	

		
		/**  견적서 모달 안 리스트  */
		function estDetailList(currentPage) {  
		
			currentPage = currentPage || 1;


			// 날짜 1
			var to_date = $("#to_date").val();
			// 날짜 2
			var from_date = $("#from_date").val();
			
	        var param = {
	        		
	             	currentPage : currentPage
	             	,pageSize : pageSizeEstList
	             	,to_date:to_date // 뷰단에 남아있는 날짜 데이터 넣어줘서 다시 조회
	             	,from_date:from_date

	        }
		     console.log(" param : " ,param);
			 console.log("param.valueOf()",  param.valueOf());
			
			 
			 //콜백
			var resultCallback = function(data,currentPage) {
				console.log("=======resultCallback========");
			
				//목록 조회 결과 
				estListDetailResult(data,currentPage);
				console.log(" 목록뿌려주기 조회결과 data ",data);
			};
			
			/*  보낼 링크 / 컨트롤러로 보낼 방식 /  받을 방식 ,데이터,, 비동기? 동기,     돌려 줄 함수  */
			callAjax("/business/estMngList.do", "post", "text",  true,param, resultCallback); //text
		 		
		}
		
		/**  견적서 모달 안 리스트  함수  */
		function estListDetailResult(data,currentPage) {
		
			console.log("목록조회 콜백함수 ",data);

			// 기존 목록 삭제
			$('#listEstManage').empty(); 
			// 신규 목록 생성
			$("#listEstManage").append(data);
			// 총 갯수 추출
			var estCnt = $("#estCnt").val();
			
			console.log("estCnt ", estCnt);
			

			
			// 네비게이션
			//	현재페이지  , 행 갯수 , 리스트사이즈 , 블록 갯수 , 목록리스트함수 
			var estManageHtml = getPaginationHtml(
					currentPage, 
					estCnt,
					pageSizeEstList ,  
					pageBlockSizeEstList,
					'estList'
					);
			
			console.log("estManageHtml  : " + estManageHtml );

			//네비게이션 비우고 다시 채우기
			$("#EstPagination").empty().append( estManageHtml );
			
			
			var EstCurrentPage = $("#EstCurrentPage").val();
			console.log("EstCurrentPage " +  EstCurrentPage);
		}
		
			// 금액 -> 한글로 변환
	      // Copyright 취생몽사(http://bemeal2.tistory.com)
	      // 소스는 자유롭게 사용가능합니다. Copyright 는 삭제하지 마세요.
	      function fn_change_hangul_money(alpadata)
	      {
	            

	    	  var alpadata = String(alpadata);
	            console.log("typeof ", typeof(alpadata));
	            var num_length = alpadata.length;

	            var betadata = betadata;
	 
	            console.log("======> alpadata ", alpadata );
	            console.log("======> betadata ", betadata );
	            console.log("======> num_length ", num_length );

	            
	            
	            if(isNaN(alpadata) == true)
	                  return;

	 

	            var han_value = "";
	            var man_count = 0;      // 만단위 0이 아닌 금액 카운트.

	 

	            for(i=0; i < alpadata.length; i++)
	            {
	            	
	            	console.log("======>alpadata " ,alpadata);
	                  // 1단위의 문자로 표시.. (0은 제외)
	                  var strTextWord = arrNumberWord[alpadata.charAt(i)];

	 

	                  // 0이 아닌경우만, 십/백/천 표시
	                  if(strTextWord != "")
	                  {
	                        man_count++;
	                        strTextWord += arrDigitWord[(num_length - (i+1)) % 4];
	                  }

	 
	                  // 만단위마다 표시 (0인경우에도 만단위는 표시한다)
	                  if(man_count != 0 && (num_length - (i+1)) % 4 == 0)
	                  {
	                        man_count = 0;
	                        strTextWord = strTextWord + arrManWord[(num_length - (i+1)) / 4];
	                  }

	                  han_value += strTextWord;
	            }

	            if(alpadata != 0)
	                  han_value = "금 " + han_value + " 원";

	            
	            // 값 넣기 
	         $("#txt_money").val( han_value);
	      }

	       
			// 견적서 승인여부 함수
	       function gfApplyYes(){
	    	   alert("승인 완료");
				
	    	  	var estm_num = $("#estm_num").val();
	    	   	var param = {
	    	   			estm_num : estm_num,
	    	   			apply_yn : "Y"
		        }
	    	   	
	    	   	var resultCallback = function(data) {
	    	   		
				};
				
	    		callAjax("/business/estApplyYesNo.do", "post", "text",  true, param, resultCallback);
	       }

</script>
 

</head>
<body>
	<form id="estForm1" action=""  method="">

	   <input type="hidden" id="EstCurrentPage" value="1">
	    <input type="hidden" name="action" id="action" value=""> 
  
		   
		   <!-- 모달 배경 -->
		   <div id="mask"></div>
		
		   <div id="wrap_area">
		
	      <h2 class="hidden">header 영역</h2>
	      <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
	
	      <h2 class="hidden">컨텐츠 영역</h2>
	      <div id="container">
	         <ul>
	            <li class="lnb">
	               <!-- lnb 영역 --> <jsp:include
	                  page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
	            </li>
	            
	            
	            <li class="contents">
	               <!-- contents -->
	               <h3 class="hidden">contents 영역</h3> <!-- content -->
	               <div class="content">
	
	                  <p class="Location">
	                     <a href="#" class="btn_set home">메인으로</a> <a href="#"
	                        class="btn_nav">영업</a> <span class="btn_nav bold"> 견적서 작성 및 조회
	                        </span> <a href=javascript:location.reload(); class="btn_set refresh">새로고침</a>
	                  </p>
	
	                  <p class="conTitle">
	                     <span>견적서 작성 및 조회</span> <span class="fr"> <a
	                        class="btnType blue" href="javascript:estModal1();" name="modal"><span>견적서등록</span></a>
	                     </span>
	                  </p>
	                  
	                  
                 <!--검색   -->
                 <br>       
			                    
		  <div style="padding: 3% 10% 3% 13%; border: 3px solid #CDECFA; margin: auto;">
			    <!-- 거래처 콤보박스 -->
			    <div style="padding: 2% 2% 0 1%; margin: auto;">
			        <b style="padding: 0 1% 0 1%;">거래처</b>
					<select id="client_search" style="width: 90px; margin-right: 50px;">
						
			        <!-- 달력 조회 -->
			        <b style="padding: 0 3% 0 5%;">날짜 </b>
			        <span><input type="date" id="from_date" style="padding: 0.5%;"> ~ <input type="date" id="to_date" style="padding: 0.5%;"></span><br>
			        
			        <!-- 조회 버튼 -->
			        <div style="text-align: right; margin-top: 10px;">
			            <a href="" class="btnType blue" id="btnSearchEst" name="btn">
			                <span>조회</span>
			            </a>
			        </div>
			    </div>
			</div>
                   <!-- 검색조건 끝 -->
							
							
							
	                <!-- 조회목록 윗칸띄우기 -->
	                  <div class="zldf" style ="padding-top: 2%;margin: auto;"> </div>

	                     <table class="col">
	                        <caption>caption</caption>
	                        <colgroup>
	                           <col width="10%">
	                           <col width="15%">
                               <col width="15%">
	                           <col width="10%">
	                           <col width="10%">
	                           <col width="10%">
	                           <col width="6%">
	                        </colgroup>
	                        
	                        
	                       <thead>
	                           <tr>
	                             <th scope="col">작성일</th>
	                              <th scope="col">거래처</th>
	                               <th scope="col">제품이름</th>
	                               <th scope="col">단가</th>
	                               <th scope="col">부가세</th>
	                              <th scope="col">공급가액</th>
	                              <th scope="col">승인여부</th>
	                           </tr>
	                        </thead>
	                        

	                        <tbody id="listEstManage"></tbody> <!--BizParnerCallBack으로 넘어감.여기는 틀만 만드는곳  -->
	                     </table>
	                  	<!-- 페이징에리어 -->
						<div class="paging_area"  id="EstPagination"></div>
	               </div> 
	               <!-- content end -->
	         </div>
					 <h3 class="hidden">풋터 영역</h3>
	                 <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
	          </div>
	
	
		   <!-- 모달팝업 ==  신규 등록 1 -->
		   <div id="layer1" class="layerPop layerType2"  style="width: 800px;">
		      <dl>
		         <dt>
		            <div id="divtitle" style="color:white">견적서 등록</div>
		         </dt>
		         <dd class="content">
		            <!-- s : 여기에 내용입력 -->
		            <table class="row">
		               <caption>caption</caption>
		               <colgroup>
		                  <col width="120px">
		                  <col width="*">
		                  <col width="120px">
		                  <col width="*">
		               </colgroup>
		
		               <tbody>
		                  <tr>
					
							 <!-- 목록조회 외에 UPDATE, INSERT , DELETE 등을 위해 필요함  hidden 값  // INT가 아닌것도 있음  -->
							 <td hidden=""><input type="text" class="inputTxt p100" name="estm_num" id="estm_num" /></td> 
		     
		                     <th scope="row">거래처 이름<span class="font_red">*</span></th>
		                     <td hidden=""><input type="hidden" id="cust_name"></td>
		                     				
							<td><!-- 거래처 콤보박스   -->
								<select id="client_search1" name="client_search1" onChange="">
								</select>	
							</td>
		                
			                  <tr>
			                     <th scope="row">대분류<span class="font_red">*</span></th>
                   				<td>
										<select id="major_class" name="major_class" onChange="">
											<option value=""></option>
										    <option value="대분류1">대분류1</option>
										    <option value="대분류2">대분류2</option>
										    <option value="대분류3">대분류3</option>
										    <option value="대분류4">대분류4</option>
										</select>
								</td>
	                             <th scope="row">소분류<span class="font_red">*</span></th>
								<td>
								<select id="sub_class" name="sub_class" onChange="">
											<option value=""></option>
										    <option value="소분류1">소분류1</option>
										    <option value="소분류2">소분류2</option>
										    <option value="소분류3">소분류3</option>
										    <option value="소분류4">소분류4</option>
										</select>
								</td>
			                  </tr>
			          
			                  <tr>
	                             <th scope="row">제품명<span class="font_red">*</span></th>
									<td>
										<select id="item_name" name="item_name" onChange="">
											<option value=""></option>
										    <option value="T550">T550</option>
										    <option value="ST550">ST550</option>
										    <option value="ST557">ST557</option>
										    <option value="ST558">ST558</option>
										    <option value="ST559">ST559</option>
										    <option value="ST560">ST560</option>
										    <option value="ST551">ST551</option>
										    <option value="ST552">ST552</option>
										    
										</select>
									</td>
									        <th scope="row">수량</th>
			                    			 <td colspan="3">
			                    			 	<input type='int' name="qut" id="qut"  style="height: 20px;"/> 개
                    			 			</td>
			                	  </tr>
			                	  
			                	  <tr>
	                             <th scope="row">유효기간<span class="font_red">*</span></th>
									<td>
										<input type="date" id="expire_date" name="expire_date" style="height: 25px; margin-right: 10px;"/>
									</td>
									
									<th scope="row">수주일자<span class="font_red">*</span></th>
									<td>
										<input type="date" id="book_date" name="book_date" style="height: 25px; margin-right: 10px;"/>
										    
									</td>
			                	  </tr>
			                	  
			                	 

			               </tbody>
			            </table>
			            <div class="btn_areaC mt30">
			            	<td hidden=""><input type="hidden" id="estm_num"></td>
			               <a href="" class="btnType blue" id="btnUpdateEst" name="btn"><span>등록</span></a>
			               <a href=""   class="btnType gray"  id="btnCloseEst" name="btn"><span>취소</span></a>
			            </div>
			         </dd>
			      </dl>
			      <a href="" class="closePop"><span class="hidden">닫기</span></a>
			   </div>
			   <!-- 모달1 끝 -->
			   
			   
			
		   
	</form>	   
   <jsp:include page="/WEB-INF/view/business/estMngModal.jsp"></jsp:include>


   </body>
</html>