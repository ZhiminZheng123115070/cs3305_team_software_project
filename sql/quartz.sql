CREATE DATABASE `ry-vue`;
USE `ry-vue`;
DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- ----------------------------
-- 1. QRTZ_JOB_DETAILS: Stores detailed information for each configured JobDetail
-- ----------------------------
create table QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    job_name             varchar(200)    not null            comment 'Job Name',
    job_group            varchar(200)    not null            comment 'Job Group Name',
    description          varchar(250)    null                comment 'Description',
    job_class_name       varchar(250)    not null            comment 'Execution Job Class Name',
    is_durable           varchar(1)      not null            comment 'Is Durable',
    is_nonconcurrent     varchar(1)      not null            comment 'Is Non-Concurrent',
    is_update_data       varchar(1)      not null            comment 'Is Update Data',
    requests_recovery    varchar(1)      not null            comment 'Is Requests Recovery',
    job_data             blob            null                comment 'Persistent Job Data Object',
    primary key (sched_name, job_name, job_group)
) engine=innodb comment = 'Job Detail Information Table';

-- ----------------------------
-- 2. QRTZ_TRIGGERS: Stores information for configured Triggers
-- ----------------------------
create table QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    trigger_name         varchar(200)    not null            comment 'Trigger Name',
    trigger_group        varchar(200)    not null            comment 'Trigger Group Name',
    job_name             varchar(200)    not null            comment 'Foreign key to job_name in QRTZ_JOB_DETAILS',
    job_group            varchar(200)    not null            comment 'Foreign key to job_group in QRTZ_JOB_DETAILS',
    description          varchar(250)    null                comment 'Description',
    next_fire_time       bigint(13)      null                comment 'Next Fire Time (milliseconds)',
    prev_fire_time       bigint(13)      null                comment 'Previous Fire Time (milliseconds, -1 means no trigger)',
    priority             integer         null                comment 'Priority',
    trigger_state        varchar(16)     not null            comment 'Trigger State',
    trigger_type         varchar(8)      not null            comment 'Trigger Type',
    start_time           bigint(13)      not null            comment 'Start Time',
    end_time             bigint(13)      null                comment 'End Time',
    calendar_name        varchar(200)    null                comment 'Calendar Name',
    misfire_instr        smallint(2)     null                comment 'Misfire Instruction Strategy',
    job_data             blob            null                comment 'Persistent Job Data Object',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
) engine=innodb comment = 'Trigger Detailed Information Table';

-- ----------------------------
-- 3. QRTZ_SIMPLE_TRIGGERS: Stores simple Triggers including repeat counts and intervals
-- ----------------------------
create table QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    trigger_name         varchar(200)    not null            comment 'Foreign key to trigger_name in QRTZ_TRIGGERS',
    trigger_group        varchar(200)    not null            comment 'Foreign key to trigger_group in QRTZ_TRIGGERS',
    repeat_count         bigint(7)       not null            comment 'Repeat Count',
    repeat_interval      bigint(12)      not null            comment 'Repeat Interval',
    times_triggered      bigint(10)      not null            comment 'Number of times triggered',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Simple Trigger Information Table';

-- ----------------------------
-- 4. QRTZ_CRON_TRIGGERS: Stores Cron Triggers including expressions and time zone info
-- ---------------------------- 
create table QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    trigger_name         varchar(200)    not null            comment 'Foreign key to trigger_name in QRTZ_TRIGGERS',
    trigger_group        varchar(200)    not null            comment 'Foreign key to trigger_group in QRTZ_TRIGGERS',
    cron_expression      varchar(200)    not null            comment 'Cron Expression',
    time_zone_id         varchar(80)                         comment 'Time Zone ID',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Cron Type Trigger Table';

-- ----------------------------
-- 5. QRTZ_BLOB_TRIGGERS: Stores custom Trigger types as Blob
-- ---------------------------- 
create table QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    trigger_name         varchar(200)    not null            comment 'Foreign key to trigger_name in QRTZ_TRIGGERS',
    trigger_group        varchar(200)    not null            comment 'Foreign key to trigger_group in QRTZ_TRIGGERS',
    blob_data            blob            null                comment 'Persistent Trigger Data Object',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Blob Type Trigger Table';

-- ----------------------------
-- 6. QRTZ_CALENDARS: Stores calendar information for specifying time ranges
-- ---------------------------- 
create table QRTZ_CALENDARS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    calendar_name        varchar(200)    not null            comment 'Calendar Name',
    calendar             blob            not null            comment 'Persistent Calendar Data Object',
    primary key (sched_name, calendar_name)
) engine=innodb comment = 'Calendar Information Table';

-- ----------------------------
-- 7. QRTZ_PAUSED_TRIGGER_GRPS: Stores information for paused Trigger groups
-- ---------------------------- 
create table QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    trigger_group        varchar(200)    not null            comment 'Foreign key to trigger_group in QRTZ_TRIGGERS',
    primary key (sched_name, trigger_group)
) engine=innodb comment = 'Paused Trigger Group Table';

-- ----------------------------
-- 8. QRTZ_FIRED_TRIGGERS: Stores status of fired Triggers and associated Job execution info
-- ---------------------------- 
create table QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    entry_id             varchar(95)     not null            comment 'Scheduler Instance Entry ID',
    trigger_name         varchar(200)    not null            comment 'Foreign key to trigger_name in QRTZ_TRIGGERS',
    trigger_group        varchar(200)    not null            comment 'Foreign key to trigger_group in QRTZ_TRIGGERS',
    instance_name        varchar(200)    not null            comment 'Scheduler Instance Name',
    fired_time           bigint(13)      not null            comment 'Fired Time',
    sched_time           bigint(13)      not null            comment 'Scheduled Time',
    priority             integer         not null            comment 'Priority',
    state                varchar(16)     not null            comment 'State',
    job_name             varchar(200)    null                comment 'Job Name',
    job_group            varchar(200)    null                comment 'Job Group Name',
    is_nonconcurrent     varchar(1)      null                comment 'Is Non-Concurrent',
    requests_recovery    varchar(1)      null                comment 'Is Requests Recovery',
    primary key (sched_name, entry_id)
) engine=innodb comment = 'Fired Trigger Table';

-- ----------------------------
-- 9. QRTZ_SCHEDULER_STATE: Stores state information for Scheduler instances in a cluster
-- ---------------------------- 
create table QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    instance_name        varchar(200)    not null            comment 'Instance Name',
    last_checkin_time    bigint(13)      not null            comment 'Last Check-in Time',
    checkin_interval     bigint(13)      not null            comment 'Check-in Interval',
    primary key (sched_name, instance_name)
) engine=innodb comment = 'Scheduler State Table';

-- ----------------------------
-- 10. QRTZ_LOCKS: Stores pessimistic lock information
-- ---------------------------- 
create table QRTZ_LOCKS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    lock_name            varchar(40)     not null            comment 'Lock Name',
    primary key (sched_name, lock_name)
) engine=innodb comment = 'Pessimistic Lock Information Table';

-- ----------------------------
-- 11. QRTZ_SIMPROP_TRIGGERS: Row-level lock table for cluster synchronization
-- ---------------------------- 
create table QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null            comment 'Scheduler Name',
    trigger_name         varchar(200)    not null            comment 'Foreign key to trigger_name in QRTZ_TRIGGERS',
    trigger_group        varchar(200)    not null            comment 'Foreign key to trigger_group in QRTZ_TRIGGERS',
    str_prop_1           varchar(512)    null                comment 'String property 1',
    str_prop_2           varchar(512)    null                comment 'String property 2',
    str_prop_3           varchar(512)    null                comment 'String property 3',
    int_prop_1           int             null                comment 'Integer property 1',
    int_prop_2           int             null                comment 'Integer property 2',
    long_prop_1          bigint          null                comment 'Long property 1',
    long_prop_2          bigint          null                comment 'Long property 2',
    dec_prop_1           numeric(13,4)   null                comment 'Decimal property 1',
    dec_prop_2           numeric(13,4)   null                comment 'Decimal property 2',
    bool_prop_1          varchar(1)      null                comment 'Boolean property 1',
    bool_prop_2          varchar(1)      null                comment 'Boolean property 2',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Synchronization Mechanism Lock Table';

commit;