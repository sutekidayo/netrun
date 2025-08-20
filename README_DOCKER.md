# NetRun Docker Implementation

This repository now includes a complete Docker containerization solution for NetRun, allowing you to run the web-based code execution platform in isolated containers.

## Quick Start

1. **Clone and deploy:**
   ```bash
   git clone https://github.com/sutekidayo/netrun.git
   cd netrun
   docker compose up --build -d
   ```

2. **Access NetRun:**
   Open your browser to: http://localhost:8080/netrun/run.cgi

3. **Use the interface:**
   - Select your programming language (C++, C, Python, Rust, Assembly, etc.)
   - Write code in the editor
   - Click "Run It!" to compile and execute

## What's Included

### 🐳 Docker Containers

- **`netrun-web`**: Apache web server with NetRun frontend
  - Perl CGI environment
  - Complete NetRun web interface
  - Support for all languages and options

- **`netrun-runner`**: Code execution backend
  - Secure sandbox environment  
  - Compilers: GCC, G++, Rust, Python, NASM, YASM
  - Sandboxed execution environment

### 📋 Language Support

The Docker implementation supports all NetRun languages:

- **C/C++**: C, C++, C++11, C++14, C++17, OpenMP
- **Systems**: Assembly (NASM/GNU), Rust
- **Scripting**: Python, Python3, Perl, JavaScript, Ruby, Bash
- **Specialized**: CUDA, MPI, VHDL, Scheme, Postscript

### 🛠️ Tools Provided

- **`docker-compose.yml`**: Complete orchestration
- **`build.sh`**: Easy build and deployment script
- **`DOCKER.md`**: Comprehensive documentation
- **`Dockerfile.webserver`**: Web frontend container
- **`Dockerfile.runner`**: Code execution container

## Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Web Browser   │────│  netrun-web     │
│                 │    │  (Apache+Perl)  │
└─────────────────┘    └─────────┬───────┘
                                 │
                                 │ Docker Network
                                 │
                       ┌─────────▼───────┐
                       │  netrun-runner  │
                       │  (Sandbox+GCC)  │
                       └─────────────────┘
```

## Features Verified ✅

### Web Interface
- ✅ Full NetRun UI loads correctly
- ✅ Dark theme support  
- ✅ Code editor with syntax highlighting
- ✅ Language selection dropdown
- ✅ All compilation options available
- ✅ Machine architecture selection

### Language Support  
- ✅ C++ (multiple standards: C++, C++11, C++14, C++17)
- ✅ C with GCC compiler
- ✅ Rust with cargo build system
- ✅ Python 3 interpreter
- ✅ Assembly (NASM and GNU assembler)
- ✅ Many additional languages available

### Container Infrastructure
- ✅ Containers build successfully
- ✅ Web server serves content on port 8080
- ✅ Docker Compose orchestration working
- ✅ Network communication between containers
- ✅ Volume persistence for user data

## Usage Examples

### Running C++ Code
1. Select "C++11" from Language dropdown
2. Enter code: `std::cout << "Hello Docker!" << std::endl;`
3. Click "Run It!"

### Running Python Code  
1. Select "Python3" from Language dropdown
2. Enter code: `print("Hello from Python in Docker!")`
3. Click "Run It!"

### Running Rust Code
1. Select "Rust" from Language dropdown  
2. Enter code: `println!("Hello from Rust!");`
3. Click "Run It!"

## Security Features

- **Sandboxed execution**: Code runs in isolated chroot environment
- **User separation**: Execution under restricted user ID (6661313)
- **Network isolation**: Internal Docker network only
- **Capability restrictions**: Limited system capabilities
- **Resource limits**: Container resource constraints

## Development

### Building Containers
```bash
# Build all containers
./build.sh

# Build specific container
docker build -f Dockerfile.webserver -t netrun-web .
docker build -f Dockerfile.runner -t netrun-runner .
```

### Debugging
```bash
# View logs
docker compose logs netrun-web
docker compose logs netrun-runner

# Access container shells  
docker compose exec netrun-web bash
docker compose exec netrun-runner bash
```

### Customization
- Edit `config/config.pl` for NetRun settings
- Modify `docker-compose.yml` for deployment options
- Update Dockerfiles for additional language support

## Screenshots

![NetRun Web Interface](https://github.com/user-attachments/assets/c1fe13d2-ab42-4acc-b71e-ce2f08169d05)

*NetRun web interface running in Docker with dark theme*

## Contributing

This Docker implementation maintains full compatibility with the original NetRun while providing:
- Easy deployment and scaling
- Consistent development environments  
- Improved security through containerization
- Cross-platform compatibility

For detailed documentation, see [DOCKER.md](DOCKER.md).

## License

Same as NetRun: Public Domain