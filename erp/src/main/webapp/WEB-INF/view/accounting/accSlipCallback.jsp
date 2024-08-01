<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

							<c:if test="${totalAccSlipCnt eq 0 }">
								<tr>
									<td colspan="7">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							<c:set var="nRow" value="${pageSize*(currentPageAccSlip-1)}" />
							<c:forEach items="${listAccSlipModel}" var="list">
									<tr>
										<td>${accSlipCnt + nRow +1}</td> 
										<td>${list.acct_num}</td>
										<td>${list.book_date}</td>
										<td>${list.acct_code}</td>
										<td>${list.cust_name}</td>
										<td><fmt:formatNumber value="${list.amount}" /> 원</td>
										<td>${list.applyer}</td>
									</tr>
								<c:set var="nRow" value="${nRow + 1}" />
							</c:forEach>
							<input type="hidden" id="totalAccSlipCnt" name="totalAccSlipCnt" value="${totalAccSlipCnt}"/>