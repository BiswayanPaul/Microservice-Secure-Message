package com.greatkapital.messageservice.repository;

import com.greatkapital.messageservice.entity.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Long> {
    List<Message> findBySenderOrRecipientOrderByTimestampAsc(String sender, String recipient);
}