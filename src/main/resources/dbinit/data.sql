insert into "user" (name, email) values ('Maria Sales Agent', 'maria@example.com');
insert into "user" (name, email) values ('Paula Sales Agent', 'paula@example.com');
insert into "user" (name, email) values ('Carla Sales Agent', 'carla@example.com');
insert into "user" (name, email) values ('Javier Sales Agent', 'javier@example.com');

insert into "user" (name, email) values ('Roberto Business Admin', 'roberto@example.com');
insert into "user" (name, email) values ('Nicolas Business Admin', 'nicolas@example.com');
insert into "user" (name, email) values ('Martin Business Admin', 'martin@example.com');
insert into "user" (name, email) values ('Sebastian Business Admin', 'sebastian@example.com');
insert into "user" (name, email) values ('Amanda Root', 'amanda@example.com');

insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Maria Sales Agent'), (select id from "role" where name = 'SALES_AGENT'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Paula Sales Agent'), (select id from "role" where name = 'SALES_AGENT'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Carla Sales Agent'), (select id from "role" where name = 'SALES_AGENT'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Javier Sales Agent'), (select id from "role" where name = 'SALES_AGENT'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Roberto Business Admin'), (select id from "role" where name = 'BUSINESS_ADMIN'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Nicolas Business Admin'), (select id from "role" where name = 'BUSINESS_ADMIN'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Martin Business Admin'), (select id from "role" where name = 'BUSINESS_ADMIN'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Sebastian Business Admin'), (select id from "role" where name = 'BUSINESS_ADMIN'));
insert into "user_role" (id_user, id_role) values ((select id from "user" where name = 'Amanda Root'), (select id from "role" where name = 'ROOT_ADMIN'));
