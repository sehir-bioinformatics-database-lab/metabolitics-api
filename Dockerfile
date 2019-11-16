FROM python:3.5.2

ENV CELERY_BROKER_URL redis://redis:6379/
ENV CELERY_RESULT_BACKEND redis://redis:6379/

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# copy source code
COPY . /app
WORKDIR /app


RUN pip install --upgrade pip


# install requirements
RUN pip install -r requirements.txt

WORKDIR /app/src

# expose the app port
EXPOSE 5000

RUN python main.py generate-secret

COPY ./entrypoint.sh /app/src
COPY . /app/src


# run the app server
CMD gunicorn --bind 0.0.0.0:5000 --workers=10 app:app
