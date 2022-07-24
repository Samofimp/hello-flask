FROM python:3
WORKDIR /app
COPY *.py requirements.txt ./
RUN pip install -r requirements.txt
ENTRYPOINT [ "python", "add-build-num.py" ]
