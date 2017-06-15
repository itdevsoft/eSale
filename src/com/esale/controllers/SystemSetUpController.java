package com.esale.controllers;

import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.multipart.MultipartFile;

import com.eservice.core.beans.NestedCategory;
import com.eservice.core.beans.NestedCategorySaleItem;
import com.eservice.core.beans.SaleItem;
import com.eservice.core.services.SystemSetUpService;

@Controller
@RequestMapping(value = "/system")
public class SystemSetUpController
{

	@Autowired
	SystemSetUpService springSystemSetUpService;

	@Autowired
	SystemSetUpService hibernateSystemSetUpService;

	Map<Long, String> systemHierarchySetupList;

	Map<String, String> priceForList;

	List<String> searchByList;

	@Value("${acceptedImageFiles}")
	private String acceptedImageFiles;

	@Value("${maxUploadSize}")
	private int maxUploadSize;

	@Value("${saleItemImagePath}")
	private String imagePath;

	public String getAcceptedImageFiles()
	{
		return acceptedImageFiles;
	}

	public void setAcceptedImageFiles(String acceptedImageFiles)
	{
		this.acceptedImageFiles = acceptedImageFiles;
	}

	public int getMaxUploadSize()
	{
		return maxUploadSize;
	}

	public void setMaxUploadSize(int maxUploadSize)
	{
		this.maxUploadSize = maxUploadSize;
	}

	public void setImagePath(String imagePath)
	{
		this.imagePath = imagePath;
	}

	public String getImagePath()
	{
		return imagePath;
	}

	public SystemSetUpService getSpringSystemSetUpService()
	{
		return springSystemSetUpService;
	}

	public void setSpringSystemSetUpService(SystemSetUpService springSystemSetUpService)
	{
		this.springSystemSetUpService = springSystemSetUpService;
	}

	public SystemSetUpService getHibernateSystemSetUpService()
	{
		return hibernateSystemSetUpService;
	}

	public void setHibernateSystemSetUpService(SystemSetUpService hibernateSystemSetUpService)
	{
		this.hibernateSystemSetUpService = hibernateSystemSetUpService;
	}

	@RequestMapping(value = "setupSaleItem")
	public ModelMap setupSaleItem()
	{
		System.out.println("setupSaleItem");
		ModelMap model = new ModelMap();
		SaleItem saleItem = (SaleItem) ContextLoader.getCurrentWebApplicationContext().getBean("SaleItem");
		model.addAttribute("saleItem", saleItem);
		model.addAttribute("heading", "Add New Sale Item");
		model.addAttribute("buttonLabel", "Save");
		model.addAttribute("action", "saveSaleItem");
		return model;
	}

	@RequestMapping(value = "saveSaleItem", method = RequestMethod.POST)
	public String saveSaleItem(SaleItem saleItem, ModelMap model)
	{
		System.out.println("saveSaleItem");

		model.addAttribute("heading", "Add New Sale Item");
		model.addAttribute("buttonLabel", "Save");
		model.addAttribute("action", "saveSaleItem");
		try
		{
			// validate the uploaded file
			if (validateData(saleItem.getFileData(), saleItem.getId(), model))
			{
				int pos = saleItem.getFileData().getOriginalFilename().lastIndexOf('.');
				String ext = saleItem.getFileData().getOriginalFilename().substring(pos + 1);
				// update the database
				saleItem.setImagePath(getImagePath().concat("<id>." + ext));
				Map resultMap = getHibernateSystemSetUpService().addSaleItem(saleItem);
				model.addAttribute("message", resultMap.get("message"));
				model.addAttribute("success", resultMap.get("success"));
				if (resultMap != null && resultMap.containsKey("saleItem"))
					model.addAttribute("saleItem", (SaleItem) resultMap.get("saleItem"));
				if ((Boolean) resultMap.get("success"))
				{
					model.addAttribute("heading", "Update Sale Item");
					model.addAttribute("buttonLabel", "Update");
					model.addAttribute("action", "updateSaleItem");
					saleItem.setId(Long.parseLong(String.valueOf(resultMap.get("id"))));
					// upload file
					if (saleItem.getFileData().getSize() > 0)
						uploadFile(saleItem.getFileData(), String.valueOf(saleItem.getId()), model, ext);

				}

			}
		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
			ex.printStackTrace();
		}
		return "/system/setupSaleItem";
	}

	@RequestMapping(value = "editSaleItem/{itemId}")
	public String editSaleItem(ModelMap model, @PathVariable("itemId") long itemId)
	{
		System.out.println("editSaleItem-->itemId=" + itemId);
		try
		{
			SaleItem saleItem = getHibernateSystemSetUpService().getSaleItem(itemId);
			model.addAttribute("saleItem", saleItem);
			model.addAttribute("heading", "Update Sale Item");
			model.addAttribute("buttonLabel", "Update");
			model.addAttribute("action", "/eSale/system/updateSaleItem");
		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
			ex.printStackTrace();
		}
		return "/system/setupSaleItem";
	}

	@RequestMapping(value = "updateSaleItem", method = RequestMethod.POST)
	public String updateSaleItem(SaleItem saleItem, ModelMap model)
	{
		System.out.println("updateSaleItem");

		model.addAttribute("heading", "Update Sale Item");
		model.addAttribute("buttonLabel", "Update");
		model.addAttribute("action", "updateSaleItem");
		try
		{
			if (validateData(saleItem.getFileData(), saleItem.getId(), model))
			{
				Map resultMap = getHibernateSystemSetUpService().updateSaleItem(saleItem);
				model.addAttribute("message", resultMap.get("message"));
				model.addAttribute("success", resultMap.get("success"));

				// upload file
				if (saleItem.getFileData().getSize() > 0)
				{
					int pos = saleItem.getFileData().getOriginalFilename().lastIndexOf('.');
					String ext = saleItem.getFileData().getOriginalFilename().substring(pos + 1);
					uploadFile(saleItem.getFileData(), String.valueOf(saleItem.getId()), model, ext);
				}
			}
		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
			ex.printStackTrace();
		}
		return "/system/setupSaleItem";
	}

	@RequestMapping(value = "searchSaleItems")
	public String searchSaleItems(ModelMap model, @RequestParam("searchBy") String searchBy, @RequestParam("keyword") String keyword)
	{
		System.out.println("searchSaleItems----->searchBy=" + searchBy + "--->keyword=" + keyword);
		SaleItem saleItem = (SaleItem) ContextLoader.getCurrentWebApplicationContext().getBean("SaleItem");
		model.addAttribute("saleItem", saleItem);
		model.addAttribute("heading", "Add New Sale Item");
		model.addAttribute("buttonLabel", "Save");
		model.addAttribute("action", "saveSaleItem");
		model.addAttribute("operation", "search");
		model.addAttribute("searchBy", searchBy);
		model.addAttribute("keyword", keyword);

		String criteria = "from SaleItem s where Lower(s." + searchBy.toLowerCase() + ") like ?";
		Object[] criteriaValues =
		{ "%" + keyword.toLowerCase() + "%" };
		try
		{
			List<SaleItem> saleItems = getHibernateSystemSetUpService().getSaleItems(criteria, criteriaValues);
			System.out.println("saleItems====>" + saleItems.size());
			model.addAttribute("success", true);
			if (saleItems == null || saleItems.size() == 0)
			{
				model.addAttribute("message", "No Sale Items found.");
			} else
			{
				model.addAttribute("message", saleItems.size() + " Items found.");
			}
			model.addAttribute("searchItems", saleItems);
		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
			ex.printStackTrace();
		}

		return "/system/setupSaleItem";
	}

	@RequestMapping(value = "initSystemHierarchySetup")
	public String initSystemHierarchySetup(ModelMap model)
	{
		System.out.println("initSystemHierarchySetup");

		model.addAttribute("heading", "Setup System Hierarchy");
		model.addAttribute("operation", "setupSystemHierarchy");
		return "/system/initSystemHierarchySetup";
	}

	@RequestMapping(value = "setupSystemHierarchy/{categoryId}")
	public String setupSystemHierarchy(ModelMap model, @PathVariable("categoryId") long categoryId, @RequestParam("type") String categoryType)
	{

		System.out.println("setupSystemHierarchy ----->categoryId=" + categoryId + "--->categoryType=" + categoryType);
		try
		{
			List<NestedCategory> imediateCaregoryList = getSpringSystemSetUpService().getImediateCaregoryList(categoryId);
			List<NestedCategory> bredcrumbList = getSpringSystemSetUpService().getSinglePathCaregoryList(categoryId);

			System.out.println("setupSystemHierarchy ----->imediateCaregoryList=" + imediateCaregoryList.size() + "--->bredcrumbList=" + bredcrumbList.size());

			NestedCategory nestedCategory = (NestedCategory) ContextLoader.getCurrentWebApplicationContext().getBean("NestedCategory");
			nestedCategory.setParentId(categoryId);
			nestedCategory.setType(categoryType);

			model.addAttribute("nestedCategory", nestedCategory);
			model.addAttribute("bredcrumbList", bredcrumbList);
			model.addAttribute("imediateCaregoryList", imediateCaregoryList);
			model.addAttribute("parentCaregory", bredcrumbList.get(bredcrumbList.size() - 1));

		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
		}
		return "/system/setupSystemHierarchy";
	}

	@RequestMapping(value = "setupSystemHierarchy/add", method = RequestMethod.POST)
	public String addSystemHierarchyCategory(NestedCategory nestedCategory, ModelMap model)
	{
		System.out.println("addSystemHierarchyCategory:nested CategoryId:" + nestedCategory.getId() + "--:name:" + nestedCategory.getCategory().getName() + "--:ParentId:"
				+ nestedCategory.getParentId() + "--:Type:" + nestedCategory.getType());
		try
		{
			String ext = "";
			if (nestedCategory.getCategory().getFileData().getSize() > 0 && validateData(nestedCategory.getCategory().getFileData(), nestedCategory.getCategory().getId(), model))
			{
				int pos = nestedCategory.getCategory().getFileData().getOriginalFilename().lastIndexOf('.');
				ext = nestedCategory.getCategory().getFileData().getOriginalFilename().substring(pos + 1);
				nestedCategory.getCategory().setImagePath(getImagePath().concat("Category_<id>." + ext));
			}
			// update the database
			long id = getSpringSystemSetUpService().addNestedCaregory(nestedCategory);
			if (id > 0)
			{
				model.addAttribute("success", true);
				model.addAttribute("message", "Successfully Added");
				NestedCategory nestedCategoryObj = getHibernateSystemSetUpService().getNestedCategory(id);
				nestedCategory.setId(id);
				nestedCategory.getCategory().setId(nestedCategoryObj.getCategory().getId());
				// upload file
				if (nestedCategory.getCategory().getFileData().getSize() > 0)
					uploadFile(nestedCategory.getCategory().getFileData(), "Category_" + nestedCategory.getCategory().getId(), model, ext);
			} else
			{
				model.addAttribute("success", false);
				model.addAttribute("message", "Couldn't Add. Please try again.");
			}

		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage());
			model.addAttribute("success", false);
		}
		model.addAttribute("heading", "Setup System Hierarchy");
		return setupSystemHierarchy(model, nestedCategory.getParentId(), nestedCategory.getType());
	}

	@RequestMapping(value = "setupSystemHierarchy/edit", method = RequestMethod.POST)
	public String editSystemHierarchyCategory(NestedCategory nestedCategory, ModelMap model)
	{
		System.out.println("editSystemHierarchyCategory:" + nestedCategory.getId() + "--:name:" + nestedCategory.getCategory().getName() + "--:ParentId:"
				+ nestedCategory.getParentId() + "--:CategoryId:" + nestedCategory.getCategory().getId());
		String ext = "";
		if (nestedCategory.getCategory().getFileData().getSize() > 0 && validateData(nestedCategory.getCategory().getFileData(), nestedCategory.getCategory().getId(), model))
		{
			int pos = nestedCategory.getCategory().getFileData().getOriginalFilename().lastIndexOf('.');
			ext = nestedCategory.getCategory().getFileData().getOriginalFilename().substring(pos + 1);
			nestedCategory.getCategory().setImagePath(getImagePath().concat("Category_<id>." + ext));
		}
		Map resultMap = getHibernateSystemSetUpService().updateCategory(nestedCategory.getCategory());
		model.addAttribute("message", resultMap.get("message"));
		model.addAttribute("success", resultMap.get("success"));
		model.addAttribute("heading", "Setup System Hierarchy");
		// upload file
		if (nestedCategory.getCategory().getFileData().getSize() > 0)
		{
			uploadFile(nestedCategory.getCategory().getFileData(), "Category_" + nestedCategory.getCategory().getId(), model, ext);
		}

		return setupSystemHierarchy(model, nestedCategory.getParentId(), nestedCategory.getType());
	}

	@RequestMapping(value = "setupSystemHierarchy/assignInit", method = RequestMethod.POST)
	public String initAssignItemsToSystemHierarchyCategory(NestedCategory nestedCategory, ModelMap model)
	{
		System.out.println("initAssignItemsToSystemHierarchyCategory:" + nestedCategory.getId() + "----:ParentId:" + nestedCategory.getParentId() + "--:CategoryId:"
				+ nestedCategory.getCategory().getId());
		try
		{
			String criteria = "select distinct s from SaleItem s left outer join s.nestedCategorySet as nc with nc.id=? where s.enabled=? order by s.id";
			Object[] criteriaValues =
			{ nestedCategory.getParentId(), true };

			List<SaleItem> saleItemList = getHibernateSystemSetUpService().getSaleItems(criteria, criteriaValues);
			System.out.println("saleItemList====>" + saleItemList.size());
			model.addAttribute("success", true);

			if (saleItemList == null || saleItemList.size() == 0)
			{
				model.addAttribute("message", "Sale Items not found. Please add Sale Items before assign");
			}
			for (SaleItem saleItem : saleItemList)
			{
				saleItem.setAssigned(isItemAssigned(nestedCategory.getParentId(), saleItem.getNestedCategorySet()));
			}
			nestedCategory.setSaleItems(saleItemList);
			model.addAttribute("nestedCategory", nestedCategory);

			List<NestedCategory> imediateCaregoryList = getSpringSystemSetUpService().getImediateCaregoryList(nestedCategory.getParentId());
			List<NestedCategory> bredcrumbList = getSpringSystemSetUpService().getSinglePathCaregoryList(nestedCategory.getParentId());
			model.addAttribute("bredcrumbList", bredcrumbList);
			model.addAttribute("imediateCaregoryList", imediateCaregoryList);
			model.addAttribute("parentCaregory", bredcrumbList.get(bredcrumbList.size() - 1));
		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
			ex.printStackTrace();
		}
		model.addAttribute("heading", "Setup System Hierarchy - Assign Items to Category");
		return "/system/setupSystemHierarchy";
	}

	@RequestMapping(value = "setupSystemHierarchy/assignItems", method = RequestMethod.POST)
	public String saveAssignItemsToSystemHierarchyCategory(NestedCategory nestedCategory, ModelMap model)
	{
		System.out.println("saveAssignItemsToSystemHierarchyCategory:" + nestedCategory.getId() + "----:ParentId:" + nestedCategory.getParentId()
				+ "--:nestedCategory.getSaleItems().size():" + nestedCategory.getSaleItems().size());
		try
		{
			if (getHibernateSystemSetUpService().assignSaleItemsToNestedCategory(nestedCategory, nestedCategory.getSaleItems()))
			{
				model.addAttribute("message", "Successfully Assigned.");
				model.addAttribute("success", true);

				nestedCategory.setSaleItems(nestedCategory.getSaleItems());
				model.addAttribute("nestedCategory", nestedCategory);

				List<NestedCategory> imediateCaregoryList = getSpringSystemSetUpService().getImediateCaregoryList(nestedCategory.getParentId());
				List<NestedCategory> bredcrumbList = getSpringSystemSetUpService().getSinglePathCaregoryList(nestedCategory.getParentId());
				model.addAttribute("bredcrumbList", bredcrumbList);
				model.addAttribute("imediateCaregoryList", imediateCaregoryList);
				model.addAttribute("parentCaregory", bredcrumbList.get(bredcrumbList.size() - 1));
			} else
			{
				model.addAttribute("message", "Operation failed. Please try again.");
				model.addAttribute("success", false);
			}
		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage());
			model.addAttribute("success", false);
			ex.printStackTrace();
		}
		model.addAttribute("heading", "Setup System Hierarchy - Assign Items to Category");
		return "/system/setupSystemHierarchy";
	}

	@RequestMapping(value = "setupSystemHierarchy/delete", method = RequestMethod.POST)
	public String deleteSystemHierarchyCategory(NestedCategory nestedCategory, ModelMap model)
	{
		System.out.println("deleteSystemHierarchyCategory:categoryId:" + nestedCategory.getId() + "--:ParentId:" + nestedCategory.getParentId() + "--:Type:"
				+ nestedCategory.getType());
		try
		{
			if (getSpringSystemSetUpService().deleteNestedCaregory(nestedCategory.getId() > 0 ? nestedCategory.getId() : nestedCategory.getParentId(), nestedCategory.getType()))
			{
				model.addAttribute("success", true);
				model.addAttribute("message", "Successfully Deleted");
			} else
			{
				model.addAttribute("success", false);
				model.addAttribute("message", "Couldn't Delete. Please try again.");
			}
		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage());
			model.addAttribute("success", false);
		}
		model.addAttribute("heading", "Setup System Hierarchy");
		return setupSystemHierarchy(model, nestedCategory.getId() > 0 ? nestedCategory.getParentId() : 1, nestedCategory.getType());
	}

	@RequestMapping(value = "initSetupSystemHierarchySaleItems")
	public String initSetupSystemHierarchySaleItems(ModelMap model)
	{
		model.addAttribute("heading", "Setup System Hierarchy Sale Items");
		model.addAttribute("operation", "setupSystemHierarchySaleItems/init");
		return "/system/initSystemHierarchySetup";
	}

	@RequestMapping(value = "setupSystemHierarchySaleItems/init/{categoryId}")
	public String initSystemHierarchySaleItems(ModelMap model, @PathVariable("categoryId") long categoryId)
	{
		System.out.println("initSystemHierarchySaleItems-->init-->categoryId=" + categoryId);
		try
		{
			List<NestedCategory> imediateCaregoryList = getSpringSystemSetUpService().getImediateCaregoryList(categoryId);
			List<NestedCategory> bredcrumbList = getSpringSystemSetUpService().getSinglePathCaregoryList(categoryId);

			NestedCategory nestedCategory = getHibernateSystemSetUpService().getNestedCategory(categoryId);
			nestedCategory.setParentId(categoryId);
			model.addAttribute("bredcrumbList", bredcrumbList);
			model.addAttribute("imediateCaregoryList", imediateCaregoryList);
			model.addAttribute("parentCaregory", bredcrumbList.get(bredcrumbList.size() - 1));
			if (imediateCaregoryList != null && imediateCaregoryList.size() > 0)
			{
				model.addAttribute("message", "Please select the Category.");
				model.addAttribute("success", false);
			} else
			{
				// get assigned sale items
				String criteria = "from NestedCategorySaleItem n where n.compoundKey.nestedCategory.id=? and n.compoundKey.saleItem.enabled=? order by n.assigned DESC";
				Object[] criteriaValues =
				{ categoryId, true };
				List<NestedCategorySaleItem> nestedCategorySaleItems = getHibernateSystemSetUpService().getNestedCategorySaleItems(criteria, criteriaValues);

				// get other sale items
				criteria = "from SaleItem s where s.id not in (select n.compoundKey.saleItem.id from NestedCategorySaleItem n where n.compoundKey.nestedCategory.id=?) and s.enabled=? order by s.id";
				List<SaleItem> saleItemList = getHibernateSystemSetUpService().getSaleItems(criteria, criteriaValues);
				System.out.println("saleItemList.size=" + saleItemList.size());

				// append them together
				NestedCategorySaleItem nestedCategorySaleItem;
				for (SaleItem saleItem : saleItemList)
				{
					nestedCategorySaleItem = new NestedCategorySaleItem();
					nestedCategorySaleItem.setSaleItem(saleItem);
					nestedCategorySaleItem.setNestedCategory(nestedCategory);
					nestedCategorySaleItem.setAssigned(false);
					nestedCategorySaleItem.setDisplayName(saleItem.getName());
					nestedCategorySaleItem.setDescription(saleItem.getDescription());
					nestedCategorySaleItem.setPrice(calculatePrice(saleItem.getBasePrice(), nestedCategory.getCategory().getDiffFactor()));
					nestedCategorySaleItems.add(nestedCategorySaleItem);
				}
				nestedCategory.setNestedCategorySaleItems(nestedCategorySaleItems);
				model.addAttribute("nestedCategory", nestedCategory);

				if (nestedCategorySaleItems != null && nestedCategorySaleItems.size() > 0)
				{
					model.addAttribute("success", true);
				} else
				{
					model.addAttribute("message", "Please assign the Items to the Category in the Setup Hierarchy Menu.");
					model.addAttribute("success", false);
				}
			}

		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
		}

		return "/system/setupSystemHierarchySaleItems";
	}

	@RequestMapping(value = "setupSystemHierarchySaleItems/assign", method = RequestMethod.POST)
	@ResponseBody
	public String assignSystemHierarchySaleItem(ModelMap model, HttpServletRequest request)
	{
		System.out.println("assignSystemHierarchySaleItems");

		NestedCategorySaleItem nestedCategorySaleItem = (NestedCategorySaleItem) ContextLoader.getCurrentWebApplicationContext().getBean("NestedCategorySaleItem");
		nestedCategorySaleItem.getCompoundKey().getSaleItem().setId(Long.parseLong(request.getParameter("itemId")));
		nestedCategorySaleItem.getCompoundKey().getNestedCategory().setId(Long.parseLong(request.getParameter("categoryId")));
		nestedCategorySaleItem.setDisplayName(request.getParameter("displayName"));
		nestedCategorySaleItem.setDescription(request.getParameter("description"));
		nestedCategorySaleItem.setPrice(Float.parseFloat(request.getParameter("price")));
		nestedCategorySaleItem.setAssigned(Boolean.parseBoolean(request.getParameter("assigned")));
		try
		{
			if (getHibernateSystemSetUpService().setNestedCategorySaleItem(nestedCategorySaleItem))
				return "Successfully Saved";

		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
			return "Couldn't save the record. Please try again.";
		}
		return "Couldn't save the record. Please try again.";
	}

	@RequestMapping(value = "setupSystemHierarchySaleItems/assignItems", method = RequestMethod.POST)
	public String assignSystemHierarchySaleItems(NestedCategory nestedCategory, ModelMap model)
	{
		System.out.println("assignSystemHierarchySaleItems:" + nestedCategory.getId() + "--:nestedCategory.getNestedCategorySaleItem().size():"
				+ nestedCategory.getNestedCategorySaleItems().size());
		try
		{
			for (NestedCategorySaleItem nestedCategorySaleItem : nestedCategory.getNestedCategorySaleItems())
			{
				getHibernateSystemSetUpService().setNestedCategorySaleItem(nestedCategorySaleItem);
			}
			List<NestedCategory> imediateCaregoryList = getSpringSystemSetUpService().getImediateCaregoryList(nestedCategory.getId());
			List<NestedCategory> bredcrumbList = getSpringSystemSetUpService().getSinglePathCaregoryList(nestedCategory.getId());

			model.addAttribute("bredcrumbList", bredcrumbList);
			model.addAttribute("imediateCaregoryList", imediateCaregoryList);
			model.addAttribute("parentCaregory", bredcrumbList.get(bredcrumbList.size() - 1));
			model.addAttribute("nestedCategory", nestedCategory);

			model.addAttribute("message", "Successfully Saved");
			model.addAttribute("success", true);
		} catch (Exception ex)
		{
			model.addAttribute("message", ex.getMessage());
			model.addAttribute("success", false);
		}
		return "/system/setupSystemHierarchySaleItems";
	}

	private float calculatePrice(float basePrice, int diffFactor)
	{
		float price = basePrice * (100 + diffFactor) / 100;
		NumberFormat nf = new DecimalFormat("#####.##");

		return Float.parseFloat(nf.format(price));
	}

	@ModelAttribute("systemHierarchySetupList")
	public Map<Long, String> getSystemHierarchySetupList()
	{
		return systemHierarchySetupList;
	}

	public void setSystemHierarchySetupList(Map<Long, String> systemHierarchySetupList)
	{
		this.systemHierarchySetupList = systemHierarchySetupList;
	}

	@ModelAttribute("priceForList")
	public Map<String, String> getPriceForList()
	{
		return priceForList;
	}

	public void setPriceForList(Map<String, String> priceForList)
	{
		this.priceForList = priceForList;
	}

	@ModelAttribute("searchByList")
	public List<String> getSearchByList()
	{
		return searchByList;
	}

	public void setSearchByList(List<String> searchByList)
	{
		this.searchByList = searchByList;
	}

	private boolean isItemAssigned(long parentId, Set<NestedCategory> nestedCategorySet)
	{
		Iterator<NestedCategory> itr = nestedCategorySet.iterator();
		NestedCategory nestedCategory;
		while (itr.hasNext())
		{
			nestedCategory = itr.next();
			if (nestedCategory.getId() == parentId)
				return true;
		}
		return false;
	}

	private boolean validateData(MultipartFile file, long id, ModelMap model)
	{
		// validate the uploaded file
		String ext = "";
		if (id > 0 && file.getSize() <= 0)
		{
			return true;
		} else
		{
			if (file.getSize() > 0)
			{
				if (file.getSize() > getMaxUploadSize())
				{
					System.out.println("File Size:::" + file.getSize());
					model.addAttribute("message", "error.large.file");
					return false;
				}
				int pos = file.getOriginalFilename().lastIndexOf('.');
				ext = file.getOriginalFilename().substring(pos + 1);
				if (!ext.matches(getAcceptedImageFiles()))
				{
					System.out.println("File ext:::" + ext);
					model.addAttribute("message", "error.invalid.file");
					return false;
				}
			} else
			{
				model.addAttribute("message", "error.no.selected.file");
				return false;
			}
		}
		return true;
	}

	private boolean uploadFile(MultipartFile fileData, String fileName, ModelMap model, String fileExt)
	{
		try
		{
			InputStream inputStream = null;
			OutputStream outputStream = null;
			String file;
			inputStream = fileData.getInputStream();

			file = getImagePath() + fileName.concat("." + fileExt);
			outputStream = new FileOutputStream(file);
			System.out.println("fileName:" + file);

			int readBytes = 0;
			byte[] buffer = new byte[getMaxUploadSize()];
			while ((readBytes = inputStream.read(buffer, 0, getMaxUploadSize())) != -1)
			{
				outputStream.write(buffer, 0, readBytes);
			}
			outputStream.close();
			inputStream.close();
		} catch (Exception e)
		{
			e.printStackTrace();
			model.addAttribute("message", "error.file.upload.failed");
			model.addAttribute("success", false);
			return false;
		}
		return true;
	}

}
