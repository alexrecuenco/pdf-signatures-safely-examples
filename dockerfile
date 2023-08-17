FROM python:3.10-alpine

WORKDIR /app
RUN  pip install --upgrade pip

# required for cffi
RUN apk add --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev libffi-dev
COPY requirements.txt ./
RUN pip install -r requirements.txt

# COPY . ./ Verifies if uncommented that nothing expect requirements.txt is added to the context
CMD [ "/bin/sh" ]
