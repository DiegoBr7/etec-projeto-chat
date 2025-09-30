package br.com.spring.chat.dto;

public record UserDTO(
        Long id,
        String email,
        String nome
) { }
