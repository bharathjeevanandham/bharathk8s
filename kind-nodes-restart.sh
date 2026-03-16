date
echo "STEP 1: restarting control plane"
docker restart kind-control-plane
if [ $? = 0 ]; then
	echo "control plane restarted successfully"
else
	echo "control plane restart FAILED"
fi

echo "STEP 2: restarting worker-1"
docker restart kind-worker
if [ $? = 0 ]; then
        echo "worker1 restarted successfully"
else
        echo "worker1 restart FAILED"
fi

echo "STEP 3: restarting worker-2"
docker restart kind-worker2
if [ $? = 0 ]; then
        echo "worker2 restarted successfully"
else
        echo "worker2 restart FAILED"
fi

echo "STEP 4: restarting worker-3"
docker restart kind-worker3
if [ $? = 0 ]; then
        echo "worker3 restarted successfully"
else
        echo "worker3 restart FAILED"
fi

echo "STEP 5: restarting worker-4"
docker restart kind-worker4
if [ $? = 0 ]; then
        echo "worker4 restarted successfully"
else
        echo "worker4 restart FAILED"
fi
