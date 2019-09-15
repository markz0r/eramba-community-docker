Eramaba Community 2019 in Docker
--------------------------------
1. Clone this repo and cd into it
2. Update the `MYSQL_ROOT_PASSWORD` in `docker-compose.yml`
3. Update `MYSQL_PASSWORD` in `global_envars.cfg`
4. Run `sh ./prep_host_directory_struct.sh` - this creates /data/eramba/<several_dirs>, if you want to change the host data dir, ensure you update the docker-compose.yml also
5. Run `docker-compose up -d` - this will start containers in the background
6. On first time start, you need to create the database tables, to do this run `sh ./create_db_tables.sh`
7. You should now be able to load the initial login page via a browser, i.e.: http://localhost/
