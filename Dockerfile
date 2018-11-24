FROM python:2.7-stretch

RUN mkdir /root/aws-iot-demo
WORKDIR /root/aws-iot-demo
ADD ./cert  cert
ADD ./scripts/publish.py publish.py
ADD ./requirements.txt requirements.txt

RUN pip install -r requirements.txt


CMD ["python", "publish.py"]