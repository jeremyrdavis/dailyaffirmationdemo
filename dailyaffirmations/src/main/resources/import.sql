-- This file allows writing SQL commands that will be emitted in test and dev.
-- The commands are commented as their support depends on the database
-- insert into myentity (id, field) values(1, 'field-1');
-- insert into myentity (id, field) values(2, 'field-2');
-- insert into myentity (id, field) values(3, 'field-3');
-- alter sequence myentity_seq restart with 4;

insert into Affirmation(text, author, id) values('You are awesome!', 'Quarkus', nextval('Affirmation_SEQ'));
insert into Affirmation(text, author, id) values('People like you!', 'Quarkus', nextval('Affirmation_SEQ'));
insert into Affirmation(text, author, id) values('You are smart!', 'Quarkus', nextval('Affirmation_SEQ'));