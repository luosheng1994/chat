package com.example.chat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.chat.entity.*;
import com.example.chat.mapper.*;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@Service
public class ChatService {
    private final UserProfileMapper userMapper;
    private final FriendRelationMapper friendMapper;
    private final ChatGroupMapper groupMapper;
    private final GroupMemberMapper memberMapper;
    private final ChatMessageMapper messageMapper;
    private final SimpMessagingTemplate messagingTemplate;

    public ChatService(UserProfileMapper userMapper, FriendRelationMapper friendMapper, ChatGroupMapper groupMapper,
                       GroupMemberMapper memberMapper, ChatMessageMapper messageMapper,
                       SimpMessagingTemplate messagingTemplate) {
        this.userMapper = userMapper;
        this.friendMapper = friendMapper;
        this.groupMapper = groupMapper;
        this.memberMapper = memberMapper;
        this.messageMapper = messageMapper;
        this.messagingTemplate = messagingTemplate;
    }

    public List<UserProfile> users() { return userMapper.selectList(null); }

    public List<FriendRelation> friends(Long userId) {
        return friendMapper.selectList(new LambdaQueryWrapper<FriendRelation>().eq(FriendRelation::getUserId, userId));
    }

    public UserProfile updateNickname(Long userId, String nickname) {
        UserProfile user = userMapper.selectById(userId);
        user.setNickname(nickname);
        userMapper.updateById(user);
        return user;
    }

    public void updateRemark(Long userId, Long friendId, String remark) {
        FriendRelation relation = friendMapper.selectOne(new LambdaQueryWrapper<FriendRelation>()
                .eq(FriendRelation::getUserId, userId).eq(FriendRelation::getFriendId, friendId));
        relation.setRemark(remark);
        friendMapper.updateById(relation);
    }

    @Transactional
    public ChatGroup createGroup(Long ownerId, String name, List<Long> members) {
        ChatGroup group = new ChatGroup();
        group.setOwnerId(ownerId);
        group.setName(name);
        groupMapper.insert(group);
        Set<Long> all = new HashSet<>(members);
        all.add(ownerId);
        for (Long member : all) {
            GroupMember gm = new GroupMember();
            gm.setGroupId(group.getId());
            gm.setUserId(member);
            memberMapper.insert(gm);
        }
        systemNoticeToGroup(group.getId(), "群聊已创建");
        return group;
    }

    public List<ChatGroup> groupsOfUser(Long userId) {
        List<GroupMember> joins = memberMapper.selectList(new LambdaQueryWrapper<GroupMember>().eq(GroupMember::getUserId, userId));
        if (joins.isEmpty()) return List.of();
        List<Long> ids = joins.stream().map(GroupMember::getGroupId).toList();
        return groupMapper.selectBatchIds(ids);
    }

    public void addMember(Long operatorId, Long groupId, Long newMember) {
        ChatGroup group = groupMapper.selectById(groupId);
        if (!Objects.equals(group.getOwnerId(), operatorId)) throw new RuntimeException("只有群主可拉人");
        GroupMember gm = new GroupMember();
        gm.setGroupId(groupId);
        gm.setUserId(newMember);
        memberMapper.insert(gm);
        systemNoticeToGroup(groupId, "新成员加入群聊");
    }

    public void kickMember(Long operatorId, Long groupId, Long memberId) {
        ChatGroup group = groupMapper.selectById(groupId);
        if (!Objects.equals(group.getOwnerId(), operatorId)) throw new RuntimeException("只有群主可踢人");
        memberMapper.delete(new LambdaQueryWrapper<GroupMember>().eq(GroupMember::getGroupId, groupId).eq(GroupMember::getUserId, memberId));
        systemNoticeToGroup(groupId, "成员已被移出群聊");
    }

    public void leaveGroup(Long userId, Long groupId) {
        memberMapper.delete(new LambdaQueryWrapper<GroupMember>().eq(GroupMember::getGroupId, groupId).eq(GroupMember::getUserId, userId));
        systemNoticeToGroup(groupId, "有成员离开群聊");
    }

    public ChatMessage send(ChatMessage message) {
        message.setCreatedAt(LocalDateTime.now());
        message.setRecalled(0);
        messageMapper.insert(message);
        Map<String, Object> payload = toPayload(message);
        if (message.getGroupId() != null) {
            messagingTemplate.convertAndSend("/topic/group-" + message.getGroupId(), payload);
        } else {
            messagingTemplate.convertAndSend("/topic/private-" + sortedPair(message.getSenderId(), message.getReceiverId()), payload);
        }
        return message;
    }

    public void recall(Long messageId, Long userId) {
        ChatMessage msg = messageMapper.selectById(messageId);
        if (!Objects.equals(msg.getSenderId(), userId)) throw new RuntimeException("仅发送者可撤回");
        msg.setRecalled(1);
        msg.setContent("你撤回了一条消息");
        messageMapper.updateById(msg);
        Map<String, Object> payload = toPayload(msg);
        payload.put("event", "recall");
        if (msg.getGroupId() != null) {
            messagingTemplate.convertAndSend("/topic/group-" + msg.getGroupId(), payload);
        } else {
            messagingTemplate.convertAndSend("/topic/private-" + sortedPair(msg.getSenderId(), msg.getReceiverId()), payload);
        }
    }

    public List<ChatMessage> privateHistory(Long a, Long b) {
        return messageMapper.selectList(new LambdaQueryWrapper<ChatMessage>()
                .isNull(ChatMessage::getGroupId)
                .and(w -> w.eq(ChatMessage::getSenderId, a).eq(ChatMessage::getReceiverId, b)
                        .or().eq(ChatMessage::getSenderId, b).eq(ChatMessage::getReceiverId, a))
                .orderByAsc(ChatMessage::getCreatedAt));
    }

    public List<ChatMessage> groupHistory(Long groupId) {
        return messageMapper.selectList(new LambdaQueryWrapper<ChatMessage>().eq(ChatMessage::getGroupId, groupId)
                .orderByAsc(ChatMessage::getCreatedAt));
    }

    private void systemNoticeToGroup(Long groupId, String text) {
        ChatMessage m = new ChatMessage();
        m.setSenderId(0L);
        m.setGroupId(groupId);
        m.setType("SYSTEM");
        m.setContent(text);
        send(m);
    }

    private String sortedPair(Long a, Long b) {
        return Math.min(a, b) + "-" + Math.max(a, b);
    }

    private Map<String, Object> toPayload(ChatMessage msg) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", msg.getId());
        m.put("senderId", msg.getSenderId());
        m.put("receiverId", msg.getReceiverId());
        m.put("groupId", msg.getGroupId());
        m.put("type", msg.getType());
        m.put("content", msg.getContent());
        m.put("fileName", msg.getFileName());
        m.put("recalled", msg.getRecalled());
        m.put("createdAt", msg.getCreatedAt());
        return m;
    }
}
