# Deploy: tell Tilt what YAML to deploy
k8s_yaml('kubernetes/swish.yaml')

# Build: tell Tilt what images to build from which directories
docker_build('swish', '.')

# Watch: tell Tilt how to connect locally (optional)
k8s_resource('swish', port_forwards=8080)
