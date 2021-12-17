FROM ubuntu
ARG app_username
ARG app_password
ENV APP_USERNAME=$app_username
ENV APP_PASSWORD=$app_password
COPY week10.txt /
CMD ["sh", "-c", "echo $APP_USERNAME $APP_PASSWORD | tee >> /week10.txt && sleep 1000"]
