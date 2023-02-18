Eramaba Community (c.2.8.1) in Docker
--------------------------------
# This is no longer supported!!!
## Eramba has published their own docker images, see https://www.eramba.org/get-community
1. Clone this repo and cd into it
2. Copy `docker-compose-template.yml` to `docker-compose.yml`
3. Update the `MYSQL_ROOT_PASSWORD` in `docker-compose.yml`
4. Create file `global_envars.cfg` with the following (updating credntials):
    `MYSQL_DATABASE=erambadb
    MYSQL_USER=eramba
    MYSQL_PASSWORD=changemetoo`
5. Run `sh ./prep_host_directory_struct.sh` - this creates /data/eramba/<several_dirs>, if you want to change the host data dir, ensure you update the docker-compose.yml also
6. Run `docker-compose up -d` - this will start containers in the background
7. On first time start, you need to create the database tables, to do this run `sh ./create_db_tables.sh`
8. You should now be able to load the initial login page via a browser, i.e.: http://localhost/

## Timer jobs
Eramba has 3 cron/timer jobs, hourly, daily and yearly.
As many docker users will be using coreos / operating systems without cron tabs, systemd jobs and timers can be used to run these jobs.
Assuming you retain the standard directory paths and container names, you can simply run `sudo ./deploy_cron_services.sh` - look at the contents of that script and the `cron` directory if experiencing issues and try running the eramba_test.sh script.
These jobs use the cli cron type (so in the settings of the web interface ensure CLI is chosen, not Web for cron jobs).

## Upgrade applied then new container built (DB and APP version mismatch)
By default your deployment will start with c2.8.1 of eramba community.
Periodically eramba.org will releae updates which can be applied via the setting page in the web app.
If you do upgrade then the app container is lost, your DB will be stuck on a new version (say c2.8.2) but the new app container will start back at 2.8.1 (which wont work well if there were schema changes to the database between those releases).
If that occurs specify the desired version of the container in your docker-compose.yml, e.g.: `image: markz0r/eramba-app` becomes `image: markz0r/eramba-app:c282`; this is dependent on the maintainer completing a new docker image in a timely fashion.

## Fixing missing future review/audits
- An issue can occur in eramba where future reviews/audits are not created 
    - Presumed cause is someone has used SQL queries to complete previou reviews/audits in bulk which does not create the next audits and update mapping (whcih is done by applicaiton code)
    - Actual cause may be that policies are in draft status or have no owner/reviewer assigned
*To Fix*
## If policies/objects in draft status or have no owner/reviewer
- Simply update the object via the web interface and reviews future will be generated
## If caused by broken sql queries
1. Get into database
```
 docker exec -ti eramba-community-docker_db_1 bash
 printenv
 mysql -p
 # enter $MYSQL_ROOT_PASSWORD
 use erambadb
 show tables
```
## key tables: 
 - audits (no relevant FKs)
 - reviews (no relevant FKs)
 - security_policy_reviews 
    - (`security_policy_id`) REFERENCES `security_policies` (`id`)
```

MariaDB [erambadb]> desc security_policies;
+----------------------------------+---------------------------------------+------+-----+---------+----------------+
| Field                            | Type                                  | Null | Key | Default | Extra          |
+----------------------------------+---------------------------------------+------+-----+---------+----------------+
| id                               | int(11)                               | NO   | PRI | NULL    | auto_increment |
| index                            | varchar(100)                          | NO   | MUL | NULL    |                |
| short_description                | varchar(255)                          | NO   |     | NULL    |                |
| description                      | text                                  | YES  |     | NULL    |                |
| url                              | text                                  | YES  |     | NULL    |                |
| use_attachments                  | int(1)                                | NO   |     | 0       |                |
| document_type                    | enum('policy','standard','procedure') | NO   |     | NULL    |                |
| security_policy_document_type_id | int(11)                               | YES  | MUL | NULL    |                |
| version                          | varchar(50)                           | NO   |     | NULL    |                |
| published_date                   | date                                  | NO   |     | NULL    |                |
| next_review_date                 | date                                  | NO   |     | NULL    |                |
| permission                       | enum('public','private','logged')     | NO   |     | NULL    |                |
| ldap_connector_id                | int(11)                               | YES  | MUL | NULL    |                |
| asset_label_id                   | int(11)                               | YES  | MUL | NULL    |                |
| status                           | int(1)                                | NO   |     | 0       |                |
| expired_reviews                  | int(1)                                | NO   |     | 0       |                |
| hash                             | varchar(255)                          | YES  |     | NULL    |                |
| workflow_owner_id                | int(11)                               | YES  |     | NULL    |                |
| workflow_status                  | int(1)                                | NO   |     | 0       |                |
| created                          | datetime                              | NO   |     | NULL    |                |
| modified                         | datetime                              | NO   |     | NULL    |                |
| edited                           | datetime                              | YES  |     | NULL    |                |
| deleted                          | int(2)                                | NO   |     | 0       |                |
| deleted_date                     | datetime                              | YES  |     | NULL    |                |
+----------------------------------+---------------------------------------+------+-----+---------+----------------+
MariaDB [erambadb]> desc reviews;
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | int(11)      | NO   | PRI | NULL    | auto_increment |
| model              | varchar(150) | NO   |     | NULL    |                |
| foreign_key        | int(11)      | NO   |     | NULL    |                |
| planned_date       | date         | YES  |     | NULL    |                |
| actual_date        | date         | YES  |     | NULL    |                |
| user_id            | int(11)      | YES  | MUL | NULL    |                |
| description        | text         | NO   |     | NULL    |                |
| completed          | int(1)       | NO   |     | 0       |                |
| use_attachments    | int(11)      | YES  |     | NULL    |                |
| policy_description | text         | YES  |     | NULL    |                |
| url                | text         | YES  |     | NULL    |                |
| version            | varchar(150) | YES  |     | NULL    |                |
| workflow_owner_id  | int(11)      | YES  |     | NULL    |                |
| workflow_status    | int(1)       | NO   |     | 0       |                |
| created            | datetime     | NO   |     | NULL    |                |
| modified           | datetime     | NO   |     | NULL    |                |
| edited             | datetime     | YES  |     | NULL    |                |
| deleted            | int(2)       | NO   |     | 0       |                |
| deleted_date       | datetime     | YES  |     | NULL    |                |
+--------------------+--------------+------+-----+---------+----------------+
select distinct(model) from reviews;
+----------------+
| model          |
+----------------+
| SecurityPolicy |
| Asset          |
| Risk           |
| ThirdPartyRisk |
+----------------+
```
- Security Policies DOES NOTE USE `security_policy_reviews`... it uses ?:
```
-- Assumes your relevant policy ID is 26
select * from reviews where model = 'SecurityPolicy' and foreign_key = 26;

insert into reviews (model, foreign_key, planned_date, completed, workflow_status, created, modified, deleted)
VALUES ('SecurityPolicy',1,'2023-01-15',0,0,now(),now(),0);
update security_policies set next_review_date = '2023-01-15' where id = 1;
update security_policies set next_review_date = '2022-10-08' where id = 1;

```


## Other potentially relevant
 - business_continuity_plan_audits
 - compliance_audits
 - goal_audits
 - risks
 - security_service_audits