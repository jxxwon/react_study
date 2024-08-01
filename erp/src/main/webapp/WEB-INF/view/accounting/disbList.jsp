<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 지출결의서 신청 목록이 없는 경우  -->
<c:if test="${empty disbList}">
	<tr>
		<td colspan="8">데이터가 존재하지 않습니다.</td>
	</tr>
</c:if>


<!-- 지출결의서 신청 목록이 있는 경우  -->
<c:if test="${not empty disbList}">
	<c:set var="nRow" value="${pageSize*(currentPage-1)}" />
	<c:forEach items="${disbList}" var="disb">
		<tr>
			<td><a href="javascript:disbDetailModal(${disb.resoNum});">${disb.resoNum}</a></td>
			<td><fmt:formatDate value="${disb.applyDate}" pattern="yyyy-MM-dd" /></td>
			<td><fmt:formatDate value="${disb.useDate}" pattern="yyyy-MM-dd" /></td>
			<!-- 계정대분류명 -->
			<td>${disb.grCodeNm}</td>
			<!-- 계정과목 -->
			<td>${disb.acctCodeNm}</td>
			<!-- 사용부서 -->
			<td>${disb.applyDept}</td>
			<td><fmt:formatNumber value="${disb.amount}" pattern="#,###" /> 원</td>
			<td>			
			<c:choose>
			      <c:when test="${disb.apprYn eq 'Y'}">
			      		승인
			      </c:when> 
			      <c:when test="${disb.apprYn eq 'N'}">
			      		반려
			      </c:when> 
			      <c:otherwise>
			      		승인대기
			      </c:otherwise> 
			</c:choose> 
			</td>
		</tr>
		<c:set var="nRow" value="${nRow + 1}" />
	</c:forEach>
</c:if>

<!-- 이거 중간에 있으면 table 안먹힘  -->
<input type="hidden" id="totcnt" name="totalCnt" value="${disbCnt}" />