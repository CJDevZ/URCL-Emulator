FROM python:3.14-alpine

WORKDIR /web

COPY web/requirements.txt .
RUN pip install --no-cache-dir -r ./requirements.txt

COPY web/ .

EXPOSE 5000

CMD ["python", "main.py"]