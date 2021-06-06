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
  'df067f62-c218-412b-9c41-3a7e1277957c',
  'メモ1',
  'メモの内容\r\nメモの内容\r\nメモの内容\r\nメモの内容',
  default
)
;

insert into memos values
(
  '632a161b-0c21-4fe5-95e0-bfdc9cd4958f',
  'メモ2',
  'メモの内容\r\nメモの内容\r\nメモの内容\r\nメモの内容',
  default
)
;

insert into memos values
(
  '9bc3b751-3e81-400a-bb80-3906e64270a3',
  'メモ3',
  'メモの内容\r\nメモの内容\r\nメモの内容\r\nメモの内容',
  default
)
;

select * from memos
;
