package br.com.spring.chat.repository;

import br.com.spring.chat.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User , Long > {
}
