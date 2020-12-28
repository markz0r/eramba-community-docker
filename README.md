Eramaba Community (c.2.8.1) in Docker
--------------------------------
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
