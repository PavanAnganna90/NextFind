const { execSync } = require('child_process');

console.log('🚀 Starting Docker-friendly build with relaxed TypeScript...');

try {
  console.log('📦 Building with relaxed TypeScript config...');
  
  // Use relaxed TypeScript config
  execSync('npx next build --no-lint', { 
    stdio: 'inherit',
    env: { 
      ...process.env,
      TS_NODE_PROJECT: 'tsconfig.docker.json'
    }
  });
  
  console.log('✅ Build completed successfully!');
} catch (error) {
  console.error('❌ Build failed:', error.message);
  process.exit(1);
}
