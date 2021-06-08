drop table memos
;

create table memos
(
  id char(36) primary key,
  title varchar(1000),
  body varchar(10000),
  created_at timestamp default current_timestamp
)
;

insert into memos values
(
  '734dcc27-fab2-445a-bc58-895845c61cef',
  'pg製メモ1',
  'メモの内容\nメモの内容\rメモの内容\r\nメモの内容\\nメモの内容',
  default
)
;

insert into memos values
(
  'e62a2108-febf-4629-925c-5f8491adce07',
  'pg製メモ2',
  'メモの内容\r\nメモの内容\r\nメモの内容\r\nメモの内容',
  default
)
;

insert into memos values
(
  '003deed3-cf53-4ca2-9ce5-0012f0279d74',
  'pg製メモ3',
  'メモの内容\r\nメモの内容\r\nメモの内容\r\nメモの内容',
  default
)
;

select * from memos
;
