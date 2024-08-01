package kr.happyjob.study.accounting.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.accounting.model.UnpaidDetailItemModel;
import kr.happyjob.study.accounting.model.UnpaidDetailModel;
import kr.happyjob.study.accounting.model.UnpaidModel;
import kr.happyjob.study.accounting.service.UnpaidService;

@Controller
@RequestMapping("/accounting")
public class UnpaidController {

	private final Logger logger = LogManager.getLogger(this.getClass());

	@Autowired
	private UnpaidService service;

	@RequestMapping("/unpaid.do")
	public String main() throws Exception {
		logger.info("unpaid.do");

		return "accounting/unpaid";
	}

	@RequestMapping("/searchUnpaid.do")
	public String searchUnpaid(Model model, @RequestParam Map<String, Object> paramMap) throws Exception {
		logger.info("searchUnpaid.do");
		logger.info("   - paramMap : " + paramMap);

		int currentPage = Integer.valueOf((String) paramMap.get("currentPage"));
		int pageSize = Integer.valueOf((String) paramMap.get("pageSize"));

		paramMap.put("startSeq", (currentPage - 1) * pageSize);
		paramMap.put("pageSize", pageSize);

		List<UnpaidModel> list = service.search(paramMap);
		int totalCount = service.searchTotalCount(paramMap);

		model.addAttribute("list", list);
		model.addAttribute("totalCount", totalCount);

		return "accounting/unpaidList";
	}

	@RequestMapping("/unpaidDetail.do")
	public String unpaidDetail(Model model, @RequestParam Map<String, Object> paramMap) throws Exception {
		logger.info("unpaidDetail.do");
		logger.info("   - paramMap : " + paramMap);

		String type = (String) paramMap.get("type");

		UnpaidDetailModel detail = null;
		List<UnpaidDetailItemModel> items = null;

		if ("estm".equals(type)) {
			detail = service.searchEstmDetail(paramMap);
			items = service.searchEstmDetailItems(paramMap);
		} else {
			detail = service.searchObtainDetail(paramMap);
			items = service.searchObtainDetailItems(paramMap);
		}

		model.addAttribute("type", type);
		model.addAttribute("detail", detail);
		model.addAttribute("items", items);

		return "accounting/unpaidDetail";
	}

	@RequestMapping("/depositUnpaid.do")
	@ResponseBody
	public Map<String, String> depositUnpaid(@RequestParam Map<String, Object> paramMap, HttpSession session)
			throws Exception {
		logger.info("depositUnpaid.do");
		logger.info("   - paramMap : " + paramMap);

		Map<String, String> result = new HashMap<>();
		boolean success = false;

		if ("C".equals((String) session.getAttribute("userType"))) {
			int depositResult = service.depositUnpaid(paramMap);

			success = depositResult > 0;
		}

		result.put("result", success ? "success" : "fail");

		return result;
	}
}
