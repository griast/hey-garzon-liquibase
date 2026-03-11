insert into "user" (name, email) values ('Maria Sales Agent', 'maria@example.com');
insert into "user" (name, email) values ('Paula Sales Agent', 'paula@example.com');
insert into "user" (name, email) values ('Carla Sales Agent', 'carla@example.com');
insert into "user" (name, email) values ('Javier Sales Agent', 'javier@example.com');

insert into "user" (name, email) values ('Roberto Manager', 'roberto@example.com');
insert into "user" (name, email) values ('Nicolas Manager', 'nicolas@example.com');
insert into "user" (name, email) values ('Martin Manager', 'martin@example.com');
insert into "user" (name, email) values ('Sebastian Manager', 'sebastian@example.com');
insert into "user" (name, email) values ('Amanda Root', 'amanda@example.com');

insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Maria Sales Agent'), (select id from "role" where name = 'SALES_AGENT'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Paula Sales Agent'), (select id from "role" where name = 'SALES_AGENT'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Carla Sales Agent'), (select id from "role" where name = 'SALES_AGENT'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Javier Sales Agent'), (select id from "role" where name = 'SALES_AGENT'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Roberto Manager'), (select id from "role" where name = 'MANAGER'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Nicolas Manager'), (select id from "role" where name = 'MANAGER'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Martin Manager'), (select id from "role" where name = 'MANAGER'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Sebastian Manager'), (select id from "role" where name = 'MANAGER'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Amanda Root'), (select id from "role" where name = 'ROOT_ADMIN'));


insert into "business" (name, address, phones, mail, logo, enabled) values ('Business 1', 'Address 1', '1234567890', 'business1@example.com', 'https://example.com/logo1.png', true);
insert into "business" (name, address, phones, mail, logo, enabled) values ('Business 2', 'Address 2', '1234567890', 'business2@example.com', 'https://example.com/logo2.png', true);
insert into "business" (name, address, phones, mail, logo, enabled) values ('Business 3', 'Address 3', '1234567890', 'business3@example.com', 'https://example.com/logo3.png', true);

insert into "business_social_media" (id_business, url, platform) values ((select id from "business" where name = 'Business 1'), 'https://example.com/social1.png', 'FACEBOOK');
insert into "business_social_media" (id_business, url, platform) values ((select id from "business" where name = 'Business 1'), 'https://example.com/social2.png', 'INSTAGRAM');
insert into "business_social_media" (id_business, url, platform) values ((select id from "business" where name = 'Business 2'), 'https://example.com/social3.png', 'FACEBOOK');
insert into "business_social_media" (id_business, url, platform) values ((select id from "business" where name = 'Business 2'), 'https://example.com/social4.png', 'INSTAGRAM');
insert into "business_social_media" (id_business, url, platform) values ((select id from "business" where name = 'Business 3'), 'https://example.com/social5.png', 'FACEBOOK');
insert into "business_social_media" (id_business, url, platform) values ((select id from "business" where name = 'Business 3'), 'https://example.com/social6.png', 'INSTAGRAM');

insert into "business_manager" (id_business, id_user) values ((select id from "business" where name = 'Business 1'), (select id from "user" where name = 'Roberto Manager'));
insert into "business_manager" (id_business, id_user) values ((select id from "business" where name = 'Business 2'), (select id from "user" where name = 'Nicolas Manager'));
insert into "business_manager" (id_business, id_user) values ((select id from "business" where name = 'Business 3'), (select id from "user" where name = 'Martin Manager'));
