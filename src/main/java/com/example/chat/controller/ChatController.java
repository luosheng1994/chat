package com.example.chat.controller;

import com.example.chat.entity.ChatMessage;
import com.example.chat.service.ChatService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ChatController {
    private final ChatService chatService;

    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/users")
    public Object users() { return chatService.users(); }

    @GetMapping("/friends/{userId}")
    public Object friends(@PathVariable Long userId) { return chatService.friends(userId); }

    @PatchMapping("/users/{userId}/nickname")
    public Object nickname(@PathVariable Long userId, @RequestBody Map<String, String> req) {
        return chatService.updateNickname(userId, req.get("nickname"));
    }

    @PatchMapping("/friends/remark")
    public void remark(@RequestBody Map<String, String> req) {
        chatService.updateRemark(Long.valueOf(req.get("userId")), Long.valueOf(req.get("friendId")), req.get("remark"));
    }

    @PostMapping("/groups")
    public Object createGroup(@RequestBody Map<String, Object> req) {
        return chatService.createGroup(Long.valueOf(req.get("ownerId").toString()), (String) req.get("name"),
                ((List<?>) req.get("members")).stream().map(v -> Long.valueOf(v.toString())).toList());
    }

    @GetMapping("/groups/{userId}")
    public Object groups(@PathVariable Long userId) { return chatService.groupsOfUser(userId); }

    @PostMapping("/groups/{groupId}/members")
    public void addMember(@PathVariable Long groupId, @RequestBody Map<String, String> req) {
        chatService.addMember(Long.valueOf(req.get("operatorId")), groupId, Long.valueOf(req.get("memberId")));
    }

    @DeleteMapping("/groups/{groupId}/members/{memberId}")
    public void kickMember(@PathVariable Long groupId, @PathVariable Long memberId, @RequestParam Long operatorId) {
        chatService.kickMember(operatorId, groupId, memberId);
    }

    @DeleteMapping("/groups/{groupId}/leave")
    public void leaveGroup(@PathVariable Long groupId, @RequestParam Long userId) { chatService.leaveGroup(userId, groupId); }

    @PostMapping("/messages")
    public Object send(@RequestBody ChatMessage msg) { return chatService.send(msg); }

    @PostMapping("/messages/{messageId}/recall")
    public void recall(@PathVariable Long messageId, @RequestBody Map<String, String> req) {
        chatService.recall(messageId, Long.valueOf(req.get("userId")));
    }

    @GetMapping("/history/private")
    public Object privateHistory(@RequestParam Long a, @RequestParam Long b) { return chatService.privateHistory(a, b); }

    @GetMapping("/history/group/{groupId}")
    public Object groupHistory(@PathVariable Long groupId) { return chatService.groupHistory(groupId); }
}
