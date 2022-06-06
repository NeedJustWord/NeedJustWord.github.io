# Oracle可重复执行脚本

1. 设置字段可空

   ```sql
   declare
   v_flag char(1);
   begin
   --设置字段可空
   select nullable into v_flag from user_tab_columns
   where table_name=upper('表名') and column_name=upper('字段名');
   if v_flag='N' then
   execute immediate 'alter table 表名 modify 字段名 null';
   end if;
   end;
   /
   ```

2. 设置字段不可空

   ```sql
   --更新空值,没有空值可不执行
   update 表名 set 字段名=空默认值 where 字段名 is null;
   commit;
   /
   
   declare
   v_flag char(1);
   begin
   --设置字段不可空
   select nullable into v_flag from user_tab_columns
   where table_name=upper('表名') and column_name=upper('字段名');
   if v_flag='Y' then
   execute immediate 'alter table 表名 modify 字段名 not null';
   end if;
   end;
   /
   ```

3. 删除主键/重建主键

   ```sql
   declare
   v_num int;
   v_name varchar2(128);
   begin
   --删除主键
   select count(1) into v_num from user_constraints
   where constraint_type='P' and table_name=upper('表名');
   if v_num>0 then
   select constraint_name into v_name from user_constraints
   where constraint_type='P' and table_name=upper('表名');
   execute immediate 'alter table 表名 drop constraint '||v_name||' cascade';
   end if;
   end;
   /
   
   --重建主键,[]为可选项
   alter table 表名 add constraint 主键名 primary key (主键列名1[,主键列名2...]);
   ```

4. 添加字段

   ```sql
   declare
   v_num int;
   begin
   --添加字段,[]为可选项
   select count(1) into v_num from user_tab_columns
   where table_name=upper('表名') and column_name=upper('字段名');
   if v_num=0 then
   execute immediate 'alter table 表名 add 字段名 类型[ default 默认值][ not null]';
   end if;
   end;
   /
   ```

5. 添加或更新表注释

   ```sql
   --添加或更新表注释
   comment on table 表名 is '注释内容';
   ```

6. 添加或更新字段注释

   ```sql
   --添加或更新字段注释
   comment on column 表名.字段名 is '注释内容';
   ```

7. 设置默认值

   ```sql
   --设置默认值
   alter table 表名 modify 字段名 default 默认值;
   ```