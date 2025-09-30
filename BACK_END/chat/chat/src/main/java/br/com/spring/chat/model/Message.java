package br.com.spring.chat.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties; // Adicionada
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp; // Alterada
import java.time.Instant;

@Entity
@Getter
@Setter
@Table(name = "messages")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"}) // Sugestão 3
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 500)
    private String content;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MessageStatus status = MessageStatus.SENT;

    // --- Sugestão 1: Carregamento EAGER para API (Evita NULLs) ---
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "sender_id", nullable = false)
    private User sender;

    // --- Sugestão 1: Carregamento EAGER para API (Evita NULLs) ---
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "receiver_id", nullable = false)
    private User receiver;

    // --- Sugestão 2: Usar @CreationTimestamp para maior precisão ---
    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt; // Removido = Instant.now()
}