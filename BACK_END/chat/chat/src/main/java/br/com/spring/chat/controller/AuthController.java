package br.com.spring.chat.controller;

import br.com.spring.chat.model.User;
import br.com.spring.chat.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService usuarioService;

    @GetMapping("/listar")

    public List<User> listarUser(){
        return usuarioService.listarUsers();
    }

    @PostMapping("/enviar")
    public User enviarUser(@RequestBody User user){
        return usuarioService.salvarUser(user);
    }

    @DeleteMapping("/{id}")
    public void deletarUser(@PathVariable Long id){
        usuarioService.deletarUser(id);
    }





}
