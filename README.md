[🇬🇧 English](README.md) | [🇪🇪 Eesti keel](README.et.md)
# 🪸 CoralChain – A Visual Gadget Collection for Exploring Blockchain Fundamentals

**CoralChain** is a lightweight, web-based blockchain simulation framework built with Ruby and Sinatra. It brings together a collection of visual, interactive gadgets designed to illustrate key concepts such as blockchain structure, multi-node synchronization, and consensus mechanism comparison. This project offers an approachable and hands-on way to explore the fundamental behaviors of blockchain systems in simplified, illustrative scenarios.

## Features

- **Block Operations & Verification**
  - Create and inspect blocks with customizable data and consensus selection  
  - Validate chain integrity via hash links, indexing, and digital signatures  
  - Simulate tampering and observe its effects through real-time visual feedback  

- **Multi-Node Interaction & Synchronization**
  - Run concurrent blockchains on Node A, Node B, and a Byzantine Node X  
  - Simulate Byzantine behavior, including fake chain broadcasting and override attempts  
  - Visualize chain differences, forks, and synchronization across nodes  
  - Apply longest-valid-chain rules to resolve conflicts  

- **Consensus & Network Simulation**
  - Explore PoW, PoS, and PoA mechanisms with adjustable parameters  
  - Benchmark and compare consensus performance using live charts and statistics  
  - Export chain data and experiment results as CSV or Markdown reports  
  - Simulate gossip-based message propagation with visual delays and adversarial interference  

## Tech Stack

- **Language**: Ruby  
- **Framework**: Sinatra  
- **Frontend**: ERB templates, Chart.js

## Deployment

To run the project, simplly do the following:

```bash
# Clone the repository
git clone https://github.com/Xinjian-Zhang/coralchain.git
```

```bash
cd coralchain
```

```bash
# Install dependencies
bundle install
````

```bash
# Start the server
ruby app.rb
```

The application will be available at http://localhost:4567 by default.

### 🐳 Docker Deployment (Recommended)

To quickly run CoralChain in a containerized environment using Docker, follow these steps:

```bash
# Clone the repository
git clone https://github.com/Xinjian-Zhang/coralchain.git
cd coralchain
```

```bash
# Build and start the container
docker-compose up --build
```

Once running, visit:

http://localhost:4567


This will launch CoralChain in a self-contained Docker container, making it easy to explore without installing Ruby or dependencies manually.

## About

**Author**: Xinjian Zhang  
**Institution**: University of Tartu  
**Date**: May 2025  

- GitHub: [github.com/xinjian-Zhang/coralchain](https://github.com/xinjian-Zhang/coralchain)  
- Website: [xinjian-zhang.github.io/coralchain-web](https://xinjian-zhang.github.io/coralchain-web)

## Acknowledgements

Special thanks to **Dr. Mubashar Iqbal** for his guidance and support throughout this project.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
