<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<!-- 갯수가 0인 경우  -->
		<c:if test="${vctnApproveCnt eq 0 }">
			<tr>
				<td colspan="10">조회된 휴가가 없습니다.</td>
			</tr>
		</c:if>
		

		<!-- 갯수가 있는 경우  -->
		<c:if test="${vctnApproveCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" /> 
			<c:forEach items="${vctnApproveList}" var="list">
				<tr>
					<td><a href = "javascript:vctnApproveDetailModal('${list.seq}');">${nRow+1}</a></td>
					<td>${list.loginId}</td>
					<td>${list.name}</td>
					<td>${list.vctnName}</td>
					<td>${list.vctnStrDate}</td>
					<td>${list.vctnEndDate}</td>
					<td>${list.applyDate}</td>
					<td>${list.applyer}</td>
					<td>
						<c:if test = "${list.applyYn == 'W'}">미승인</c:if>
						<c:if test = "${list.applyYn == 'Y'}">승인</c:if>
						<c:if test = "${list.applyYn == 'N'}">반려</c:if>
					</td>
				</tr>
				 <c:set var="nRow" value="${nRow + 1}" /> 
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="totcnt" name="totcnt" value="${vctnApproveCnt}">
		<!-- 이거 중간에 있으면 table 안먹힘  -->
