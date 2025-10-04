package br.com.spring.chat.controller;

import br.com.spring.chat.model.User;
import br.com.spring.chat.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService usuarioService;

    public AuthController(UserService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @GetMapping("/me")
    public ResponseEntity<User> getCurrentUser(@RequestParam Long id) {
        return usuarioService.buscarUsuarioPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

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


    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User user) {
        User encontrado = usuarioService.buscarPorEmail(user.getEmail());

        if (encontrado != null && encontrado.getSenha().equals(user.getSenha())) {
            return ResponseEntity.ok("Login bem-sucedido");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciais inválidas");
        }
    }

    @GetMapping("/findByEmail")
    public ResponseEntity<?> findByEmail(@RequestParam String email) {
        User user = usuarioService.buscarPorEmail(email);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Usuário não encontrado");
        }
    }





}
