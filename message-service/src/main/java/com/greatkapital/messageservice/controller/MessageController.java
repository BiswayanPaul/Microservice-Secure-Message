package com.greatkapital.messageservice.controller;

import com.greatkapital.messageservice.dto.MessageRequest;
import com.greatkapital.messageservice.dto.MessageResponse;
import com.greatkapital.messageservice.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/messages")
public class MessageController {

    @Autowired
    @Qualifier("messageServiceImpl")
    private MessageService messageService;

    @PostMapping("/send")
    public ResponseEntity<?> sendMessage(Authentication authentication,
            @RequestBody MessageRequest request) {
        try {
            String sender = authentication.getName();
            MessageResponse response = messageService.sendMessage(sender, request.getRecipient(), request.getContent(),
                    "AES");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @GetMapping("/inbox")
    public ResponseEntity<List<MessageResponse>> getInbox(Authentication authentication) {
        try {
            String username = authentication.getName();
            List<MessageResponse> messages = messageService.getMessagesForUser(username);
            return ResponseEntity.ok(messages);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}