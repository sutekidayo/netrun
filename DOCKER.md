# NetRun Docker Deployment Guide

This guide explains how to build and deploy NetRun using Docker containers.

## Overview

NetRun is deployed using two containers:
- **netrun-web**: Apache web server with Perl CGI frontend
- **netrun-runner**: Backend code execution sandbox with compilers

Supported languages:
- C++
- C  
- Python 3
- Rust
- Assembly (NASM/YASM)

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- At least 2GB RAM
- 5GB disk space

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/sutekidayo/netrun.git
cd netrun
```

2. Build and start the containers:
```bash
docker compose up --build -d
```

3. Access NetRun in your browser:
```
http://localhost:8080/netrun/run.cgi
```

## Manual Build Process

### Build Web Server Container

```bash
docker build -f Dockerfile.webserver -t netrun-web .
```

### Build Code Runner Container

```bash
docker build -f Dockerfile.runner -t netrun-runner .
```

### Run Containers Manually

```bash
# Create network
docker network create netrun-network

# Start code runner
docker run -d \
  --name netrun-runner \
  --network netrun-network \
  --privileged \
  --cap-add SYS_ADMIN \
  --cap-add SYS_CHROOT \
  --cap-add SETUID \
  --cap-add SETGID \
  netrun-runner

# Start web server
docker run -d \
  --name netrun-web \
  --network netrun-network \
  -p 8080:80 \
  -e NETRUN_BACKEND_HOST=netrun-runner \
  -e NETRUN_BACKEND_PORT=9922 \
  netrun-web
```

## Configuration

### Environment Variables

**Web Server (netrun-web):**
- `NETRUN_BACKEND_HOST`: Hostname of the code runner (default: netrun-runner)
- `NETRUN_BACKEND_PORT`: Port of the code runner (default: 9922)

**Code Runner (netrun-runner):**
- `NETRUN_PORT`: Port to listen on (default: 9922)

### Custom Configuration

Create a `config/` directory and mount it to `/opt/netrun/config` in the web container to override default settings.

## Usage

### Web Interface

1. Navigate to `http://localhost:8080/netrun/run.cgi`
2. Select a programming language from the dropdown
3. Choose a target machine architecture
4. Enter your code in the text area
5. Click "Run" to compile and execute

### Supported Features

- **Languages**: C, C++, Python 3, Rust, Assembly
- **Execution modes**: Fragment, Full program
- **Architecture**: x86, x86_64, ARM
- **Tools**: Profiling, Disassembly, Debugging output

## Development

### Building from Source

To rebuild containers after making changes:

```bash
# Rebuild all containers
docker compose build --no-cache

# Rebuild specific container
docker compose build --no-cache netrun-web
```

### Debugging

View container logs:
```bash
# Web server logs
docker compose logs -f netrun-web

# Code runner logs  
docker compose logs -f netrun-runner
```

Access container shells:
```bash
# Web server shell
docker compose exec netrun-web bash

# Code runner shell
docker compose exec netrun-runner bash
```

### Adding New Languages

To add support for additional programming languages:

1. Install the compiler/interpreter in `Dockerfile.runner`
2. Update the frontend CGI scripts in `netrun/bin/run.cgi`
3. Add language-specific build rules in `netrun/support/project/Makefile.post`

## Security Considerations

### Sandboxing

The code runner container uses several security mechanisms:
- **Chroot jail**: Isolates file system access
- **User separation**: Execution under low-privilege user (UID 6661313)
- **Capability restrictions**: Limited system capabilities
- **Network isolation**: Internal container network only

### Firewall

For production deployment:
- Only expose port 8080 (web interface)
- Keep port 9922 (runner) internal to Docker network
- Consider additional firewall rules

## Troubleshooting

### Container Won't Start

Check system requirements:
```bash
# Verify Docker version
docker --version
docker compose version

# Check available resources
docker system df
```

### Compilation Errors

Verify compiler installation:
```bash
docker compose exec netrun-runner which gcc
docker compose exec netrun-runner which python3
docker compose exec netrun-runner which rustc
```

### Permission Issues

Reset container permissions:
```bash
docker compose down
docker volume rm netrun_netrun-data
docker compose up --build -d
```

### Web Interface Not Accessible

Check port binding and firewall:
```bash
# Verify port is bound
docker compose ps
netstat -tlnp | grep :8080

# Test local connection
curl http://localhost:8080/netrun/run.cgi
```

## Maintenance

### Updating

Pull latest changes and rebuild:
```bash
git pull origin master
docker compose down
docker compose build --no-cache
docker compose up -d
```

### Cleanup

Remove containers and volumes:
```bash
docker compose down -v
docker system prune -a
```

### Monitoring

Monitor container resources:
```bash
docker stats
```

Check disk usage:
```bash
docker system df
```

## Production Deployment

### Recommendations

- Use a reverse proxy (nginx/traefik) for SSL termination
- Implement rate limiting to prevent abuse
- Monitor container resource usage
- Set up log aggregation
- Regular security updates
- Backup persistent volumes

### Example Nginx Configuration

```nginx
server {
    listen 80;
    server_name netrun.example.com;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## License

NetRun is released under the public domain license.