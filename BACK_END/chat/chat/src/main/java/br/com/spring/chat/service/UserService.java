package br.com.spring.chat.service;

import br.com.spring.chat.model.User;
import br.com.spring.chat.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    // Injeção via construtor (boa prática)
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User salvarUser(User user) {
        return userRepository.save(user);
    }

    public List<User> listarUsers() {
        return userRepository.findAll();
    }

    public Optional<User> buscarUsuarioPorId(Long id) {
        return userRepository.findById(id);
    }

    public void deletarUser(Long id) {
        userRepository.deleteById(id);
    }
}
