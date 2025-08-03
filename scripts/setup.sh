#!/bin/bash

# Shorou Team Project Setup Script
echo " Setting up Shorou Team Project..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_requirements() {
    print_status "Checking requirements..."
    
    # Check Go
    if ! command -v go &> /dev/null; then
        print_error "Go is not installed. Please install Go 1.21+"
        exit 1
    fi
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+"
        exit 1
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm"
        exit 1
    fi
    
    # Check Docker (optional)
    if ! command -v docker &> /dev/null; then
        print_warning "Docker is not installed. Docker is optional but recommended."
    fi
    
    print_status "All requirements met!"
}

# Setup Backend
setup_backend() {
    print_status "Setting up Backend..."
    
    cd backend
    
    # Download Go modules
    print_status "Downloading Go modules..."
    go mod download
    
    # Run tests
    print_status "Running backend tests..."
    go test ./...
    
    cd ..
    print_status "Backend setup completed!"
}

# Setup Frontend
setup_frontend() {
    print_status "Setting up Frontend..."
    
    cd frontend
    
    # Install dependencies
    print_status "Installing frontend dependencies..."
    npm install
    
    # Create .env file if it doesn't exist
    if [ ! -f .env ]; then
        print_status "Creating .env file..."
        cat > .env << EOF
REACT_APP_API_URL=http://localhost:8080/api/v1
NODE_ENV=development
EOF
    fi
    
    cd ..
    print_status "Frontend setup completed!"
}

# Setup Database
setup_database() {
    print_status "Setting up Database..."
    
    # Check if Docker is available
    if command -v docker &> /dev/null; then
        print_status "Starting PostgreSQL with Docker..."
        cd docker
        docker-compose up -d postgres
        cd ..
        
        # Wait for database to be ready
        print_status "Waiting for database to be ready..."
        sleep 10
        
        print_status "Database setup completed!"
    else
        print_warning "Docker not available. Please setup PostgreSQL manually."
    fi
}

# Create environment files
create_env_files() {
    print_status "Creating environment files..."
    
    # Backend .env
    if [ ! -f backend/.env ]; then
        cat > backend/.env << EOF
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=password
DB_NAME=shorou_db
JWT_SECRET=your-secret-key-change-in-production
SERVER_PORT=8080
ENVIRONMENT=development
EOF
    fi
    
    print_status "Environment files created!"
}

# Setup Git hooks
setup_git_hooks() {
    print_status "Setting up Git hooks..."
    
    # Create .git/hooks directory if it doesn't exist
    mkdir -p .git/hooks
    
    # Pre-commit hook
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "Running pre-commit checks..."

# Run backend tests
cd backend
go test ./...
if [ $? -ne 0 ]; then
    echo "Backend tests failed!"
    exit 1
fi

# Run frontend linting
cd ../frontend
npm run lint
if [ $? -ne 0 ]; then
    echo "Frontend linting failed!"
    exit 1
fi

echo "Pre-commit checks passed!"
EOF
    
    chmod +x .git/hooks/pre-commit
    print_status "Git hooks setup completed!"
}

# Main setup function
main() {
    print_status "Starting Shorou Team Project setup..."
    
    check_requirements
    create_env_files
    setup_backend
    setup_frontend
    setup_database
    setup_git_hooks
    
    print_status "🎉 Setup completed successfully!"
    print_status "To start development:"
    echo "  Backend: cd backend && go run cmd/main.go"
    echo "  Frontend: cd frontend && npm start"
    echo "  Database: cd docker && docker-compose up -d"
}

# Run main function
main 