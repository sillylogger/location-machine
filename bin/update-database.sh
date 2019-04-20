#!/usr/bin/env bash

heroku pg:backups:capture
mv -f db/production.bak db/production-last.bak
wget `heroku pg:backups:url` -O db/production.bak
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d location-machine-sql-development ./db/production.bak

printf "\n\n"
printf "Don't forget:\n\n"
printf "\tChange config/environments/development.rb\n"
printf "\t\t\`config.active_storage.service = :google\` if you want to see images.\n\n"
printf "\tSetting.where(name: 'site.host').delete_all\n"
printf "\n\n"

