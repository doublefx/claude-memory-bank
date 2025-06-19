# Contributing to Claude Memory Bank

Thank you for your interest in contributing to Claude Memory Bank! This project maintains the original cursor-memory-bank methodology by @vanzan01 while adapting it for Claude Code.

## 🎯 Core Principles

When contributing, please ensure that:

1. **Workflow Integrity**: All contributions must preserve 100% of the original cursor-memory-bank methodology
2. **Attribution**: Proper credit to @vanzan01 for the original methodology
3. **Claude Code Focus**: Enhancements should be specific to Claude Code capabilities
4. **File-Based System**: Maintain the file-based configuration approach

## 🚀 Getting Started

### Development Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/claude-memory-bank.git
   cd claude-memory-bank
   ```

2. **Install dependencies**:
   ```bash
   # For Python automation scripts
   pip install -r requirements-dev.txt
   ```

3. **Test the system**:
   ```bash
   # Make scripts executable
   chmod +x install.sh setup-memory-bank.sh
   
   # Test installation process
   bash install.sh --help
   bash setup-memory-bank.sh --help
   ```

### Testing Your Changes

1. **Test installation flow**:
   ```bash
   # Create test directory
   mkdir test-project && cd test-project
   
   # Run setup
   ../setup-memory-bank.sh
   
   # Verify structure
   ls -la .memory-bank/
   ```

2. **Test mode instructions**:
   - Verify all 6 mode instruction files are complete
   - Check that workflow routing is preserved
   - Ensure CLAUDE.md configuration is comprehensive

3. **Test automation scripts**:
   ```bash
   python .memory-bank/scripts/auto-update.py --help
   ```

## 📋 Contribution Guidelines

### What We Welcome

- **Claude Code Integration Improvements**: Better file-based configuration, enhanced automation
- **Documentation Enhancements**: Clearer instructions, better examples, troubleshooting guides
- **Automation Features**: Pattern detection, decision extraction, cross-project learning
- **Bug Fixes**: Issues with installation, setup, or mode instructions
- **Performance Improvements**: Faster setup, better resource usage

### What We Don't Accept

- **Workflow Changes**: Modifications to the core 6-mode system or complexity routing
- **Methodology Alterations**: Changes to VAN/PLAN/CREATIVE/IMPLEMENT/REFLECT/ARCHIVE roles
- **Non-Claude Code Features**: Integrations with other AI systems or IDEs
- **Breaking Changes**: Modifications that break existing installations

### Code Style

- **Shell Scripts**: Follow standard bash practices, include error handling
- **Python**: Follow PEP 8, use type hints where applicable
- **Markdown**: Use consistent formatting, clear headings, proper links
- **Documentation**: Be clear, concise, and include examples

## 🔄 Submission Process

### 1. Issue First
Before making significant changes, please open an issue to discuss:
- What problem you're solving
- How your solution maintains workflow integrity
- Why the change benefits Claude Code users

### 2. Fork and Branch
```bash
# Fork the repository on GitHub
# Clone your fork
git clone https://github.com/YOUR-USERNAME/claude-memory-bank.git

# Create feature branch
git checkout -b feature/your-improvement-name
```

### 3. Make Changes
- Follow the coding standards
- Test thoroughly
- Update documentation as needed
- Maintain attribution to @vanzan01

### 4. Submit Pull Request
- Clear title describing the change
- Detailed description of what was modified
- Test results and verification steps
- Screenshots if UI/documentation changes

## 📝 Pull Request Template

```markdown
## Description
Brief description of changes and motivation.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Documentation update
- [ ] Performance improvement

## Workflow Integrity Check
- [ ] Preserves original 6-mode system
- [ ] Maintains complexity-based routing
- [ ] Keeps tasks.md as sacred source of truth
- [ ] Preserves @vanzan01 attribution

## Testing
- [ ] Installation tested
- [ ] Setup process verified
- [ ] Mode instructions validated
- [ ] Automation scripts tested

## Documentation
- [ ] README updated if needed
- [ ] Comments added to complex code
- [ ] Examples provided for new features
```

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Environment**:
   - Operating system
   - Shell type (bash/zsh)
   - Python version (if relevant)

2. **Steps to reproduce**:
   - Exact commands run
   - Directory structure
   - Configuration files

3. **Expected vs actual behavior**:
   - What should have happened
   - What actually happened
   - Error messages or logs

4. **Additional context**:
   - Screenshots if helpful
   - Related issues or PRs

## 💡 Feature Requests

For new features, please provide:

1. **Problem statement**: What limitation are you facing?
2. **Proposed solution**: How would you solve it?
3. **Claude Code relevance**: Why is this specific to Claude Code?
4. **Workflow compatibility**: How does this preserve the original methodology?

## 🔍 Code Review Process

1. **Automated checks**: PRs must pass basic validation
2. **Workflow review**: Ensure methodology preservation
3. **Testing verification**: Changes must be tested
4. **Documentation review**: Updates must be clear and accurate
5. **Attribution check**: Proper credit maintained

## 📚 Resources

- **Original methodology**: [cursor-memory-bank](https://github.com/vanzan01/cursor-memory-bank)
- **Claude Code docs**: [Official documentation](https://docs.anthropic.com/claude-code)
- **File system standards**: [GitHub best practices](https://docs.github.com/en/repositories)

## 🤝 Community

- **Discussions**: Use GitHub Discussions for questions
- **Issues**: Use GitHub Issues for bugs and feature requests
- **Attribution**: Always credit @vanzan01 for the original methodology

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License, with proper attribution to @vanzan01 for the original methodology.

---

**Thank you for helping preserve and enhance the Memory Bank methodology for Claude Code!**

*Original methodology by @vanzan01 - Claude Code adaptation by the community*