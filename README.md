Edit the dependencies you need inside the Dockerfile

Edit the Users needed in the container (mine has multiple users because it was just one instance shared across different people)

Edit the startup.sh according to your needs

Build using  
```bash
docker build -t image_tag -f Dockerfile .
```

Then run it by
```bash
docker run --name android_builder -v your_mountpoint_for_the_user:/home/*user* [even more -v commands if more mountpoints needed] -p your_ssh_exposed_port:22 --restart unless-stopped image_tag
```
