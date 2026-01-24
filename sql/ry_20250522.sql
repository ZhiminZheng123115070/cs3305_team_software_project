USE `ry-vue`;
-- ----------------------------
-- 1. Department Table
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  dept_id           bigint(20)      not null auto_increment    comment 'Department ID',
  parent_id         bigint(20)      default 0                  comment 'Parent Dept ID',
  ancestors         varchar(50)     default ''                 comment 'Ancestors List',
  dept_name         varchar(30)     default ''                 comment 'Department Name',
  order_num         int(4)          default 0                  comment 'Display Order',
  leader            varchar(20)     default null               comment 'Leader',
  phone             varchar(11)     default null               comment 'Contact Phone',
  email             varchar(50)     default null               comment 'Email Address',
  status            char(1)         default '0'                comment 'Dept Status (0=Normal, 1=Disabled)',
  del_flag          char(1)         default '0'                comment 'Delete Flag (0=Exists, 2=Deleted)',
  create_by         varchar(64)     default ''                 comment 'Creator',
  create_time 	    datetime                                   comment 'Create Time',
  update_by         varchar(64)     default ''                 comment 'Updater',
  update_time       datetime                                   comment 'Update Time',
  primary key (dept_id)
) engine=innodb auto_increment=200 comment = 'Department Table';

-- ----------------------------
-- Initial Data for Department
-- ----------------------------
insert into sys_dept values(100,  0,   '0',          'RuoYi Tech',   0, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(101,  100, '0,100',      'Shenzhen HQ',  1, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(102,  100, '0,100',      'Changsha Branch', 2, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(103,  101, '0,100,101',  'R&D Dept',     1, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(104,  101, '0,100,101',  'Marketing',    2, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(105,  101, '0,100,101',  'Testing',      3, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(106,  101, '0,100,101',  'Finance',      4, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(107,  101, '0,100,101',  'Ops Dept',     5, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(108,  102, '0,100,102',  'Marketing',    1, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(109,  102, '0,100,102',  'Finance',      2, 'Admin', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);


-- ----------------------------
-- 2. User Table
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id           bigint(20)      not null auto_increment    comment 'User ID',
  dept_id           bigint(20)      default null               comment 'Dept ID',
  user_name         varchar(30)     not null                   comment 'Username',
  nick_name         varchar(30)     not null                   comment 'Nickname',
  user_type         varchar(2)      default '00'               comment 'User Type (00=System User)',
  email             varchar(50)     default ''                 comment 'Email Address',
  phonenumber       varchar(11)     default ''                 comment 'Phone Number',
  sex               char(1)         default '0'                comment 'Gender (0=Male, 1=Female, 2=Unknown)',
  avatar            varchar(100)    default ''                 comment 'Avatar URL',
  password          varchar(100)    default ''                 comment 'Password',
  status            char(1)         default '0'                comment 'Account Status (0=Normal, 1=Disabled)',
  del_flag          char(1)         default '0'                comment 'Delete Flag (0=Exists, 2=Deleted)',
  login_ip          varchar(128)    default ''                 comment 'Last Login IP',
  login_date        datetime                                   comment 'Last Login Time',
  pwd_update_date   datetime                                   comment 'Password Update Time',
  create_by         varchar(64)     default ''                 comment 'Creator',
  create_time       datetime                                   comment 'Create Time',
  update_by         varchar(64)     default ''                 comment 'Updater',
  update_time       datetime                                   comment 'Update Time',
  remark            varchar(500)    default null               comment 'Remark',
  primary key (user_id)
) engine=innodb auto_increment=100 comment = 'User Information Table';

-- ----------------------------
-- Initial Data for User
-- ----------------------------
insert into sys_user values(1,  103, 'admin', 'RuoYi', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, 'Admin User');
insert into sys_user values(2,  105, 'ry',    'RuoYi', '00', 'ry@qq.com',  '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, 'Tester');


-- ----------------------------
-- 3. Post Table
-- ----------------------------
drop table if exists sys_post;
create table sys_post
(
  post_id       bigint(20)      not null auto_increment    comment 'Post ID',
  post_code     varchar(64)     not null                   comment 'Post Code',
  post_name     varchar(50)     not null                   comment 'Post Name',
  post_sort     int(4)          not null                   comment 'Display Order',
  status        char(1)         not null                   comment 'Status (0=Normal, 1=Disabled)',
  create_by     varchar(64)     default ''                 comment 'Creator',
  create_time   datetime                                   comment 'Create Time',
  update_by     varchar(64)     default ''			       comment 'Updater',
  update_time   datetime                                   comment 'Update Time',
  remark        varchar(500)    default null               comment 'Remark',
  primary key (post_id)
) engine=innodb comment = 'Post Information Table';

-- ----------------------------
-- Initial Data for Post
-- ----------------------------
insert into sys_post values(1, 'ceo',  'Chairman',    1, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(2, 'se',   'Project Manager',  2, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(3, 'hr',   'HR Manager',  3, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(4, 'user', 'Common Staff',  4, '0', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 4. Role Table
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id              bigint(20)      not null auto_increment    comment 'Role ID',
  role_name            varchar(30)     not null                   comment 'Role Name',
  role_key             varchar(100)    not null                   comment 'Role Permission String',
  role_sort            int(4)          not null                   comment 'Display Order',
  data_scope           char(1)         default '1'                comment 'Data Scope (1: All, 2: Custom, 3: This Dept, 4: This Dept & Below)',
  menu_check_strictly  tinyint(1)      default 1                  comment 'Menu tree selection correlation',
  dept_check_strictly  tinyint(1)      default 1                  comment 'Dept tree selection correlation',
  status               char(1)         not null                   comment 'Role Status (0=Normal, 1=Disabled)',
  del_flag             char(1)         default '0'                comment 'Delete Flag (0=Exists, 2=Deleted)',
  create_by            varchar(64)     default ''                 comment 'Creator',
  create_time          datetime                                   comment 'Create Time',
  update_by            varchar(64)     default ''                 comment 'Updater',
  update_time          datetime                                   comment 'Update Time',
  remark               varchar(500)    default null               comment 'Remark',
  primary key (role_id)
) engine=innodb auto_increment=100 comment = 'Role Information Table';
-- ----------------------------
-- Initial Data for sys_role
-- ----------------------------
insert into sys_role values('1', 'Super Admin',  'admin',  1, 1, 1, 1, '0', '0', 'admin', sysdate(), '', null, 'Super Administrator');
insert into sys_role values('2', 'Common Role',  'common', 2, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, 'Common Role');

-- ----------------------------
-- 5. Menu Table
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id           bigint(20)      not null auto_increment    comment 'Menu ID',
  menu_name         varchar(50)     not null                   comment 'Menu Name',
  parent_id         bigint(20)      default 0                  comment 'Parent Menu ID',
  order_num         int(4)          default 0                  comment 'Display Order',
  path              varchar(200)    default ''                 comment 'Route Path',
  component         varchar(255)    default null               comment 'Component Path',
  query             varchar(255)    default null               comment 'Route Query',
  route_name        varchar(50)     default ''                 comment 'Route Name',
  is_frame          int(1)          default 1                  comment 'Is External Link (0=Yes, 1=No)',
  is_cache          int(1)          default 0                  comment 'Is Cache (0=Cache, 1=No)',
  menu_type         char(1)         default ''                 comment 'Menu Type (M=Directory, C=Menu, F=Button)',
  visible           char(1)         default 0                  comment 'Visibility (0=Show, 1=Hide)',
  status            char(1)         default 0                  comment 'Status (0=Normal, 1=Disabled)',
  perms             varchar(100)    default null               comment 'Permission String',
  icon              varchar(100)    default '#'                comment 'Icon',
  create_by         varchar(64)     default ''                 comment 'Creator',
  create_time       datetime                                   comment 'Create Time',
  update_by         varchar(64)     default ''                 comment 'Updater',
  update_time       datetime                                   comment 'Update Time',
  remark            varchar(500)    default ''                 comment 'Remark',
  primary key (menu_id)
) engine=innodb auto_increment=2000 comment = 'Menu Table';

-- ----------------------------
-- Initial Data for sys_menu
-- ----------------------------
-- Level 1 Menus
insert into sys_menu values('1', 'System Management', '0', '1', 'system',   null, '', '', 1, 0, 'M', '0', '0', '', 'system',   'admin', sysdate(), '', null, 'System Management Directory');
insert into sys_menu values('2', 'System Monitor', '0', '2', 'monitor',    null, '', '', 1, 0, 'M', '0', '0', '', 'monitor',  'admin', sysdate(), '', null, 'System Monitoring Directory');
insert into sys_menu values('3', 'System Tools', '0', '3', 'tool',       null, '', '', 1, 0, 'M', '0', '0', '', 'tool',     'admin', sysdate(), '', null, 'System Tools Directory');
insert into sys_menu values('4', 'RuoYi Official', '0', '4', 'http://ruoyi.vip', null, '', '', 0, 0, 'M', '0', '0', '', 'guide',    'admin', sysdate(), '', null, 'Official Website Link');

-- Level 2 Menus
insert into sys_menu values('100', 'User Management', '1', '1', 'user',       'system/user/index',    '', '', 1, 0, 'C', '0', '0', 'system:user:list',    'user',          'admin', sysdate(), '', null, 'User Management Menu');
insert into sys_menu values('101', 'Role Management', '1', '2', 'role',       'system/role/index',    '', '', 1, 0, 'C', '0', '0', 'system:role:list',    'peoples',       'admin', sysdate(), '', null, 'Role Management Menu');
insert into sys_menu values('102', 'Menu Management', '1', '3', 'menu',       'system/menu/index',    '', '', 1, 0, 'C', '0', '0', 'system:menu:list',    'tree-table',    'admin', sysdate(), '', null, 'Menu Management Menu');
insert into sys_menu values('103', 'Dept Management', '1', '4', 'dept',       'system/dept/index',    '', '', 1, 0, 'C', '0', '0', 'system:dept:list',    'tree',          'admin', sysdate(), '', null, 'Department Management Menu');
insert into sys_menu values('104', 'Post Management', '1', '5', 'post',       'system/post/index',    '', '', 1, 0, 'C', '0', '0', 'system:post:list',    'post',          'admin', sysdate(), '', null, 'Post Management Menu');
insert into sys_menu values('105', 'Dict Management', '1', '6', 'dict',       'system/dict/index',    '', '', 1, 0, 'C', '0', '0', 'system:dict:list',    'dict',          'admin', sysdate(), '', null, 'Dictionary Management Menu');
insert into sys_menu values('106', 'Config Setting', '1', '7', 'config',     'system/config/index',  '', '', 1, 0, 'C', '0', '0', 'system:config:list',  'edit',          'admin', sysdate(), '', null, 'Config Setting Menu');
insert into sys_menu values('107', 'Notice/Announce', '1', '8', 'notice',     'system/notice/index',  '', '', 1, 0, 'C', '0', '0', 'system:notice:list',  'message',       'admin', sysdate(), '', null, 'Notification Menu');
insert into sys_menu values('108', 'Log Management', '1', '9', 'log',        '',                     '', '', 1, 0, 'M', '0', '0', '',                    'log',           'admin', sysdate(), '', null, 'Log Management Directory');
insert into sys_menu values('109', 'Online User',   '2', '1', 'online',     'monitor/online/index',  '', '', 1, 0, 'C', '0', '0', 'monitor:online:list',  'online',        'admin', sysdate(), '', null, 'Online User Menu');
insert into sys_menu values('110', 'Job Scheduler', '2', '2', 'job',        'monitor/job/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:job:list',     'job',           'admin', sysdate(), '', null, 'Scheduled Job Menu');
insert into sys_menu values('111', 'Data Monitor',  '2', '3', 'druid',      'monitor/druid/index',   '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list',   'druid',         'admin', sysdate(), '', null, 'Druid Data Monitor Menu');
insert into sys_menu values('112', 'Server Monitor', '2', '4', 'server',     'monitor/server/index',  '', '', 1, 0, 'C', '0', '0', 'monitor:server:list',  'server',        'admin', sysdate(), '', null, 'Server Status Menu');
insert into sys_menu values('113', 'Cache Monitor',  '2', '5', 'cache',      'monitor/cache/index',   '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',   'redis',         'admin', sysdate(), '', null, 'Redis Cache Monitor Menu');
insert into sys_menu values('114', 'Cache List',     '2', '6', 'cacheList',  'monitor/cache/list',    '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',   'redis-list',    'admin', sysdate(), '', null, 'Cache List Menu');
insert into sys_menu values('115', 'Form Builder',   '3', '1', 'build',      'tool/build/index',      '', '', 1, 0, 'C', '0', '0', 'tool:build:list',      'build',         'admin', sysdate(), '', null, 'Form Builder Menu');
insert into sys_menu values('116', 'Code Generator', '3', '2', 'gen',        'tool/gen/index',        '', '', 1, 0, 'C', '0', '0', 'tool:gen:list',        'code',          'admin', sysdate(), '', null, 'Code Generator Menu');
insert into sys_menu values('117', 'API Swagger',    '3', '3', 'swagger',    'tool/swagger/index',    '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list',    'swagger',       'admin', sysdate(), '', null, 'Swagger API Menu');

-- Level 3 Menus
insert into sys_menu values('500', 'Operation Log', '108', '1', 'operlog',    'monitor/operlog/index',    '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form',          'admin', sysdate(), '', null, 'Operation Log Menu');
insert into sys_menu values('501', 'Login Log',     '108', '2', 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor',  'admin', sysdate(), '', null, 'Login Log Menu');

-- User Management Buttons
insert into sys_menu values('1000', 'User Query',  '100', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1001', 'User Add',    '100', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1002', 'User Edit',   '100', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1003', 'User Remove', '100', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1004', 'User Export', '100', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1005', 'User Import', '100', '6',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1006', 'Reset PWD',   '100', '7',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd',       '#', 'admin', sysdate(), '', null, '');

-- ----------------------------
-- 6. User and Role Link Table (Many-to-Many)
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE sys_user_role (
  user_id   bigint(20) NOT NULL COMMENT 'User ID',
  role_id   bigint(20) NOT NULL COMMENT 'Role ID',
  PRIMARY KEY (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='User and Role Link Table';

INSERT INTO sys_user_role VALUES (1, 1);
INSERT INTO sys_user_role VALUES (2, 2);

-- Initial Data
insert into sys_user_role values ('1', '1');
insert into sys_user_role values ('2', '2');


-- ----------------------------
-- 7. Role and Menu Link Table (Many-to-Many)
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id   bigint(20) not null comment 'Role ID',
  menu_id   bigint(20) not null comment 'Menu ID',
  primary key(role_id, menu_id)
) engine=innodb comment = 'Role and Menu Link Table';

-- Mapping Common Role (ID: 2) to various permissions
insert into sys_role_menu values ('2', '1'), ('2', '2'), ('2', '3'), ('2', '4'), ('2', '100'), ('2', '101'), ('2', '102'), ('2', '103'), ('2', '104'), ('2', '105'), ('2', '106'), ('2', '107'), ('2', '108'), ('2', '109'), ('2', '110'), ('2', '111'), ('2', '112'), ('2', '113'), ('2', '114'), ('2', '115'), ('2', '116'), ('2', '117'), ('2', '500'), ('2', '501'), ('2', '1000'), ('2', '1001'), ('2', '1002'), ('2', '1003'), ('2', '1004'), ('2', '1005'), ('2', '1006'), ('2', '1007'), ('2', '1008'), ('2', '1009'), ('2', '1010'), ('2', '1011'), ('2', '1012'), ('2', '1013'), ('2', '1014'), ('2', '1015'), ('2', '1016'), ('2', '1017'), ('2', '1018'), ('2', '1019'), ('2', '1020'), ('2', '1021'), ('2', '1022'), ('2', '1023'), ('2', '1024'), ('2', '1025'), ('2', '1026'), ('2', '1027'), ('2', '1028'), ('2', '1029'), ('2', '1030'), ('2', '1031'), ('2', '1032'), ('2', '1033'), ('2', '1034'), ('2', '1035'), ('2', '1036'), ('2', '1037'), ('2', '1038'), ('2', '1039'), ('2', '1040'), ('2', '1041'), ('2', '1042'), ('2', '1043'), ('2', '1044'), ('2', '1045'), ('2', '1046'), ('2', '1047'), ('2', '1048'), ('2', '1049'), ('2', '1050'), ('2', '1051'), ('2', '1052'), ('2', '1053'), ('2', '1054'), ('2', '1055'), ('2', '1056'), ('2', '1057'), ('2', '1058'), ('2', '1059'), ('2', '1060');


-- ----------------------------
-- 8. Role and Dept Link Table
-- ----------------------------
drop table if exists sys_role_dept;
create table sys_role_dept (
  role_id   bigint(20) not null comment 'Role ID',
  dept_id   bigint(20) not null comment 'Dept ID',
  primary key(role_id, dept_id)
) engine=innodb comment = 'Role and Dept Link Table';

insert into sys_role_dept values ('2', '100'), ('2', '101'), ('2', '105');


-- ----------------------------
-- 9. User and Post Link Table
-- ----------------------------
drop table if exists sys_user_post;
create table sys_user_post
(
  user_id   bigint(20) not null comment 'User ID',
  post_id   bigint(20) not null comment 'Post ID',
  primary key (user_id, post_id)
) engine=innodb comment = 'User and Post Link Table';

insert into sys_user_post values ('1', '1'), ('2', '2');


-- ----------------------------
-- 10. Operation Log Table
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  oper_id           bigint(20)      not null auto_increment    comment 'Log ID',
  title             varchar(50)     default ''                 comment 'Module Title',
  business_type     int(2)          default 0                  comment 'Business Type (0=Other, 1=Insert, 2=Update, 3=Delete)',
  method            varchar(200)    default ''                 comment 'Method Name',
  request_method    varchar(10)     default ''                 comment 'Request Method',
  operator_type     int(1)          default 0                  comment 'Operator Type (0=Other, 1=Backend, 2=Mobile)',
  oper_name         varchar(50)     default ''                 comment 'Operator Name',
  dept_name         varchar(50)     default ''                 comment 'Dept Name',
  oper_url          varchar(255)    default ''                 comment 'Request URL',
  oper_ip           varchar(128)    default ''                 comment 'IP Address',
  oper_location     varchar(255)    default ''                 comment 'Location',
  oper_param        varchar(2000)   default ''                 comment 'Request Param',
  json_result       varchar(2000)   default ''                 comment 'JSON Result',
  status            int(1)          default 0                  comment 'Status (0=Normal, 1=Abnormal)',
  error_msg         varchar(2000)   default ''                 comment 'Error Message',
  oper_time         datetime                                   comment 'Operation Time',
  cost_time         bigint(20)      default 0                  comment 'Elapsed Time (ms)',
  primary key (oper_id),
  key idx_sys_oper_log_bt (business_type),
  key idx_sys_oper_log_s  (status),
  key idx_sys_oper_log_ot (oper_time)
) engine=innodb auto_increment=100 comment = 'Operation Log Table';


-- ----------------------------
-- 11. Dictionary Type Table
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
  dict_id          bigint(20)      not null auto_increment    comment 'Dict ID',
  dict_name        varchar(100)    default ''                 comment 'Dictionary Name',
  dict_type        varchar(100)    default ''                 comment 'Dictionary Type',
  status           char(1)         default '0'                comment 'Status (0=Normal, 1=Disabled)',
  create_by        varchar(64)     default ''                 comment 'Creator',
  create_time      datetime                                   comment 'Create Time',
  update_by        varchar(64)     default ''                 comment 'Updater',
  update_time      datetime                                   comment 'Update Time',
  remark           varchar(500)    default null               comment 'Remark',
  primary key (dict_id),
  unique (dict_type)
) engine=innodb auto_increment=100 comment = 'Dictionary Type Table';

insert into sys_dict_type values(1,  'User Gender', 'sys_user_sex',        '0', 'admin', sysdate(), '', null, 'User Gender List');
insert into sys_dict_type values(2,  'Menu Status', 'sys_show_hide',       '0', 'admin', sysdate(), '', null, 'Menu Status List');
insert into sys_dict_type values(3,  'System Switch', 'sys_normal_disable',  '0', 'admin', sysdate(), '', null, 'System Switch List');
insert into sys_dict_type values(4,  'Job Status', 'sys_job_status',      '0', 'admin', sysdate(), '', null, 'Job Status List');
insert into sys_dict_type values(5,  'Job Group', 'sys_job_group',       '0', 'admin', sysdate(), '', null, 'Job Group List');
insert into sys_dict_type values(6,  'System Yes/No', 'sys_yes_no',          '0', 'admin', sysdate(), '', null, 'System Yes/No List');
insert into sys_dict_type values(7,  'Notice Type', 'sys_notice_type',     '0', 'admin', sysdate(), '', null, 'Notice Type List');
insert into sys_dict_type values(8,  'Notice Status', 'sys_notice_status',   '0', 'admin', sysdate(), '', null, 'Notice Status List');
insert into sys_dict_type values(9,  'Operation Type', 'sys_oper_type',       '0', 'admin', sysdate(), '', null, 'Operation Type List');
insert into sys_dict_type values(10, 'System Status', 'sys_common_status',   '0', 'admin', sysdate(), '', null, 'Login Status List');



-- ----------------------------
-- 12. Dictionary Data Table
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
  dict_code        bigint(20)      not null auto_increment    comment 'Dict Code',
  dict_sort        int(4)          default 0                  comment 'Sort Order',
  dict_label       varchar(100)    default ''                 comment 'Dict Label',
  dict_value       varchar(100)    default ''                 comment 'Dict Value',
  dict_type        varchar(100)    default ''                 comment 'Dict Type',
  css_class        varchar(100)    default null               comment 'CSS Class',
  list_class       varchar(100)    default null               comment 'List Class',
  is_default       char(1)         default 'N'                comment 'Is Default (Y/N)',
  status           char(1)         default '0'                comment 'Status (0=Normal, 1=Disabled)',
  create_by        varchar(64)     default ''                 comment 'Creator',
  create_time      datetime                                   comment 'Create Time',
  update_by        varchar(64)     default ''                 comment 'Updater',
  update_time      datetime                                   comment 'Update Time',
  remark           varchar(500)    default null               comment 'Remark',
  primary key (dict_code)
) engine=innodb auto_increment=100 comment = 'Dictionary Data Table';

-- Gender
insert into sys_dict_data values(1, 1, 'Male',    '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', sysdate(), '', null, 'Gender Male');
insert into sys_dict_data values(2, 2, 'Female',  '1', 'sys_user_sex', '', '', 'N', '0', 'admin', sysdate(), '', null, 'Gender Female');
insert into sys_dict_data values(3, 3, 'Unknown', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', sysdate(), '', null, 'Gender Unknown');
-- Menu Visibility
insert into sys_dict_data values(4, 1, 'Show',    '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, 'Show Menu');
insert into sys_dict_data values(5, 2, 'Hide',    '1', 'sys_show_hide', '', 'danger',  'N', '0', 'admin', sysdate(), '', null, 'Hide Menu');
-- Status
insert into sys_dict_data values(6, 1, 'Normal',  '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, 'Normal Status');
insert into sys_dict_data values(7, 2, 'Disable', '1', 'sys_normal_disable', '', 'danger',  'N', '0', 'admin', sysdate(), '', null, 'Disabled Status');
-- Job Status
insert into sys_dict_data values(8, 1, 'Normal',  '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, 'Job Normal');
insert into sys_dict_data values(9, 2, 'Pause',   '1', 'sys_job_status', '', 'danger',  'N', '0', 'admin', sysdate(), '', null, 'Job Paused');
-- Job Group
insert into sys_dict_data values(10, 1, 'Default', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', sysdate(), '', null, 'Default Group');
insert into sys_dict_data values(11, 2, 'System',  'SYSTEM',  'sys_job_group', '', '', 'N', '0', 'admin', sysdate(), '', null, 'System Group');
-- Yes/No
insert into sys_dict_data values(12, 1, 'Yes', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, 'System Yes');
insert into sys_dict_data values(13, 2, 'No',  'N', 'sys_yes_no', '', 'danger',  'N', '0', 'admin', sysdate(), '', null, 'System No');
-- Notice Type
insert into sys_dict_data values(14, 1, 'Notice', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', sysdate(), '', null, 'Notice');
insert into sys_dict_data values(15, 2, 'Announcement', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', sysdate(), '', null, 'Announcement');
-- Oper Type
insert into sys_dict_data values(19, 1, 'Insert', '1', 'sys_oper_type', '', 'info',    'N', '0', 'admin', sysdate(), '', null, 'Insert Operation');
insert into sys_dict_data values(20, 2, 'Update', '2', 'sys_oper_type', '', 'info',    'N', '0', 'admin', sysdate(), '', null, 'Update Operation');
insert into sys_dict_data values(21, 3, 'Delete', '3', 'sys_oper_type', '', 'danger',  'N', '0', 'admin', sysdate(), '', null, 'Delete Operation');
insert into sys_dict_data values(28, 1, 'Success', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', sysdate(), '', null, 'Success Status');
insert into sys_dict_data values(29, 2, 'Fail',    '1', 'sys_common_status', '', 'danger',  'N', '0', 'admin', sysdate(), '', null, 'Fail Status');


-- ----------------------------
-- 13. Config Table
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  config_id         int(5)          not null auto_increment    comment 'Config ID',
  config_name       varchar(100)    default ''                 comment 'Config Name',
  config_key        varchar(100)    default ''                 comment 'Config Key',
  config_value      varchar(500)    default ''                 comment 'Config Value',
  config_type       char(1)         default 'N'                comment 'Is Built-in (Y/N)',
  create_by         varchar(64)     default ''                 comment 'Creator',
  create_time       datetime                                   comment 'Create Time',
  update_by         varchar(64)     default ''                 comment 'Updater',
  update_time       datetime                                   comment 'Update Time',
  remark            varchar(500)    default null               comment 'Remark',
  primary key (config_id)
) engine=innodb auto_increment=100 comment = 'Configuration Table';

insert into sys_config values(1, 'Main Frame Skin', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', sysdate(), '', null, 'Blue: skin-blue, Green: skin-green, Purple: skin-purple, Red: skin-red, Yellow: skin-yellow' );
insert into sys_config values(2, 'User Init Password', 'sys.user.initPassword', '123456', 'Y', 'admin', sysdate(), '', null, 'Initial password 123456' );
insert into sys_config values(3, 'Sidebar Theme', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', sysdate(), '', null, 'Dark: theme-dark, Light: theme-light' );
insert into sys_config values(4, 'Captcha Enabled', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', sysdate(), '', null, 'Whether to enable captcha');


-- ----------------------------
-- 14. Login Information Table
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id        bigint(20)     not null auto_increment   comment 'Access ID',
  user_name      varchar(50)    default ''                comment 'Username',
  ipaddr         varchar(128)   default ''                comment 'IP Address',
  login_location varchar(255)   default ''                comment 'Login Location',
  browser        varchar(50)    default ''                comment 'Browser Type',
  os             varchar(50)    default ''                comment 'OS',
  status         char(1)        default '0'               comment 'Login Status (0=Success, 1=Fail)',
  msg            varchar(255)   default ''                comment 'Message',
  login_time     datetime                                 comment 'Access Time',
  primary key (info_id),
  key idx_sys_logininfor_s  (status),
  key idx_sys_logininfor_lt (login_time)
) engine=innodb auto_increment=100 comment = 'Login Information Table';

-- ----------------------------
-- 15. Scheduled Job Table
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id              bigint(20)    not null auto_increment    comment 'Job ID',
  job_name            varchar(64)   default ''                 comment 'Job Name',
  job_group           varchar(64)   default 'DEFAULT'          comment 'Job Group',
  invoke_target       varchar(500)  not null                   comment 'Invoke Target String',
  cron_expression     varchar(255)  default ''                 comment 'Cron Expression',
  misfire_policy      varchar(20)   default '3'                comment 'Misfire Policy (1=Execute Immediately, 2=Execute Once, 3=Discard)',
  concurrent          char(1)       default '1'                comment 'Concurrent Execution (0=Allow, 1=Forbid)',
  status              char(1)       default '0'                comment 'Status (0=Normal, 1=Paused)',
  create_by           varchar(64)   default ''                 comment 'Creator',
  create_time         datetime                                   comment 'Create Time',
  update_by           varchar(64)   default ''                 comment 'Updater',
  update_time         datetime                                   comment 'Update Time',
  remark              varchar(500)  default ''                 comment 'Remark',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 comment = 'Scheduled Job Table';

-- Initial Tasks
insert into sys_job values(1, 'System Default (No Params)', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(2, 'System Default (With Params)', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 16. Scheduled Job Log Table
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          bigint(20)     not null auto_increment    comment 'Job Log ID',
  job_name            varchar(64)    not null                   comment 'Job Name',
  job_group           varchar(64)    not null                   comment 'Job Group',
  invoke_target       varchar(500)   not null                   comment 'Invoke Target String',
  job_message         varchar(500)                              comment 'Log Message',
  status              char(1)        default '0'                comment 'Status (0=Normal, 1=Fail)',
  exception_info      varchar(2000)  default ''                 comment 'Exception Info',
  create_time         datetime                                  comment 'Create Time',
  primary key (job_log_id)
) engine=innodb comment = 'Scheduled Job Log Table';


-- ----------------------------
-- 17. Notice and Announcement Table
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id         int(4)          not null auto_increment    comment 'Notice ID',
  notice_title      varchar(50)     not null                   comment 'Notice Title',
  notice_type       char(1)         not null                   comment 'Notice Type (1=Notification, 2=Announcement)',
  notice_content    longblob        default null               comment 'Notice Content',
  status            char(1)         default '0'                comment 'Status (0=Normal, 1=Closed)',
  create_by         varchar(64)     default ''                 comment 'Creator',
  create_time       datetime                                   comment 'Create Time',
  update_by         varchar(64)     default ''                 comment 'Updater',
  update_time       datetime                                   comment 'Update Time',
  remark            varchar(255)    default null               comment 'Remark',
  primary key (notice_id)
) engine=innodb auto_increment=10 comment = 'Notice Table';

-- Initial Data
insert into sys_notice values('1', 'Reminder: RuoYi New Version Released', '2', 'Content of new version', '0', 'admin', sysdate(), '', null, 'Admin');
insert into sys_notice values('2', 'Maintenance: System maintenance at midnight', '1', 'Maintenance details', '0', 'admin', sysdate(), '', null, 'Admin');


-- ----------------------------
-- 18. Code Gen Table (Gen Table)
-- ----------------------------
drop table if exists gen_table;
create table gen_table (
  table_id          bigint(20)      not null auto_increment    comment 'ID',
  table_name        varchar(200)    default ''                 comment 'Table Name',
  table_comment     varchar(500)    default ''                 comment 'Table Description',
  sub_table_name    varchar(64)     default null               comment 'Sub-table Name',
  sub_table_fk_name varchar(64)     default null               comment 'Sub-table Foreign Key',
  class_name        varchar(100)    default ''                 comment 'Entity Class Name',
  tpl_category      varchar(200)    default 'crud'             comment 'Template Category (crud/tree)',
  tpl_web_type      varchar(30)     default ''                 comment 'Web Template Type (element-ui/element-plus)',
  package_name      varchar(100)                               comment 'Package Path',
  module_name       varchar(30)                                comment 'Module Name',
  business_name     varchar(30)                                comment 'Business Name',
  function_name     varchar(50)                                comment 'Function Name',
  function_author   varchar(50)                                comment 'Author',
  gen_type          char(1)         default '0'                comment 'Gen Way (0=zip, 1=custom path)',
  gen_path          varchar(200)    default '/'                comment 'Gen Path',
  options           varchar(1000)                              comment 'Other Options',
  create_by         varchar(64)     default ''                 comment 'Creator',
  create_time       datetime                                   comment 'Create Time',
  update_by         varchar(64)     default ''                 comment 'Updater',
  update_time       datetime                                   comment 'Update Time',
  remark            varchar(500)    default null               comment 'Remark',
  primary key (table_id)
) engine=innodb auto_increment=1 comment = 'Code Generation Business Table';


-- ----------------------------
-- 19. Code Gen Table Column (Gen Table Column)
-- ----------------------------
drop table if exists gen_table_column;
create table gen_table_column (
  column_id         bigint(20)      not null auto_increment    comment 'ID',
  table_id          bigint(20)                                 comment 'Table ID',
  column_name       varchar(200)                               comment 'Column Name',
  column_comment    varchar(500)                               comment 'Column Description',
  column_type       varchar(100)                               comment 'Column Type',
  java_type         varchar(500)                               comment 'JAVA Type',
  java_field        varchar(200)                               comment 'JAVA Field Name',
  is_pk             char(1)                                    comment 'Is Primary Key (1=Yes)',
  is_increment      char(1)                                    comment 'Is Increment (1=Yes)',
  is_required       char(1)                                    comment 'Is Required (1=Yes)',
  is_insert         char(1)                                    comment 'Is Insert Field (1=Yes)',
  is_edit           char(1)                                    comment 'Is Edit Field (1=Yes)',
  is_list           char(1)                                    comment 'Is List Field (1=Yes)',
  is_query          char(1)                                    comment 'Is Query Field (1=Yes)',
  query_type        varchar(200)    default 'EQ'               comment 'Query Type (EQ, NE, GT, LT, LIKE, BETWEEN)',
  html_type         varchar(200)                               comment 'HTML Type (input, textarea, select, checkbox, radio, datetime)',
  dict_type         varchar(200)    default ''                 comment 'Dict Type',
  sort              int                                        comment 'Sort',
  create_by         varchar(64)     default ''                 comment 'Creator',
  create_time       datetime                                   comment 'Create Time',
  update_by         varchar(64)     default ''                 comment 'Updater',
  update_time       datetime                                   comment 'Update Time',
  primary key (column_id)
) engine=innodb auto_increment=1 comment = 'Code Generation Column Table';


drop table if exists product;
create table product(
	product_id bigint(20) not null auto_increment comment 'product id',
	barcode varchar(100) not null comment 'product barcode',
	product_name varchar(200),
	PRIMARY key(product_id)
) engine=innodb auto_increment=1 comment = 'Code Generation Column Table';

INSERT INTO product (barcode, product_name) VALUES 
('880123456701', 'Apple iPhone 15 Pro Silicone Case - Black'),
('880123456702', 'Samsung T7 Shield 1TB Portable SSD'),
('880123456703', 'Logitech MX Master 3S Wireless Mouse'),
('880123456704', 'Sony WH-1000XM5 Noise Canceling Headphones'),
('880123456705', 'Dell UltraSharp 27" 4K USB-C Hub Monitor'),
('880123456706', 'Moleskine Classic Notebook, Hard Cover, Large'),
('880123456707', 'Parker Jotter Stainless Steel Ballpoint Pen'),
('880123456708', 'Kindle Paperwhite (16 GB) - 6.8" Display'),
('880123456709', 'Nespresso Vertuo Coffee and Espresso Maker'),
('880123456710', 'Hydro Flask 32 oz Wide Mouth Water Bottle'),
('880123456711', 'Listerine Cool Mint Antiseptic Mouthwash'),
('880123456712', 'Colgate Total Whitening Toothpaste 2-Pack'),
('880123456713', 'Neutrogena Hydro Boost Water Gel Moisturizer'),
('880123456714', 'Old Spice High Endurance Deodorant for Men'),
('880123456715', 'Oatly Oat Milk Barista Edition 1L'),
('880123456716', 'Kind Protein Bars, Crunchy Peanut Butter'),
('880123456717', 'SanDisk 128GB Extreme microSDXC Card'),
('880123456718', 'Anker 735 Charger (GaNPrime 65W)'),
('880123456719', 'Philips Hue White and Color Ambiance Bulb'),
('880123456720', 'Fitbit Charge 6 Fitness Tracker');