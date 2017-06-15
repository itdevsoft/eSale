package com.esale.controllers;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class LoginController {

	@RequestMapping(value = "/welcome", method = RequestMethod.GET)
	public String welcomeHome(ModelMap model) {
		System.out.println("printWelcome-->"+ SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		User user = (User) SecurityContextHolder.getContext()
					.getAuthentication().getPrincipal();
			String name = user.getUsername();

			model.addAttribute("username", name);
			model.addAttribute("message",
					"Welcome to the e-Sale");
			return "home";
	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(ModelMap model) {

		return "login";

	}

	@RequestMapping(value = "/loginfailed", method = RequestMethod.GET)
	public String loginerror(ModelMap model) {
		System.out.println("loginerror-->"
				+ SecurityContextHolder.getContext().getAuthentication()
						.getCredentials().toString());
		model.addAttribute("error", "true");
		return "login";

	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(ModelMap model) {
		return "login";

	}
}