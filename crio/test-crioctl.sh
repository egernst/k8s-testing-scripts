POD_ID=$(sudo crioctl pod run --config  redis_sandbox_untrusted.json)
POD_ID2=$(sudo crioctl pod run --config  redis_sandbox_trusted.json)
sudo crioctl pod list
sudo runc list
sudo cc-runtime list

sudo crioctl image pull redis:alpine

CONTAINER_ID=$(sudo crioctl ctr create --pod $POD_ID --config container_redis_untrusted.json)
CONTAINER_ID2=$(sudo crioctl ctr create --pod $POD_ID2 --config container_redis_trusted.json)

sudo crioctl ctr list

sudo runc list
sudo cc-runtime list


sudo crioctl ctr start --id $CONTAINER_ID
sudo crioctl ctr start --id $CONTAINER_ID2

sudo crioctl ctr status --id $CONTAINER_ID
sudo crioctl ctr status --id $CONTAINER_ID2

sudo crioctl ctr stop --id $CONTAINER_ID
sudo crioctl ctr remove --id $CONTAINER_ID

sudo crioctl ctr stop --id $CONTAINER_ID2
sudo crioctl ctr remove --id $CONTAINER_ID2


sudo crioctl pod stop --id $POD_ID
sudo crioctl pod remove --id $POD_ID
sudo crioctl pod stop --id $POD_ID2
sudo crioctl pod remove --id $POD_ID2
sudo crioctl pod list
sudo crioctl ctr list
