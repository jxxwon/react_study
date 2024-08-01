<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<title> 공지사항  </title>

<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">
var pageSize = 5;
var blockPage = 10;

$(function() {
	noticeSearch();
	registerBtnEvent();
	filePreview();
});

function registerBtnEvent() {
	$("#searchBtn").click(function(e) {
		e.preventDefault();
		
		noticeSearch();
	});
	
	$("a[name=btn]").click(function(e) {
		e.preventDefault();
		
		var btnId = $(this).attr("id");

		switch(btnId) {
		case "btnSaveNotice":
			saveNotice();
			break;
		case "btnUpdateNotice":
			updateNotice();
			break;
		case "btnDeleteNotice":
			deleteNotice();
			break;
		case "btnSavefile":
			saveFileNotice();
			break;
		case "btnUpdatefile":
			updateFileNotice();
			break;
		case "btnDeletefile":
			deleteFileNotice();
			break;
		case "btnClose":
			break;
		}
	});
}

function noticeSearch(cpage) {
	cpage = cpage || 1;
	
	var param = {
		searchTitle: $("#searchTitle").val(),
		searchStDate: $("#searchStDate").val(),
		searchEdDate: $("#searchEdDate").val(),
		cpage: cpage,
		pageSize: pageSize
	};
	
	var callback = function(res) {
		$("#noticeList").html(res);
		
		var pageNavigateHtml = getPaginationHtml(cpage, $("#totcnt").val(), pageSize, blockPage, "noticeSearch");
		$("#pagingNavi").html(pageNavigateHtml);
		$("#currentPage").val(cpage);
	}
	
	callAjax("/system/noticeList.do", "post", "text", false, param, callback);
}

function insertModal() {
	$("#loginId").val("");
	$("#noticeTitle").val("");
	$("#noticeContent").val("");
	$("#noticeSeq").val("");
	$("#btnUpdateNotice").hide();
	$("#btnDeleteNotice").hide();
	$("#btnSaveNotice").show();
	
	gfModalPop("#noticeInsertModal");
}

function noticeDetailModal(seq) {
	var param = {
		noticeSeq: seq
	}
	
	var callback = function(data) {
		var detail = data.detailValue;
		
		$("#loginId").val(detail.loginID);
		$("#noticeTitle").val(detail.noti_title);
		$("#noticeContent").val(detail.noti_content);
		$("#noticeSeq").val(seq);
		$("#btnUpdateNotice").show();
		$("#btnDeleteNotice").show();
		$("#btnSaveNotice").hide();
		
		gfModalPop("#noticeInsertModal");
	}
	
	callAjax("/system/noticeDetail.do", "post", "json", false, param, callback);
}

function saveNotice() {
	if (!fValidate()) {
		return;
	}
	
	var param = { 
		title: $("#noticeTitle").val(),
		content: $("#noticeContent").val(),
		noticeSeq: $("#noticeSeq").val()
	};
	
	var callback = function(res) {
		if (res.result === "Success") {
			alert("저장되었습니다.");
			gfCloseModal();
			noticeSearch();
		}
	}
	
	callAjax("/system/noticeSave.do", "post", "json", false, param, callback);
}

function updateNotice() {
	if (!fValidate()) {
		return;
	}
	
	var param = { 
		title: $("#noticeTitle").val(),
		content: $("#noticeContent").val(),
		noticeSeq: $("#noticeSeq").val()
	};
	
	var callback = function(res) {
		if (res.result === "Success") {
			alert("수정되었습니다.");
			gfCloseModal();
			noticeSearch($("#currentPage").val());
		}
	}
	
	callAjax("/system/noticeUpdate.do", "post", "json", false, param, callback);
}

function deleteNotice() {
	var param = {
		noticeSeq: $("#noticeSeq").val()
	}
	
	var callback = function(data) {
		alert("삭제되었습니다.");
		gfCloseModal();
		noticeSearch($("#currentPage").val());
	}
	
	callAjax("/system/noticeDelete.do", "post", "json", false, param, callback);
}

function fValidate() {
    var chk = checkNotEmpty(
		[
			[ "noticeTitle", "제목를 입력해 주세요." ],
            [ "noticeContent", "내용을 입력해 주세요" ]
		]
    );
    
    if (!chk) {
       return;
    }

    return true;
}

function fValidatefile() {
    var chk = checkNotEmpty(
    	[
        	[ "fileTitle", "제목를 입력해 주세요." ],  
            [ "fileContent", "내용을 입력해 주세요" ]
    	]
    );
	
    if (!chk) {
		return;
	}

	return true;
}
 
function insertFileModal() {
	$("#fileInput").val("");
	$("#fileTitle").val("");
	$("#fileContent").val("");
	$("#noticeSeq").val("");
	$("#preview").empty();
	$("#btnUpdatefile").hide();
	$("#btnDeletefile").hide();
	$("#btnSavefile").show();
	gfModalPop("#filePopUp");
}
 
function filePreview() {
	$("#fileInput").change(function(e) {
		e.preventDefault();
		
		if ($(this)[0].files[0]) {
			var fileInfo = $("#fileInput").val();
			var fileInfoSplit = fileInfo.split(".");
			var fileLowerCase = fileInfoSplit[1].toLowerCase();
			
			var imgPath = "";
			var previewHtml = "";
			
			if (fileLowerCase === "jpg" || fileLowerCase === "gif" || fileLowerCase === "png") {
				imgPath = window.URL.createObjectURL($(this)[0].files[0]);
				
				previewHtml = "<img src='" + imgPath + "' id='imgFile' style='width: 100px; height: 100px;' />";
			}
			
			$("#preview").html(previewHtml);
		}
	});
}

function saveFileNotice() {
	if (!fValidatefile()) {
		return;
	}
	
	var getForm = document.getElementById("noticeForm");
	getForm.entype = 'multipart/form-data';
	
	var fileData = new FormData(getForm);
	
	var callback = function(res) {
		if (res.result === "Success") {
			alert("저장되었습니다.");
			gfCloseModal();
			noticeSearch();
		}
	}
	
	callAjaxFileUploadSetFormData("/system/noticeSaveFile.do", "post", "json", false, fileData, callback)
}

function noticeDetailFileModal(seq) {
	console.log(seq)
	var param = {
		noticeSeq: seq
	}
	
	var callback = function(data) {
		$("#noticeSeq").val(seq);
		detailModalSetting(data.detailValue);
		
		gfModalPop("#filePopUp");
	}
	
	callAjax("/system/noticeDetail.do", "post", "json", false, param, callback);
}

function detailModalSetting(detail) {
	if (detail) {
		$("#fileTitle").val(detail.noti_title);
		$("#fileContent").val(detail.noti_content);
		$("#btnUpdatefile").show();
		$("#btnDeletefile").show();
		$("#btnSavefile").hide();
		
		if (detail.file_name) {
			var ext = detail.file_ext.toLowerCase();
			var imgPath = "";
			var previewHtml = "<a href='javascript:download()'>";
			
			if (ext === "jpg" || ext === "gif" || ext === "png") {
				imgPath = detail.logical_path;
				previewHtml += "<img src='" + imgPath + "' id='imgFile' style='width: 100px; height: 100px;' />";
			} else {
				previewHtml += detail.filename;
			}
			
			previewHtml += "</a>";
			
			$("#preview").html(previewHtml);
		}
	}
}

function updateFileNotice() {
	if (!fValidatefile()) {
		return;
	}
	
	var getForm = document.getElementById("noticeForm");
	getForm.entype = 'multipart/form-data';
	
	var fileData = new FormData(getForm);
	
	var callback = function(res) {
		if (res.result === "Success") {
			alert("수정되었습니다.");
			gfCloseModal();
			noticeSearch($("#currentPage").val());
		}
	}
	
	callAjaxFileUploadSetFormData("/system/noticeUpdateFile.do", "post", "json", false, fileData, callback)
}

function deleteFileNotice() {
	var param = {
		noticeSeq: $("#noticeSeq").val()
	}
	
	var callback = function(data) {
		alert("삭제되었습니다.");
		gfCloseModal();
		noticeSearch($("#currentPage").val());
	}
	
	callAjax("/system/noticeDelete.do", "post", "json", false, param, callback);
}

function download() {
	var noticeSeq = $("#noticeSeq").val();
	
	var params = "<input type='hidden' name='noticeSeq' value='"+ noticeSeq +"' />";
	
	$("<form action='noticeDownload.do' method='post' id='fileDownload'>" + params + "</form>"
    ).appendTo('body').submit().remove();
}
</script>
</head>
<body>
	<input type="hidden" id="currentPage" value="1">
	<input type="hidden" name="action" id="action" value=""> 

	<div id="wrap_area">
		<h2 class="hidden">header 영역</h2> 
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> 
					<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">
						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a> 
							<a href="#" class="btn_nav bold">시스템 관리</a> 
							<span class="btn_nav bold">공지 사항</span> 
							<a href="#" class="btn_set refresh">새로고침</a>
						</p>
						
					<p class="conTitle">
						<span>공지사항</span> 
						<span class="fr">					
 	                         	 제목
                          <input type="text" id="searchTitle" name="searchTitle" style="height: 25px; margin-right: 10px;"/>
                          	기간
                          <input type="date" id="searchStDate" name="searchStDate" style="height: 25px; margin-right: 10px;"/> 
                          ~ 
                          <input type="date" id="searchEdDate" name="searchEdDate" style="height: 25px; margin-right: 10px;"/>
						  <a class="btnType red" href="" name="searchbtn"  id="searchBtn"><span>검색</span></a>
						  <a class="btnType blue" href="javascript:insertModal();" name="modal"><span>신규</span></a>
						  <a class="btnType blue" href="javascript:insertFileModal();" name="modal"><span>신규(파일)</span></a>
						</span>
					</p> 
						
						
						<div class="divNoticeList">
							<table class="col">
								<caption>caption</caption>
		                            <colgroup>
						                   <col width="50px">
						                   <col width="200px">
						                    <col width="60px">
						                   <col width="50px">
					                 </colgroup>
								<thead>
									<tr>
							              <th scope="col">공지 번호</th>
							              <th scope="col">공지 제목</th>
							              <th scope="col">공지 날짜</th>
							              <th scope="col">작성자</th>
							              
									</tr>
								</thead>
								<tbody id="noticeList"></tbody>
							</table>
							
							<!-- 페이징 처리  -->
							<div class="paging_area" id="pagingNavi">
							</div>
											
						</div>

		
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>


	<!-- 모달팝업 -->
	<div id="noticeInsertModal" class="layerPop layerType2" style="width: 600px;"> 
		<dl>
			<dt>
				<strong>공지사항</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>

					<tbody>
						<tr>
							<th scope="row">작성자 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="loginId" id="loginId" disabled /></td>
							<!-- <th scope="row">작성일<span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="write_date" id="write_date" /></td> -->
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="noticeTitle" id="noticeTitle" /></td>
						</tr>
						<tr>
							<th scope="row">내용</th>
							<td colspan="3">
								<textarea class="inputTxt p100" name="noticeContent" id="noticeContent">
								</textarea>
							</td>
						</tr>
						
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveNotice" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnUpdateNotice" name="btn" style="display:none"><span>수정</span></a> 
					<a href="" class="btnType blue" id="btnDeleteNotice" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>

		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

<form id="noticeForm" action="" method="">
      <input type="hidden" id="noticeSeq" name="noticeSeq">
      <!-- 수정시 필요한 num 값을 넘김  -->
      <div id="filePopUp" class="layerPop layerType2" style="width: 600px;">
         <dl>
            <dt>
               <strong>공지사항 관리(파일)</strong>
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
                        <th scope="row">제목 <span class="font_red">*</span></th>
                        <td colspan=3><input type="text" class="inputTxt p100"
                           name="fileTitle" id="fileTitle" /></td>
                     </tr>
                     <tr>
                        <th scope="row">내용 <span class="font_red">*</span></th>
                        <td colspan="3"><textarea name="fileContent"
                              id="fileContent" cols="40" rows="5"> </textarea></td>
                     </tr>
                     <tr>
                        <th scope="row">파일</th>
                        <td colspan="3"><input type="file" class="inputTxt p100"
                           name="fileInput" id="fileInput" /></td>
                     </tr>
                     <tr>
                        <th scope="row">미리보기</th>
                        <td>
                           <div id="preview"></div>
                        </td>
                     </tr>
                  </tbody>
               </table>

               <!-- e : 여기에 내용입력 -->

               <div class="btn_areaC mt30">
                  <a href="" class="btnType blue" id="btnSavefile" name="btn"><span>저장</span></a>
                  <a href="" class="btnType blue" id="btnUpdatefile" name="btn"><span>수정</span></a>
                  <a href="" class="btnType blue" id="btnDeletefile" name="btn"><span>삭제</span></a>
                  <a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
               </div>
            </dd>
         </dl>
         <a href="" class="closePop"><span class="hidden">닫기</span></a>
      </div>
   </form>
</body>
</html>
