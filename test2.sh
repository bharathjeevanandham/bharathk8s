echo "current working direcoty is $(pwd)"
if [ $? = 0 ]; then
        echo "postgres started successfully"
else
        echo "Error in postgres start, plese investigate"
fi
