package com.kukuk.app;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WelcomeController {

    public WelcomeController() {
        System.out.println("WelcomeController wurde geladen.");
    }

    @GetMapping("/")
    public String welcome() {
        return "Willkommen bei Bash-Firma Kukuk!";
    }
}
