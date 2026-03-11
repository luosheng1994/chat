create table user_profile (
    id bigint auto_increment primary key,
    username varchar(64) not null,
    nickname varchar(64) not null
);

create table friend_relation (
    id bigint auto_increment primary key,
    user_id bigint not null,
    friend_id bigint not null,
    remark varchar(64)
);

create table chat_group (
    id bigint auto_increment primary key,
    name varchar(128) not null,
    owner_id bigint not null
);

create table group_member (
    id bigint auto_increment primary key,
    group_id bigint not null,
    user_id bigint not null
);

create table chat_message (
    id bigint auto_increment primary key,
    sender_id bigint,
    receiver_id bigint,
    group_id bigint,
    type varchar(32),
    content clob,
    file_name varchar(255),
    recalled tinyint default 0,
    created_at timestamp
);
