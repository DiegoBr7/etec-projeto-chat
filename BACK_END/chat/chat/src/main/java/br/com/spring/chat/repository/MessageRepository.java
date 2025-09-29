package br.com.spring.chat.repository;

import br.com.spring.chat.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MessageRepository extends JpaRepository<Message , Long> {
}
