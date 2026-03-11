insert into user_profile(id, username, nickname) values(1,'alice','小明');
insert into user_profile(id, username, nickname) values(2,'bob','小红');
insert into user_profile(id, username, nickname) values(3,'carol','小刚');
insert into user_profile(id, username, nickname) values(4,'david','小美');

insert into friend_relation(user_id, friend_id, remark) values(1,2,'产品同学');
insert into friend_relation(user_id, friend_id, remark) values(1,3,'');
insert into friend_relation(user_id, friend_id, remark) values(1,4,'项目群友');

insert into friend_relation(user_id, friend_id, remark) values(2,1,'老同学');
insert into friend_relation(user_id, friend_id, remark) values(3,1,'');
insert into friend_relation(user_id, friend_id, remark) values(4,1,'');
