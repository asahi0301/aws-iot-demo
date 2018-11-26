FROM amazonlinux:2

RUN yum -y install git java-1.8.0-openjdk
ADD amazon-kinesis-client-python/ /amazon-kinesis-client-python
RUN cd /amazon-kinesis-client-python/ && python -m ensurepip && python setup.py install && pip install boto3
COPY sample.properties  /amazon-kinesis-client-python/samples/sample.properties

WORKDIR /amazon-kinesis-client-python/samples

CMD `python amazon_kclpy_helper.py --print_command --java /usr/bin/java --properties sample.properties`