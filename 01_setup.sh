ENDPOINT=`aws iot describe-endpoint --endpoint-type iot:Data-ATS --region ap-northeast-1 | jq -r '.endpointAddress'`

echo "Your IoT Endpoint is : " $ENDPOINT
sed -e "s/ENDPOINT/${ENDPOINT}/g" scripts/publish-original.py > scripts/publish.py
sed -e "s/ENDPOINT/${ENDPOINT}/g" scripts/subscribe-original.py > scripts/subscribe.py

echo "Generating your device cert...."
OUTPUT=`aws iot create-keys-and-certificate --set-as-active --region ap-northeast-1`

certificateArn=`echo $OUTPUT | jq -r '.certificateArn'`
certificatePem=`echo $OUTPUT | jq  '.certificatePem'`
PrivateKey=`echo $OUTPUT | jq  '.keyPair.PrivateKey'`

echo "Your certificateArn is : " $certificateArn
echo "Your certificatePem is : " $certificatePem
echo "Your PrivateKey is : " $PrivateKey

echo $certificatePem | sed  "s/\"//g" | sed  "s/\\\n/\n/g" > cert/certificate.pem
echo $PrivateKey | sed  "s/\"//g" | sed  "s/\\\n/\n/g" > cert/private.pem

echo "Creating demo-policy..."
aws iot create-policy --policy-name "demo-policy" --policy-document '{"Version": "2012-10-17", "Statement": [    {      "Effect": "Allow",      "Action": "iot:*",      "Resource": "*"    }  ]}'  --region ap-northeast-1

echo "Attaching demo-policy to generated cert..."
aws iot attach-policy --policy-name "demo-policy" --target $certificateArn --region ap-northeast-1

echo "Building docker image. Tag is aws-iot-demo:latest"
docker build -t aws-iot-demo .

echo "Run 'docker run --rm -it aws-iot-demo:latest'"
echo "message will be published to demo/test topic"